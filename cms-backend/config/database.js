const path = require('path');

module.exports = ({ env }) => ({
  connection: {
    client: 'sqlite',
    connection: {
      filename: path.join(__dirname, '..', env('DATABASE_FILENAME', '.tmp/data.db')),

    },
    useNullAsDefault: true,
/*
    // psql config, save for another day
    client: env('DATABASE_CLIENT','postgres'),
    connection: {
      host: env('DATABASE_HOST', 'localhost'),
      port: env.int('DATABASE_PORT', 5432),
      database: env('DATABASE_NAME', 'testdb'),
      user: env('DATABASE_USERNAME', 'postgres'),
      password: env('DATABASE_PASSWORD', '0000'),
      schema: env('DATABASE_SCHEMA', 'public'), // Not required
      ssl: env('DATABASE_SSL', false),
//      ssl: {
//        rejectUnauthorized: env.bool('DATABASE_SSL_SELF', false),
//      },
    },
    debug: true,
*/

  },
});

