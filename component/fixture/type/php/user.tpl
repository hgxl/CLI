<?php

namespace Fixture;

class {{ file.name }}
{
    public function getUserAvatarDataFixture
    {
        return {{ data.avatar }};
    }

    public function getUserEmailDataFixture
    {
        return {{ data.email }};
    }

    public function getUserFirstnameDataFixture
    {
        return {{ data.firstname }};
    }

    public function getUserLastnameDataFixture
    {
        return {{ data.lastname }};
    }

    public function getUserPasswordDataFixture
    {
        return {{ data.password }};
    }
}