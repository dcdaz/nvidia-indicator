# Nvidia-Indicator

![nvidia](nvidia.png?raw=true)

A plasmoid for Plasma 5, that shows info related to:

- GPU Name
- Temperature
- Driver Version
- Memory Total, Used, Free
- GPU Clocks
- GPU Status On/Off (Depends on how driver stops GPU)

This plasmoid is heavily inspired on [bumblebee-indicator](https://github.com/bxabi/bumblebee-indicator), in fact is a copy of that project with several changes, like the use of **Python3** instead of **Bash** for getting info, updated icons, get rid off *optirun* stuff, etc

This plasmoid is made to work with the latest versions of NVIDIA's driver which already allow to disable graphics card in hybrid solutions such as gaming laptops, but it should work on desktops/laptops with no other *GPU* but **NVIDIA**.

The whole idea is to make a replace of *bumblebee-indicator* that runs with **nvidia-smi** rather than **optirun**, therefore I'm not sure if this works with **bumblebee** solutions (probably not), not tested with *Nvidia-Prime/Suse-Prime*

> Currently is tested on a laptop with `AMD Ryzen + NVIDIA`  
> and **Driver** version **450.80.02** installed the hard way *"used `.run` Driver"*
>
> I guess it should work with NVIDIA drivers 450+


![nvidia-full](nvidia-full.png?raw=true)


You can install, update, remove this *plasmoid* with the following commands:

Install

```bash
plasmapkg2 -i nvidia-indicator/
```

Update

```bash
plasmapkg2 -u nvidia-indicator/
```

Remove

```bash
plasmapkg2 -r nvidia-indicator/
```
