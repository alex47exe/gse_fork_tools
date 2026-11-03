    user_name = ''
    user_repl = ''
    if platform.system() == "Windows": # Windows
        user_name = os.getenv("USERNAME") or ""
        user_repl = r'%username%'
    elif platform.system() == "Linux": # Linux
        user_name = os.getenv("USER") or ""
        user_repl = r'$user'
    elif platform.system() == "Darwin": # macOS
        user_name = os.getenv("USER") or ""
        user_repl = r'$user'

    def mask_user_in_path(path_value):
        if not path_value or not user_name:
            return path_value
        return path_value.replace(user_name, user_repl, 1)

    username = os.getenv("USERNAME") or os.getenv("USER") or ""

    for appid in appids:

        print(" ")
        print(f"*** STARTED config for app id {appid} ***")
        print(" ")

        raw = client.get_product_info(apps=[appid])
        if raw["apps"]:
            print(f"[ ] Found app id on Steam store")
        else:
            print(f"[X] Cannot find app id on Steam store")
            print(" ")
            print(f"*** ABORTED config for app id {appid} ***")
            print(" ")
            break

        game_info : dict = raw["apps"][appid]
        game_info_common : dict = game_info.get("common", {})
        app_name = game_info_common.get("name", "")
        app_name_on_disk = f"{appid}"
        if app_name:
            print(f"[ ] Found app name on Steam store")
            print(f"[ ] __ orig name: '{app_name}'")
            sanitized_name = safe_name.create_safe_name(app_name)
            if sanitized_name:
                print(f"[ ] __ safe name: '{sanitized_name}'")
                if SAVE_APP_NAME:
                    app_name_on_disk = f'{sanitized_name} _ {appid}'
        else:
            app_name = f"Unknown_Steam_app_{appid}" # we need this for later use in the Achievement Watcher
            print(f"[X] Cannot find app name on Steam store")

        #root_backup_dir = os.path.join(get_exe_dir(False), "_BACKUP") # replaced 'RELATIVE_DIR with 'False' to always look for or create _BACKUP in generate_emu_config folder
        #backup_dir = os.path.join(root_backup_dir, f"{appid}")
        #if not os.path.exists(backup_dir):
        #    os.makedirs(backup_dir)

        root_def_dir_RELATIVE = os.path.join(get_exe_dir(True), "_DEFAULT") # _DEFAULT folder relative to external bat, sh or app calling generate_emu_config exe; with get_exe_dir(False) is only relative to generate_emu_config exe
        root_out_dir_RELATIVE = os.path.join(get_exe_dir(True), "_OUTPUT") # _OUTPUT folder relative to external bat, sh or app calling generate_emu_config exe; with get_exe_dir(False) is only relative to generate_emu_config exe

        if RELATIVE_DIR:
            if RELATIVE_set == 'out':
                root_out_dir = os.path.join(get_exe_dir(True), "_OUTPUT")
                base_out_dir = os.path.join(root_out_dir, app_name_on_disk)
                CLEANUP_override = 0
            elif RELATIVE_set == 'raw':
                root_out_dir = os.path.join(get_exe_dir(True))
                base_out_dir = os.path.join(get_exe_dir(True))
                CLEANUP_override = 1
                
            if os.path.exists(root_def_dir_RELATIVE) and os.path.isdir(root_def_dir_RELATIVE):
                if os.listdir(root_def_dir_RELATIVE):
                    root_def_dir = os.path.join(get_exe_dir(True), "_DEFAULT")
                else:
                    root_def_dir = os.path.join(get_exe_dir(False), "_DEFAULT")
            else:
                root_def_dir = os.path.join(get_exe_dir(False), "_DEFAULT")
        else:
            root_out_dir = os.path.join(get_exe_dir(False), "_OUTPUT")
            base_out_dir = os.path.join(root_out_dir, app_name_on_disk)
            CLEANUP_override = 0

            root_def_dir = os.path.join(get_exe_dir(False), "_DEFAULT")

        emu_settings_dir = os.path.join(base_out_dir, "steam_settings")
        info_out_dir = os.path.join(base_out_dir, "steam_misc", "app_info")

        print(f"[ ] DEF_DIR = {mask_user_in_path(root_def_dir)}")
        if RELATIVE_DIR and (RELATIVE_set == 'raw'):
            print(f"[ ] OUT_DIR = {mask_user_in_path(os.getcwd())}")
        else:
            print(f"[ ] OUT_DIR = {mask_user_in_path(base_out_dir)}")
