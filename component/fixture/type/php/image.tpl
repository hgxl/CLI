<?php

namespace Fixture;

class {{ file.name }}
{
    public function getImageNameDataFixture()
    {
        return {{ data.name }};
    }

    public function getImagePathDataFixture()
    {
        return {{ data.path }};
    }
}