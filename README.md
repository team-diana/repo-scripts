# Ubuntu Repository Generator Scripts

## Usage

```
sudo /home/tamer/Team DIANA/repo-scripts/repo.sh [-c|--clean|-h|--help]
```

### Optional parameters

| Parameter |                              Action                                          |
|-----------|------------------------------------------------------------------------------|
| `-c`      | Builds new packages from scratch and removes everything from the repository. |
| `-h`      | This help message.                                                           |

## How to use generated repository?
Like so:

```
curl https://www.tamersaadeh.com/diana/deb/pubkey.asc | sudo apt-key add -
sudo sh -c 'echo "deb [arch=amd64] http://www.tamersaadeh.com/diana/deb/ all main" > /etc/apt/sources.list.d/team-diana.list'
sudo apt-get update
```

Then you can install packages provided by the repository by issuing:
```
sudo apt-get install <package-name>
```
eg `sudo apt-get install boost-all`

## Goals

Our goal is to create a deb repository with packages we need to be up to date that aren't provided through other means.

## History

This was forked from tamersaadeh/oab-java which is a fork of flexiondotorg/oab-java6. It was modified to suit the needs of Team DIANA and is highly oriented to our specific needs. However, it can still be of use to others, as such we have decided to release it.
