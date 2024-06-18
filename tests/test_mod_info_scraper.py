import pytest

import src.mod_info_scraper as mod_info_scraper


class Test_something:
    @pytest.mark.parametrize(
        'url, expected_mod_id, expected_workshop_id',
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
    def test_thing(self, url: str, expected_mod_id: int, expected_workshop_id: str) -> None:
        website_html = mod_info_scraper.scrape_workshop_link(url)
        mod_id = mod_info_scraper.parse_mod_id(website_html)
        workshop_id = mod_info_scraper.parse_workshop_id(url)

        assert mod_id == expected_mod_id
        assert workshop_id == expected_workshop_id
