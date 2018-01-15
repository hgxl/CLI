<?php

namespace Fixture;

class {{ file.name }}
{
    public function getCompanyCountryDataFixture
    {
        return {{ data.country }};
    }

    public function getCompanyDescriptionDataFixture
    {
        return {{ data.description }};
    }

    public function getCompanyLogoDataFixture
    {
        return {{ data.logo }};
    }

    public function getCompanyNameDataFixture
    {
        return {{ data.name }};
    }

    public function getCompanySectorDataFixture
    {
        return {{ data.sector }};
    }

    public function getCompanyTurnoverDataFixture
    {
        return {{ data.turnover }};
    }
}