'use strict';

/**
 * zipcode service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::zipcode.zipcode');
