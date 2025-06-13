// **CONFIGURACIÓN DE BABEL - DEMO EDUCATIVO** ⚙️
//
// Babel transpila el código JavaScript moderno para que sea compatible
// con diferentes versiones de JavaScript en dispositivos.
//
// Conceptos educativos:
// - Transpilación de código
// - Compatibilidad entre plataformas
// - Configuración de herramientas de desarrollo

module.exports = function(api) {
  // Cache de configuración para mejor rendimiento
  api.cache(true);
  
  return {
    // Preset de Expo: incluye todas las transformaciones necesarias
    // para React Native y las funcionalidades de Expo
    presets: ['babel-preset-expo'],
  };
};