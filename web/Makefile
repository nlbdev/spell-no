USER=toralfl
SERVER=shell.sourceforge.net
PROJECTDIR=/home/groups/s/sp/spell-no
HTML=index.html ooinstall.html

# *** Is there a way to get scp to replace read-only files 
#     (it has no -f option)?
install:
	ssh $(USER)@$(SERVER) rm -f $(addprefix $(PROJECTDIR)/htdocs/, $(HTML))
	scp -p $(HTML) $(USER)@$(SERVER):$(PROJECTDIR)/htdocs
