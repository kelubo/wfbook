# Errors

1.  变量 $cfg['TempDir'] （./tmp/）无法访问。phpMyAdmin无法缓存模板文件，所以会运行缓慢。 

   创建空目录tmp，给予合适的权限。

2.  配置文件中的密文(blowfish_secret)太短。 

   ```bash
   /**
    * This is needed for cookie based authentication to encrypt password in
    * cookie. Needs to be 32 chars long.
    */
   $cfg['blowfish_secret'] = 'fdafeasessssssffseegbeef23414adf3asdf'; /* YOU MUST FILL IN THIS FOR COOKIE AUTH! */
   ```

3. b

