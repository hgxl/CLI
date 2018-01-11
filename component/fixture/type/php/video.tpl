<?php

namespace Fixture;

class {{ file.name }}
{
    public function getVideoCoverDataFixture()
    {
        return {{ data.cover }};
    }

    public function getVideoNameDataFixture()
    {
        return {{ data.name }};
    }

    public function getVideoPathDataFixture()
    {
        return {{ data.path }};
    }
}