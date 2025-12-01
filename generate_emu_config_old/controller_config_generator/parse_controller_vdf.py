# Controller VDF script by mr_goldberg
# Generates controller config from a vdf

import vdf
import sys
import os
import traceback

keymap_digital = {
    "button_a": "A", "a": "A",
    "button_b": "B", "b": "B",
    "button_x": "X", "x": "X",
    "button_y": "Y", "y": "Y",
    "dpad_north": "DUP", "dpad_up": "DUP",
    "dpad_south": "DDOWN", "dpad_down": "DDOWN",
    "dpad_east": "DRIGHT", "dpad_right": "DRIGHT",
    "dpad_west": "DLEFT", "dpad_left": "DLEFT",
    "button_escape": "START", "start": "START",
    "button_menu": "BACK", "select": "BACK",
    "left_bumper": "LBUMPER", "shoulder_left": "LBUMPER",
    "right_bumper": "RBUMPER", "shoulder_right": "RBUMPER",
    "button_back_left": "A",
    "button_back_right": "X",
    "button_back_left_upper": "B",
    "button_back_right_upper": "Y",
    "button_capture": "SHARE",
    "joystick_left": "LSTICK", "joystick_right": "RSTICK",
    "joystick_left_click": "LSTICK", "joystick_right_click": "RSTICK",
    "trigger_left": "LTRIGGER", "trigger_right": "RTRIGGER",
    "click": "CLICK",
    "edge": "EDGE",
}

def print_status(message: str, status: str = "info") -> None:
    status_symbols = {
        "success": "[V]",
        "error":   "[X]",
        "info":    "[>]",
        "warn":    "[!]",
    }
    symbol = status_symbols.get(status, "[ ]")
    print(f"{symbol} {message}")

def print_help() -> None:
    exe = os.path.basename(sys.argv[0])
    print(f"""
Usage: {exe} <controller_vdf_file.vdf>
At least one .vdf file must be provided.

Examples:
  {exe} xbox_controller_config.vdf
  {exe} xboxone_controller.vdf xbox360_controller.vdf
""")

def add_input_bindings(group, bindings, force_binding=None, keymap=None):
    if keymap is None:
        keymap = keymap_digital
    if "inputs" not in group:
        return bindings

    for input_name, input_val in group["inputs"].items():
        for act_name, act_val in input_val.items():
            if not isinstance(act_val, dict):
                continue
            for press_type, press_val in act_val.items():
                if not isinstance(press_val, dict):
                    continue
                for bind_type, bind_val in press_val.items():
                    if bind_type.lower() != "bindings" or not isinstance(bind_val, dict):
                        continue
                    for bbd, ss in bind_val.items():
                        if bbd.lower() == 'binding':
                            st = ss.split()
                            if len(st) < 2:
                                continue
                            binding_type = st[0].lower()
                            action_name = None
                            supported_binding = False

                            if binding_type == 'game_action':
                                supported_binding = True
                                if len(st) > 2:
                                    action_name = st[2].rstrip(",")
                            elif binding_type in ('xinput_button', 'controller_action'):
                                supported_binding = True
                                action_name = st[1].rstrip(",")
                            else:
                                continue

                            if supported_binding and action_name:
                                keymap_key = input_name.lower()
                                binding = force_binding if force_binding else keymap.get(keymap_key, keymap.get(action_name.lower()))
                                if binding:
                                    if action_name in bindings:
                                        if binding not in bindings[action_name]:
                                            bindings[action_name].append(binding)
                                    else:
                                        bindings[action_name] = [binding]
                                else:
                                    print_status(f"Missing keymap for '{input_name}' ({action_name})", "warn")
    return bindings

