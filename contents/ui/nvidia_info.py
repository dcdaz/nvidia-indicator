#!/usr/bin/env python3
"""
Description: Simple Python3 script that shows info from NVIDIA cards
Author: Daniel Córdova A.
E-Mail : danesc87@gmail.com
Github : @danesc87
Released under GPLv3
"""

def get_nvidia_full_info():
    import os
    from xml.etree import ElementTree

    nvidia_raw_data = os.popen('nvidia-smi -q -x').read()
    if nvidia_raw_data == '' or 'NVIDIA-SMI has failed' in nvidia_raw_data:
        print('Nvidia Card is not ready!')
        import sys
        sys.exit(1)
    try:
        nvidia_xml_data = ElementTree.fromstring(nvidia_raw_data)
    except ElementTree.ParseError:
        print('Cannot parse NVIDIA-SMI data')
        import sys
        sys.exit(1)
    card_name = nvidia_xml_data.find('.//product_name')
    driver_version = nvidia_xml_data.find('.//driver_version')
    total_memory = nvidia_xml_data.find('.//fb_memory_usage/total')
    used_memory = nvidia_xml_data.find('.//fb_memory_usage/used')
    free_memory = nvidia_xml_data.find('.//fb_memory_usage/free')
    temperature = nvidia_xml_data.find('.//temperature/gpu_temp')
    graphics_clock = nvidia_xml_data.find('.//clocks/graphics_clock')
    sm_clock = nvidia_xml_data.find('.//clocks/sm_clock')
    mem_clock = nvidia_xml_data.find('.//clocks/mem_clock')
    video_clock = nvidia_xml_data.find('.//clocks/video_clock')

    return """- Name: {}
    - Driver:         {}
    - Memory:
      - Total:     {}
      - Used:      {}
      - Free:      {}
    - Clocks:
      - Graphics:  {}
      - SM:        {}
      - Mem:       {}
      - Video:     {}
    - Temperature:    {}
    """.format(
        card_name.text,
        driver_version.text,
        total_memory.text,
        used_memory.text,
        free_memory.text,
        graphics_clock.text,
        sm_clock.text,
        mem_clock.text,
        video_clock.text,
        temperature.text,
    )


def get_nvidia_compact_info():
    import os

    nvidia_raw_data = os.popen('nvidia-smi -q -d TEMPERATURE | grep "GPU Current Temp"').read().strip()
    if nvidia_raw_data == '' or 'NVIDIA-SMI has failed' in nvidia_raw_data:
        print('Nvidia Card is not ready!')
        import sys
        sys.exit(1)
    return nvidia_raw_data


if __name__ == '__main__':
    from sys import argv, exit

    if len(argv) == 1 or len(argv) > 2:
        print('This script needs arguments: FULL or COMPACT')
        exit(1)

    if argv[1].upper() == 'FULL':
        print(get_nvidia_full_info())

    if argv[1].upper() == 'COMPACT':
        print(get_nvidia_compact_info())
    else:
        exit(1)
