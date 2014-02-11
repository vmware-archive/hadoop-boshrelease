# Bosh release for Apache Hadoop

One of the fastest ways to get [Apache Hadoop](http://hadoop.apache.org/) running on any infrastructure is too deploy this bosh release.

## Usage

To use this bosh release, first upload it to your bosh:

```
bosh target BOSH_HOST
git clone git@github.com:cloudfoundry-community/hadoop-boshrelease.git
cd hadoop-boshrelease
bosh upload release releases/hadoop-1.yml
```

Now create a deployment file (using the files at the [examples](https://github.com/cloudfoundry-community/hadoop-boshrelease/tree/master/examples) directory as a starting point) and deploy:

```
bosh deployment path/to/deployment.yml
bosh -n deploy
```

## Create new final release

To create a new final release you need to get read/write API credentials to the [@cloudfoundry-community](https://github.com/cloudfoundry-community) s3 account.

Please email [Dr Nic Williams](mailto:&#x64;&#x72;&#x6E;&#x69;&#x63;&#x77;&#x69;&#x6C;&#x6C;&#x69;&#x61;&#x6D;&#x73;&#x40;&#x67;&#x6D;&#x61;&#x69;&#x6C;&#x2E;&#x63;&#x6F;&#x6D;) and he will create unique API credentials for you.

Create a `config/private.yml` file with the following contents:

``` yaml
---
blobstore:
  s3:
    access_key_id:     ACCESS
    secret_access_key: PRIVATE
```

You can now create final releases for everyone to enjoy!

```
bosh create release
# test this dev release
git commit -m "updated hadoop"
bosh create release --final
git commit -m "creating vXYZ release"
git tag vXYZ
git push origin master --tags
```
