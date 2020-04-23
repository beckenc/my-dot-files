### Install for your own user only

	git clone https://github.com/beckenc/my-dot-files.git ~/.my-dot-files
	bash ~/.my-dot-files/install.sh
	
### Install for multiple users
To install for multiple users, the repository needs to be cloned to a location accessible for all the intended users.

	git clone https://github.com/beckenc/my-dot-files.git /opt/my-dot-files
	bash /opt/my-dot-files/install.sh user0 user1 user2
	# to install for all users with home directories
	bash /opt/my-dot-files/install.sh --all
	
Naturally, `/opt/my-dot-files` can be any directory, as long as all the users specified have read access.

### How to include your own stuff?

After you have installed the setup, you can create **my_bashrc** next to **install.sh** to fill in any configurations that are important for you. 
