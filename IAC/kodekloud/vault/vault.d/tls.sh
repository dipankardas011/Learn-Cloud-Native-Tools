rm *.pem

# 1. Generate CA's private key and self-signed certificate
openssl req -x509 -newkey rsa:4096 -days 365 -nodes -keyout vault.key -out vault.crt -subj "/C=IN/ST=Jharkhand/L=Jamshedpur/O=Tech School/OU=Education/CN=*.dipankardas0115/emailAddress=dipankardas0115@gmail.com"

echo "CA's self-signed certificate"
openssl x509 -in vault.crt -noout -text

# 2. Generate web server's private key and certificate signing request (CSR)
#openssl req -newkey rsa:4096 -nodes -keyout server-key.key -out server-req.pem -subj "/C=IN/ST=Jharkhand/L=Jamshedpur/OU=Computer/CN=*.vault/emailAddress=vault@gm.com"

# 3. Use CA's private key to sign web server's CSR and get back the signed certificate
#openssl x509 -req -in server-req.pem -days 120 -CA tls-cert.pem -CAkey tls-key.pem -CAcreateserial -out server-cert.pem -extfile server-ext.cnf

#echo "Server's signed certificate"
# openssl x509 -in server-cert.pem -noout -text
