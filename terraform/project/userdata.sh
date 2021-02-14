#! /bin/bash
yum update -y
amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
yum install -y httpd curl unzip

# Install Vault agent
cd /home/ec2-user/
curl https://releases.hashicorp.com/vault/${vault_version}/vault_${vault_version}_linux_386.zip --output vault.zip
unzip vault.zip
rm -f vault.zip

cat <<EOT > vault-agent.hcl
auto_auth {
  method {
    mount_path = "auth/${vault_auth_path}"
    type = "aws"
    config = {
      type = "ec2"
      role = "web"
    }
  }

  sink {
    type = "file"
    config = {
      path = "/home/ec2-user/.vault-token"
    }
  }
}

template {
  source = "/var/www/secrets.tpl"
  destination = "/var/www/secrets.json"
}

vault {
  address = "${vault_addr}"
}
EOT

cat <<EOT > /var/www/secrets.tpl
{
  {{ with secret "web-db/creds/web" }}
  "username":"{{ .Data.username }}",
  "password":"{{ .Data.password }}",
  "db_host":"${db_host}",
  "db_name":"${db_name}"
  {{ end }}
}
EOT

${vault_agent_parameters} ./vault agent -config=vault-agent.hcl &

cat << 'EOT' > /var/www/html/index.php
<html>
    <head>
        <title>Hello HashiTalk 2021!</title>
    </head>

    <body>

    <h1>Hello HashiTalk 2021!</h1>
    Attempting MySQL connection from php...</br>
        <?php
            if (file_exists("/var/www/secrets.json")) {
              $secrets_json = file_get_contents("/var/www/secrets.json", "r");
              $user = json_decode($secrets_json)->{'username'};
              $pass = json_decode($secrets_json)->{'password'};
              $host = json_decode($secrets_json)->{'db_host'};
              $dbname = json_decode($secrets_json)->{'db_name'};
            }
            else{
              echo "Secrets not found.";
              exit;
            }

            echo "Using database user: <b>".$user."</b></br>";

            // Create connection
            $conn = new mysqli($host, $user, $pass, $dbname);

            // Check connection
            if ($conn->connect_error) {
                die("Connection failed: " . $conn->connect_error);
            }
            else {
                echo "Connected successfully.</br>";
            }
            ?>
    </body>
</html>
EOT

systemctl start httpd
systemctl enable httpd
