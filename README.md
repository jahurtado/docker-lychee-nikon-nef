# Lychee (with Nikon NEF support) Docker Files

Docker files for a custom build of Lychee that let you upload Nikon NEF files (See [jahurtado/Lychee](https://github.com/jahurtado/Lychee/tree/nikon-nef-support))

## Run

```
git clone https://github.com/jahurtado/docker-lychee-nikon-nef.git
cd docker-lychee-nikon-nef/
docker-compose up
```

### Configure

1. Go to URL [http://localhost](http://localhost)
2. Enter database connection details:

   - Database host: `mysql`
   - Database username: `lychee`
   - Database password: `lychee`

![database-connection](https://github.com/jahurtado/docker-lychee-nikon-nef/raw/master/doc/lychee_init.png)

3. Enter username/password:
   - username: `lychee`
   - password: `lychee`

![login](https://github.com/jahurtado/docker-lychee-nikon-nef/raw/master/doc/lychee_login.png)

_NOTE_: By default, all your data will be located in `${HOME}/lychee`. You can set your custom directories and database user/password by editing `docker-compose.yml`.
