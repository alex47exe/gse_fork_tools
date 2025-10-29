
class SaveFileModel:
    def __init__(self, root: str, path_after_root: str, platforms: set[str]):
        self.root = root
        self.path_after_root = path_after_root
        self.platforms = platforms or set()


class SaveFileOverrideModel:
    def __init__(self,
            root_original: str, root_new: str, path_after_root_new: str,
            platform: str, paths_to_transform: list[tuple[str, str]]
        ):
        self.root_original = root_original
        self.root_new = root_new
        self.path_after_root_new = path_after_root_new
        self.platform = platform
        self.paths_to_transform = paths_to_transform or []

class Ufs:
    def __init__(self, save_files: list[SaveFileModel] = None, save_file_overrides: list[SaveFileOverrideModel] = None):
        self.save_files = save_files or []
        self.save_file_overrides = save_file_overrides or []


def parse_cloud_dirs(game_info: dict[str, object]) -> tuple[list[SaveFileModel], list[SaveFileOverrideModel]]:
    save_files_raw: list[dict] = game_info.get("ufs", {}).get("savefiles", {}).values()
    if not save_files_raw:
        return ([], [])
    
    save_files: list[SaveFileModel] = []
    for item in save_files_raw:
        root: str = item.get("root", "")
        if not root:
            continue

        path: str = item.get("path", "")
        platforms: set[str] = set(item.get("platforms", {}).values())
        save_files.append(SaveFileModel(
            root=root, path_after_root=path, platforms=platforms
        ))

    root_overrides_raw: list[dict] = game_info.get("ufs", {}).get("rootoverrides", {}).values()
    root_overrides: list[SaveFileOverrideModel] = []
    for item in root_overrides_raw:
        root_original = item.get("root", "")
        root_new = item.get("useinstead", "")
        platform = item.get("os", "")
        if not root_original:
            print("[?] UFS override has empty root original/new, or empty platform")
            continue

        os_compare = item.get("oscompare", "")
        if os_compare != "=":
            print(f"[?] UFS override for {root_original}@{platform} >> {root_new} has unknown OS comparison operation '{os_compare}'")

        path_after_root_new = item.get("addpath", "")
        paths_to_transform: list[tuple[str, str]] = list(map(
            lambda obj: (obj.get("find", ""), obj.get("replace", "")),
            item.get("pathtransforms", {}).values()
        ))
        root_overrides.append(SaveFileOverrideModel(
            root_original=root_original, root_new=root_new, path_after_root_new=path_after_root_new,
            platform=platform, paths_to_transform=paths_to_transform
        ))
    
    return (save_files, root_overrides)


def get_ufs_dirs(
        platform: str,
        save_files: list[SaveFileModel],
        save_file_overrides: list[SaveFileOverrideModel]
    ) -> list[str]:
    def sanitize_path(path: str) -> str:
        # appid 292930 sets "path=/"
        path = path.strip("/")
        # appid 282800 sets "path=save/{64BitSteamID}/."
        while path.endswith("/."):
            path = path[:-2]
        while path.startswith("./"):
            path = path[2:]

        # remove any "/." in between
        while True:
            fidx = path.find("/./")
            if fidx < 0:
                break
            path = path[:fidx] + path[fidx + 2:]

        if "." == path:
            return ""

        return path

    def fixup_vars(path: str) -> str:
        return path.replace(
                "{64BitSteamID}", "{::64BitSteamID::}"
            ).replace(
                "{Steam3AccountID}", "{::Steam3AccountID::}"
            )
    
    if not save_files:
        return []
    
    # add base save files
    ufs = Ufs()
    for item in save_files:
        if not item.platforms: # all platforms
            ufs.save_files.append(item)
        elif any(platfrom.upper() == "ALL" for platfrom in item.platforms):
            # appid 130 and appid 50 use "all"
            ufs.save_files.append(item)
        elif any(platfrom.upper() == platform.upper() for platfrom in item.platforms):
            ufs.save_files.append(item)
    
    # add overrides
    for item in save_file_overrides:
        if item.platform.upper() == platform.upper():
            ufs.save_file_overrides.append(item)

    # format the root identifiers like this:
    # {SteamCloudDocuments} >> {::SteamCloudDocuments::}
    # this char ':' is illegal on all OSes and fails to create a dir
    # if any idetifier was not substituted
    # some games like appid 388880 have broken config, the emu can
    # then easily detect that by looking for the pattern "::" or "{::"
    # and decide the appropriate action to take

    paths: set[str] = set()
    # if we have overrides then only use them
    if ufs.save_file_overrides:
        for ufs_override in ufs.save_file_overrides:
            new_path = f"{{::{ufs_override.root_new.strip()}::}}"
            path_after_root_new = sanitize_path(ufs_override.path_after_root_new.replace("\\", "/"))
            if path_after_root_new:
                new_path += f"/{path_after_root_new}"
            
            save_files_to_override: list[SaveFileModel] = list(filter(
                lambda save: save.root.upper() == ufs_override.root_original.upper(),
                ufs.save_files
            ))
            for save_file in save_files_to_override:
                # don't sanitize "save_file.path_after_root" yet, we need to find and replace substrings
                path_after_root_original = save_file.path_after_root.replace("\\", "/")
                for (find, replace) in ufs_override.paths_to_transform:
                    find = find.replace("\\", "/")
                    replace = replace.replace("\\", "/")
                    if find and path_after_root_original:
                        path_after_root_original = path_after_root_original.replace(find, replace)
                    elif not find and not path_after_root_original:
                        # when "override.find" and "root.path" are both empty
                        # it is expected to use the replace string directly
                        # example: appid 2174720
                        path_after_root_original = replace
                    else:
                        print(
                            f"UFS override for {save_file.root}@{ufs_override.platform} >> {ufs_override.root_new} has empty 'find' string, " +
                            f"or original UFS has empty 'path' string, ignoring"
                        )
                
                path_after_root_original = sanitize_path(path_after_root_original)
                if path_after_root_original:
                    new_path += f"/{path_after_root_original}"
                
                paths.add(fixup_vars(new_path))
    else: # otherwise (no overrides) use all relevant UFS entries
        for save_file in ufs.save_files:
            new_path = f"{{::{save_file.root.strip()}::}}"
            path_after_root = sanitize_path(save_file.path_after_root.replace("\\", "/"))
            if path_after_root:
                new_path += f"/{path_after_root}"
            
            paths.add(fixup_vars(new_path))
    

    return list(paths)
