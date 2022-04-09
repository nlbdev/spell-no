spell-no
========

## Maven setup

Add to `~/.m2/settings.xml` (replace USERNAME and TOKEN with your Github username and token):

```xml
<settings xmlns="http://maven.apache.org/SETTINGS/1.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://maven.apache.org/SETTINGS/1.0.0
                      http://maven.apache.org/xsd/settings-1.0.0.xsd">

  <activeProfiles>
    <activeProfile>github-spell-no</activeProfile>
  </activeProfiles>

  <profiles>
    <profile>
      <id>github-spell-no</id>
      <repositories>
        <repository>
          <id>central</id>
          <url>https://repo1.maven.org/maven2</url>
        </repository>
        <repository>
          <id>github-spell-no</id>
          <url>https://maven.pkg.github.com/nlbdev/spell-no</url>
          <snapshots>
            <enabled>true</enabled>
          </snapshots>
        </repository>
      </repositories>
    </profile>
  </profiles>

  <servers>
    <server>
      <id>github-spell-no</id>
      <username>USERNAME</username>
      <password>TOKEN</password>
    </server>
  </servers>
</settings>
```

See also:

- [GitHub Packages: Working with the Apache Maven registry](https://docs.github.com/en/packages/working-with-a-github-packages-registry/working-with-the-apache-maven-registry)


## Build and publish

```bash
cd norsk/patterns
make publish
```