def generate_controller_config(controller_vdf: str, config_dir: str) -> None:
    data = vdf.loads(controller_vdf, mapper=vdf.VDFDict, merge_duplicate_keys=False)
    mappings = data["controller_mappings"]

    def get_all_for(mapping, key):
        if hasattr(mapping, "get_all_for"):
            return mapping.get_all_for(key)
        return [v for k, v in mapping.items() if k == key]

    groups = get_all_for(mappings, "group")
    groups_byid = {g["id"]: g for g in groups}

    actions = get_all_for(mappings, "actions")
    action_list = [k for a in actions for k in a]

    presets = get_all_for(mappings, "preset")
    all_bindings = {}

    for preset in presets:
        name = preset["name"]
        if action_list and (name not in action_list) and name.lower() != 'default':
            continue
        group_bindings = preset["group_source_bindings"]
        bindings = {}

        for number, val in group_bindings.items():
            s = val.split()
            if len(s) < 2:
                continue
            mode, status = s[0].lower(), s[1].lower()
            if status != "active":
                continue

            group = groups_byid.get(number)
            if not group:
                continue

            if mode in ["switch", "button_diamond", "dpad", "single_button"]:
                bindings = add_input_bindings(group, bindings)
            elif mode in ["left_trigger", "right_trigger"]:
                if group["mode"].lower() == "trigger":
                    for gk, gv in group.items():
                        if gk.lower() == "gameactions" and name in gv:
                            action_name = gv[name]
                            binding = "LTRIGGER" if mode == "left_trigger" else "RTRIGGER"
                            if action_name in bindings:
                                if binding not in bindings[action_name] and (binding + "=trigger") not in bindings[action_name]:
                                    bindings[action_name].insert(0, binding)
                            else:
                                bindings[action_name] = [binding + "=trigger"]
                        if gk.lower() == "inputs":
                            binding = "DLTRIGGER" if mode == "left_trigger" else "DRTRIGGER"
                            bindings = add_input_bindings(group, bindings, binding)
                else:
                    print_status(f"Unhandled trigger mode: {group['mode']}", "warn")
            elif mode in ["joystick", "right_joystick"]:
                if group["mode"].lower() in ["joystick_move", "joystick_mouse"]:
                    for gk, gv in group.items():
                        if gk.lower() == "gameactions" and name in gv:
                            action_name = gv[name]
                            binding = "LJOY" if mode == "joystick" else "RJOY"
                            if action_name in bindings:
                                if binding not in bindings[action_name] and (binding + "=joystick_move") not in bindings[action_name]:
                                    bindings[action_name].insert(0, binding)
                            else:
                                bindings[action_name] = [binding + "=joystick_move"]
                        if gk.lower() == "inputs":
                            binding = "LSTICK" if mode == "joystick" else "RSTICK"
                            bindings = add_input_bindings(group, bindings, binding)
                elif group["mode"].lower() == "dpad":
                    if mode == "joystick":
                        binding_map = {
                            "dpad_north": "DLJOYUP", "dpad_south": "DLJOYDOWN",
                            "dpad_west": "DLJOYLEFT", "dpad_east": "DLJOYRIGHT", "click": "LSTICK"
                        }
                        bindings = add_input_bindings(group, bindings, keymap=binding_map)
                    elif mode == "right_joystick":
                        binding_map = {
                            "dpad_north": "DRJOYUP", "dpad_south": "DRJOYDOWN",
                            "dpad_west": "DRJOYLEFT", "dpad_east": "DRJOYRIGHT", "click": "RSTICK"
                        }
                        bindings = add_input_bindings(group, bindings, keymap=binding_map)
                else:
                    print_status(f"Unhandled joy mode: {group['mode']}", "warn")
            else:
                if "inputs" in group:
                    bindings = add_input_bindings(group, bindings)

        all_bindings[name] = bindings

    if all_bindings:
        os.makedirs(config_dir, exist_ok=True)
        for preset_name, binding_map in all_bindings.items():
            out_path = os.path.join(config_dir, f'{preset_name}.txt')
            with open(out_path, 'w', encoding='utf-8') as f:
                for action, keys in binding_map.items():
                    f.write(f"{action}={','.join(keys)}\n")
            print_status(f"Created config: {out_path}", "success")

def main():
    if len(sys.argv) < 2:
        print_help()
        sys.exit(1)

    for vdf_file in sys.argv[1:]:
        try:
            print_status(f"Parsing controller file '{vdf_file}'", "info")
            with open(vdf_file, 'rb') as f:
                content = f.read().decode('utf-8')
            if content:
                filename = os.path.basename(vdf_file)
                outdir = os.path.join(f"{filename}_config", "steam_settings", "controller")
                print_status(f"Output directory: {outdir}", "info")
                generate_controller_config(content, outdir)
            else:
                print_status("Couldn't load file", "error")
            print('-' * 40)
        except Exception as e:
            print_status("Unexpected error occurred.", "error")
            print(str(e))
            print(traceback.format_exc())
            print('-' * 40)
    sys.exit(0)

if __name__ == '__main__':
    main()