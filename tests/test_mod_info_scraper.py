import pytest

import src.mod_info_scraper as mod_info_scraper


class Test_scrape_workshop_link:
    def test_invalid_link(self) -> None:
        link = 'https://steamcommunity.com/sharedfiles/filedetails/?id=apwd'
        with pytest.raises(Exception):
            mod_info_scraper.scrape_workshop_link(link)

    def test_valid_link(self) -> None:
        link = 'https://steamcommunity.com/sharedfiles/filedetails/?id=2790006091'
        html = mod_info_scraper.scrape_workshop_link(link)
        assert isinstance(html, str)

# todo separate scrape_workshop_link() into its own test


class Test_something:
    @pytest.mark.parametrize(
        'link, expected_mod_id, expected_workshop_id',
        [
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2790006091',
                'craftable-lights-robboinnit',
                '2790006091',
                id='regular'
            ),
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2857548524',
                'ISA_41',
                '2857548524',
                id='table'
            ),
        ]
    )
    def test_thing(self, link: str, expected_mod_id: int, expected_workshop_id: str) -> None:
        website_html = mod_info_scraper.scrape_workshop_link(link)
        mod_id = mod_info_scraper.parse_mod_id(website_html)
        workshop_id = mod_info_scraper.parse_workshop_id(link)

        assert mod_id == expected_mod_id
        assert workshop_id == expected_workshop_id
