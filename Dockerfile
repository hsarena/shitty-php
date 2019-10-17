FROM composer:latest as main-app-composer
COPY composer.json  /app
ARG RUN_ENV
ENV RUN_ENV=${RUN_ENV:-dev}
RUN  set -x; if [ "$RUN_ENV" = "prd" ]; \
    then \
        composer install  \
        --ignore-platform-reqs \ 
        --no-interaction  \
        --no-plugins \
        --no-scripts \
        --prefer-dist \
        --no-autoloader; \
    else \
        echo "READY TO DEVELOPMENT"; \
    fi 
    
FROM kaarbon/php-7.2.8:v1.0.2
COPY --chown=nginx:nginx . /var/www/
COPY --from=main-app-composer --chown=nginx:nginx /app /var/www
ENTRYPOINT [ "/var/www/entrypoint.sh" ]
