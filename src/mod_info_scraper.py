import re
from dataclasses import dataclass

import requests


@dataclass
class ModIdPattern:
    """Data structure representing a potential Mod id pattern
    """
    regex_pattern: str
    group_index: int


def scrape_workshop_link(url: str) -> str:
    return requests.get(url).text


def parse_mod_id(website_html: str) -> str | None:
    patterns = [
        ModIdPattern(r'Mod ID: (.*)(?=<\/div>)', 1),
        ModIdPattern(r'Mod ID:\t(.*)\t(.*)\t<\/div>', 2),
    ]
    with open('test.txt', 'w', encoding='utf-8') as file:
        file.write(website_html)
    for pattern in patterns:
        mod_id = re.search(pattern.regex_pattern, website_html)
        if mod_id is not None:
            break

    if mod_id is None:
        return None

    return mod_id.group(pattern.group_index)


def parse_workshop_id(url: str) -> str | None:
    return url.split('id=')[-1]


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
