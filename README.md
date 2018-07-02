# DHSkins Skin Server

Provided herein is a standard implementation of a minecraft skin server with full support for the legacy and valhalla servers.

The standard texture provisions include the following:

- SKIN
   This is the regular player skin, ie. the body.
- ELYTRA
   Custom elytra textures.
- CAPES
   Pretty self-explanatory
	 
Skins also support the following model types:
- default
   Regular steve with fat arms.
- slim
   The alex skin model with thinner arms.
	 
## Setup and Configuration

The default configuration is using ruby 2.4.1 and 5.1.6.
A MySQL server is expected to be running on the local machine, accessible at 127.0.01:3306. All of these configurations can be customise in the /config/database.yml file.

Rails is promarily meant to run in Linux, this it's recommended to have such a set up on any maching intended to run it. For those on windows, all of the below can be done through the Linux Sub-system built into most modern versions of Windows 10.

Steps to get started:

1. git clone [repo]
2. bundle install (installs all required gems)
3. rake db:create (creates the database)

## Updating

Updates can be retrieved by running `git pull` in the root directory of the app.

Update the database:

rake db:migrate (updates an existing database)

## Testing

To start the server simply run:

rails server

A basic WeBrick server will be started on the local maching and made reachable at localhost:3000.

## Deploying

// TODO