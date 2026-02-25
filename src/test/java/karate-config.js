function fn() {

  var env = karate.env || 'dev';

  var environments = {
    dev: {
      baseUrlPet: 'https://petstore.swagger.io/v2'
    },
    cert: {
      baseUrlPet: 'https://petstore.swagger.io/v2'
    },
    prod: {
      baseUrlPet: 'https://petstore.swagger.io/v2'
    }
  };

  var config = environments[env];

  karate.log('Environment:', env);
  karate.log('Base URL:', config.baseUrlPet);

  return config;
}