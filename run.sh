docker run \
	--net=host \
	--name smtpd \
	-p 0.0.0.0:25:25 \
	-p 0.0.0.0:587:587 \
	dockerppc64le/docker-opensmtpd
