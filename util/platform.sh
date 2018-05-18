#!/bin/bash

PLATFORM_MACOS='Darwin'
PLATFORM_LINUX='Linux'

function is_macOS() {
    [[ $(uname) = ${PLATFORM_MACOS} ]]
}

function is_Linux() {
    [[ $(uname) = ${PLATFORM_LINUX} ]]
}
