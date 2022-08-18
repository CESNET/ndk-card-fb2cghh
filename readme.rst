.. _card_fb2cghh:

FB2CGHH card
---------------------

FB2CGHH card by Silicom is supported in the NDK.

Build instructions
^^^^^^^^^^^^^^^^^^

- Go to ``build/fb2cghh/`` folder in application repository.
- Check or modify ``user_const.tcl`` file, where you can change the firmware configuration.
- Run firmware build in Vivado by ``make`` command.
    - Use ``make`` command for firmware with 2x100GbE for FB2CGHH card (default and only one).
- After the build is complete, you will find bitstream ``fb2cghh-minimal-100g2.nfw`` in the same folder.

.. note::

    To build firmware, you must have Xilinx Vivado installed, including a valid license.

.. note::

    Source clock for this application is PCIe clock, which is set up to 250 MHz. 

Boot instructions
^^^^^^^^^^^^^^^^^^

- To boot design on specific card you have to follow these steps:
    - Copy .nfw file into current directory 
    - Boot design by using ``nfb-boot -f 0 fb2cghh-minimal-100g2.nfw`` command in directory where .nfw file is located.
- To confirm that design is booted correctly use ``nfb-info`` command

.. note::

    To see boot options use command ``nfb-boot -h``.

Ethernet Interface
^^^^^^^^^^^^^^^^^^
This card has two QSFP ports. Each is connected to the FPGA via 4 high-speed serial lines supporting up to 25 Gbps. Each of these ports is connected to CMAC core with speed of ``1x100GE``. The architecture of network module :ref:`is described here <ndk_intel_net_mod>`.

PCIe Interface
^^^^^^^^^^^^^^^^^^
This card has single PCIe Gen3 x16 edge connector. The throughput available to the user is approximately 100 Gbps and is depend on DMA solution. The architecture of the PCIe Module :ref:`is described here <ndk_intel_pcie_mod>`.