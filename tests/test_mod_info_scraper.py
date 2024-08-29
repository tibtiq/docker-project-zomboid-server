# pylint: disable=C0114, C0115, C0116, R0903

import pytest

import src.mod_info_scraper as mod_info_scraper


class TestScrapeWorkshopLink:
    def test_invalid_link(self) -> None:
        link = 'https://steamcommunity.com/sharedfiles/filedetails/?id=apwd'
        with pytest.raises(Exception):
            mod_info_scraper.scrape_workshop_link(link)

    def test_valid_link(self) -> None:
        link = 'https://steamcommunity.com/sharedfiles/filedetails/?id=2790006091'
        html = mod_info_scraper.scrape_workshop_link(link)
        assert isinstance(html, str)


class TestParseModId:
    @pytest.mark.parametrize(
        'link, expected_mod_id',
        [
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2790006091',
                'craftable-lights-robboinnit',
                id='regular'
            ),
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2857548524',
                'ISA_41',
                id='table'
            ),
        ]
    )
    def test_parse_from_regular(self, link: str, expected_mod_id: str) -> None:
        website_html = mod_info_scraper.scrape_workshop_link(link)
        mod_id = mod_info_scraper.parse_mod_id(website_html)

        assert mod_id == expected_mod_id


class TestParseWorkshopId:
    @pytest.mark.parametrize(
        'link, expected_workshop_id',
        [
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2790006091',
                '2790006091',
            ),
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2857548524',
                '2857548524',
            ),
        ]
    )
    def test_parse_from_link(self, link: str, expected_workshop_id: str) -> None:
        workshop_id = mod_info_scraper.parse_workshop_id(link)

        assert workshop_id == expected_workshop_id
