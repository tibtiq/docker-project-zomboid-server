# pylint: disable=C0114, C0115, C0116, R0903

import json
import os
import pathlib

import pytest

from src import mod_info_scraper


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
                ['craftable-lights-robboinnit'],
                id='regular'
            ),
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2857548524',
                ['ISA_41'],
                id='table'
            ),
        ]
    )
    def test_parse_from_html(self, link: str, expected_mod_id: str) -> None:
        website_html = mod_info_scraper.scrape_workshop_link(link)
        mod_id = mod_info_scraper.parse_mod_id(website_html)

        assert mod_id == expected_mod_id

    @pytest.mark.parametrize(
        'html, expected_mod_id',
        [
            pytest.param(
                '<br>Mod ID: craftable-lights-robboinnit</div>',
                ['craftable-lights-robboinnit'],
                id='regular'
            ),
            pytest.param(
                '<div class="bb_table_td">	Mod ID:	</div><div class="bb_table_td">	ISA_41	</div></div></div></div></div>',
                ['ISA_41'],
                id='table'
            ),
        ]
    )
    def test_parse_from_str(self, html: str, expected_mod_id: str) -> None:
        mod_id = mod_info_scraper.parse_mod_id(html)

        assert mod_id == expected_mod_id


class TestParseWorkshopId:
    @pytest.mark.parametrize(
        'link, expected_workshop_id',
        [
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2790006091',
                2790006091,
            ),
            pytest.param(
                'https://steamcommunity.com/sharedfiles/filedetails/?id=2857548524',
                2857548524,
            ),
        ]
    )
    def test_parse_from_link(self, link: str, expected_workshop_id: str) -> None:
        workshop_id = mod_info_scraper.parse_workshop_id(link)

        assert workshop_id == expected_workshop_id


class TestIntegration:
    def test_mod_list(self) -> None:
        mods_file_path = pathlib.Path(
            os.path.abspath(__file__)).parent / 'mods.json'
        with open(mods_file_path, encoding='utf-8') as file:
            mods = json.load(file)

        for mod_link, mod_info in mods.items():
            expected_workshop_id = mod_info['workshop_id']
            expected_mod_id = mod_info['mod_id']

            website_html = mod_info_scraper.scrape_workshop_link(mod_link)
            mod_id = mod_info_scraper.parse_mod_id(website_html)
            assert mod_id == expected_mod_id

            workshop_id = mod_info_scraper.parse_workshop_id(mod_link)
            assert workshop_id == expected_workshop_id
