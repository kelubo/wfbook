# SVN强制写log
hooks/pre-commit  

    mv pre-commit.tmpl pre-commit
    chmod +x pre-commit
编辑pre-commit，注释掉

    commit-access-control.pl "$REPOS" "$TXN" commit-access-control.cfg || exit
