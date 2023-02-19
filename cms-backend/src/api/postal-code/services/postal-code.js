'use strict';

/**
 * postal-code service
 */

const { createCoreService } = require('@strapi/strapi').factories;

module.exports = createCoreService('api::postal-code.postal-code');
