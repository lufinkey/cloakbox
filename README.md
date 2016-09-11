**Cloakbox**
===================

Cloakbox is a virtual machine that is connected to a VPN and uses aria2 to manage your *ahem* legal *ahem* downloads.

## Usage

./cloakbox \<command> [\<args>]

* **setup**

	Set up cloakbox environment and install necessary vagrant plugins
	
* **start**

	Create and boot the cloakbox VM. This subcommand implicitly calls **setup** if it needs to be called

* **stop**

	Power off the cloakbox VM.

* **updatesettings**

	Update cloakbox settings from its config files

* **ssh**

	SSH into the cloakbox VM. The arguments to this command are passed directly to the ssh executable

* **ip**

	Output the external IP of the cloakbox VM

* **download** \<subcommand> [\<args>]

	Download manager for the cloakbox VM. This command takes several subcommands:

	* **add** [--brief|-b] [--exit-on-failure|-e] [--torrent=\<PATH>|-t \<PATH>]... [--metalink=\<PATH>|-m \<PATH>]... [--url=\<URL>|-u \<URL>]... TORRENT|METALINK|URL|MAGNET...

		Add a TORRENT, METALINK, URL, or MAGNET to the download manager and output a GID to identify the added download

		* **-b**, **--brief**

			Only output the GID of each added download

		* **-e**, **--exit-on-failure**

			Exit if a download fails to add

		* **-t**, **--torrent**=PATH

			Add torrent at PATH as a download

		* **-m**, **--metalink**=PATH

			Add metalink file at PATH as a download

		* **-u**, **--url**=URL

			Add URL as a download

	* **remove** [--delete|-d] [--exit-on-failure|-e] GID...

		Remove a download with the gid GID

		* **-d**, **--delete**

			Delete the download directory after removing

		* **-e**, **--exit-on-failure**

			Exit if a download fails to remove

	* **list** CATEGORY [--include=\<PROPERTY>|-i \<PROPERTY>]...

		List all downloads and their properties in the specified CATEGORY. CATEGORY can be **all**, **active**, **waiting**, or **stopped**.

		* **-i** PROPERTY, **--include**=PROPERTY

			Output the specified PROPERTY for each download. If this argument is not used, the output for each download will list all of its properties. The gid of each download is always listed.

	* **status** [\<GID>]... [--include=\<PROPERTY>|-i \<PROPERTY>]...

		List the statuses of the downloads with the specified GIDs. If no GID is specified, the global status is outputted

		* **-i** PROPERTY, **--include**=PROPERTY

			Output the specified property for each download. If this argument is not used, the output for each download will list all of its properties. This argument cannot be used if no GID is specified.

* **destroy** [--clean|-c]

	Destroy the cloakbox VM

	* **-c**, **--clean**

		Delete all downloads, logs, and VM data
