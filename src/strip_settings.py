import pathlib
import sys
import os


def strip_settings(server_settings_path: pathlib.Path) -> str:
    """Strip settings file of comments and newlines.

    Args:
        server_settings_path: Path to settings file to strip.

    Returns:
        stripped_settings: Settings without the comments and newlines.

    """
    settings = []
    with open(server_settings_path) as file:
        for line in file:
            line = line.strip()

            # skip comments and empty lines
            if len(line) != 0 and line[0] != '#':
                settings.append(line)

    stripped_settings = '\n'.join(settings)
    return stripped_settings


def export_stripped_settings(settings: str, output_path: pathlib.Path) -> None:
    """Save settings to a file.

    Args:
        settings: Settings to save to a file.
        output_path: Path to file to save settings to.

    Returns:
        None        
    """
    with open(output_path, 'w') as file:
        file.write(settings)


if __name__ == '__main__':
    settings = strip_settings(pathlib.Path(sys.argv[1]))
    output_dir = pathlib.Path(os.getcwd()).parent / 'res' / 'default_settings.txt'
    export_stripped_settings(settings, output_dir)
