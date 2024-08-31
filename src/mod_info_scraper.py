# todo add option to parse from subscribed mods on steam
# todo add option to parse from steam collection
# todo support maps
# todo support mods with multiple mod ids

import re
from dataclasses import dataclass

import requests


@dataclass
class ModIdPattern:
    """Data structure representing a potential mod id pattern
    """
    regex_pattern: str
    group_index: int


def scrape_workshop_link(link: str) -> str:
    html = requests.get(link, timeout=10).text

    if '<title>Steam Community :: Error</title>' in html:
        raise Exception('invalid link')

    return html


def parse_mod_id(website_html: str) -> list[str] | None:
    patterns = [
        ModIdPattern(r'<br>Mod ID: (.*?)<\/b>', 1),
        ModIdPattern(r'<br>Mod ID: (.*?)<br>', 1),
        ModIdPattern(
            r'Mod ID: (.*?)(<\/blockquote>)?(</ul></li></ul>)?<\/div>', 1),
        ModIdPattern(r'Mod\sID:\s(.*)\t(.*)\t<\/div>', 2),
    ]
    for pattern in patterns:
        mod_id = re.search(pattern.regex_pattern, website_html)
        if mod_id is not None:
            break

    if mod_id is None:
        return None

    return [mod_id.group(pattern.group_index)]


def parse_workshop_id(link: str) -> int | None:
    return int(link.split('id=')[-1])


def main() -> None:
    """Script entry point directly run.
    """
    workshop_link = 'https://steamcommunity.com/sharedfiles/filedetails/?id=2790006091'
    website_html = scrape_workshop_link(workshop_link)
    mod_id = parse_mod_id(website_html)
    print(f'mod id: {mod_id}')
    workshop_id = parse_workshop_id(workshop_link)
    print(f'workshop id: {workshop_id}')


if __name__ == '__main__':
    main()
