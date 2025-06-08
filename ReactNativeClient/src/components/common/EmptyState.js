import React from 'react';
import { View, StyleSheet, Dimensions } from 'react-native';
import { Text, IconButton } from 'react-native-paper';
import { useTheme } from 'react-native-paper';
import Button from './Button';

/**
 * **COMPONENTE EMPTY STATE EDUCATIVO** 📭
 * 
 * Componente para mostrar estados vacíos de manera amigable.
 * Demuestra mejores prácticas de UX para estados sin contenido:
 * - Ilustraciones o iconos explicativos
 * - Mensajes claros y útiles
 * - Acciones sugeridas para el usuario
 * - Diseño empático y motivador
 * 
 * Principios UX demostrados:
 * - Guía al usuario hacia la acción
 * - Comunica el estado de manera clara
 * - Mantiene la motivación del usuario
 * - Proporciona contexto y siguiente paso
 */

const { width: SCREEN_WIDTH } = Dimensions.get('window');

const EmptyState = ({
  icon = 'inbox-outline',
  title = '¡Aquí no hay nada aún!',
  description = 'Parece que no tienes contenido todavía.',
  actionText = null,
  onAction = null,
  variant = 'default', // 'default', 'search', 'error', 'success'
  style = null,
  testID = null
}) => {
  const theme = useTheme();

  // **CONFIGURACIÓN DE VARIANTES** 🎨
  const getVariantConfig = () => {
    const configs = {
      default: {
        iconColor: theme.customColors.text.secondary,
        backgroundColor: theme.customColors.info + '10',
      },
      search: {
        iconColor: theme.customColors.primary,
        backgroundColor: theme.customColors.primary + '10',
      },
      error: {
        iconColor: theme.customColors.error,
        backgroundColor: theme.customColors.error + '10',
      },
      success: {
        iconColor: theme.customColors.success,
        backgroundColor: theme.customColors.success + '10',
      }
    };
    
    return configs[variant] || configs.default;
  };

  const variantConfig = getVariantConfig();

  // **ESTILOS DINÁMICOS** 🎨
  const dynamicStyles = StyleSheet.create({
    container: {
      flex: 1,
      justifyContent: 'center',
      alignItems: 'center',
      paddingHorizontal: theme.spacing.xl,
      paddingVertical: theme.spacing.xxl,
      minHeight: 200,
    },
    iconContainer: {
      width: 120,
      height: 120,
      borderRadius: 60,
      backgroundColor: variantConfig.backgroundColor,
      justifyContent: 'center',
      alignItems: 'center',
      marginBottom: theme.spacing.xl,
    },
    content: {
      alignItems: 'center',
      maxWidth: SCREEN_WIDTH * 0.8,
    },
    title: {
      fontSize: 20,
      fontWeight: '600',
      color: theme.customColors.text.primary,
      textAlign: 'center',
      marginBottom: theme.spacing.sm,
    },
    description: {
      fontSize: 16,
      color: theme.customColors.text.secondary,
      textAlign: 'center',
      lineHeight: 24,
      marginBottom: theme.spacing.xl,
    },
    actionContainer: {
      marginTop: theme.spacing.md,
    }
  });

  return (
    <View 
      style={[dynamicStyles.container, style]}
      testID={testID}
      accessible={true}
      accessibilityRole="text"
      accessibilityLabel={`${title}. ${description}`}
    >
      <View style={dynamicStyles.iconContainer}>
        <IconButton
          icon={icon}
          iconColor={variantConfig.iconColor}
          size={48}
          style={{ margin: 0 }}
        />
      </View>
      
      <View style={dynamicStyles.content}>
        <Text style={dynamicStyles.title}>
          {title}
        </Text>
        
        <Text style={dynamicStyles.description}>
          {description}
        </Text>
        
        {actionText && onAction && (
          <View style={dynamicStyles.actionContainer}>
            <Button
              variant="primary"
              onPress={onAction}
            >
              {actionText}
            </Button>
          </View>
        )}
      </View>
    </View>
  );
};

// **ESTADOS PREDEFINIDOS** 🎯

export const EmptySearchState = ({ searchTerm, onClearSearch }) => (
  <EmptyState
    variant="search"
    icon="magnify"
    title="Sin resultados"
    description={searchTerm 
      ? `No encontramos libros para "${searchTerm}". Intenta con otros términos de búsqueda.`
      : 'Escribe algo en el buscador para encontrar libros.'
    }
    actionText={searchTerm ? "Limpiar búsqueda" : undefined}
    onAction={searchTerm ? onClearSearch : undefined}
  />
);

export const EmptyLibraryState = ({ onBrowseBooks }) => (
  <EmptyState
    icon="bookshelf"
    title="Tu librería está vacía"
    description="¡Comienza a construir tu colección personal! Explora nuestra tienda y agrega tus libros favoritos."
    actionText="Explorar libros"
    onAction={onBrowseBooks}
  />
);

export const EmptyReviewsState = ({ onWriteReview }) => (
  <EmptyState
    icon="star-outline"
    title="Sin reseñas aún"
    description="Aún no has escrito ninguna reseña. Comparte tu opinión sobre los libros que has leído."
    actionText="Escribir primera reseña"
    onAction={onWriteReview}
  />
);

export const ErrorState = ({ onRetry, error = null }) => (
  <EmptyState
    variant="error"
    icon="alert-circle-outline"
    title="¡Ups! Algo salió mal"
    description={error || "Ha ocurrido un error inesperado. Por favor, intenta de nuevo."}
    actionText="Intentar de nuevo"
    onAction={onRetry}
  />
);

export const NoInternetState = ({ onRetry }) => (
  <EmptyState
    variant="error"
    icon="wifi-off"
    title="Sin conexión a internet"
    description="Verifica tu conexión a internet e intenta de nuevo."
    actionText="Reintentar"
    onAction={onRetry}
  />
);

export const LoadingFailedState = ({ onRetry, resource = "contenido" }) => (
  <EmptyState
    variant="error"
    icon="refresh"
    title="Error al cargar"
    description={`No pudimos cargar ${resource}. Verifica tu conexión e intenta de nuevo.`}
    actionText="Reintentar"
    onAction={onRetry}
  />
);

export const SuccessState = ({ title, description, actionText, onAction }) => (
  <EmptyState
    variant="success"
    icon="check-circle-outline"
    title={title}
    description={description}
    actionText={actionText}
    onAction={onAction}
  />
);

// **ESTADOS ESPECÍFICOS DE LA APP** 📚

export const WelcomeState = ({ onGetStarted }) => (
  <EmptyState
    icon="hand-wave"
    title="¡Bienvenido a MyLibrary!"
    description="Tu biblioteca personal te está esperando. Descubre, organiza y reseña tus libros favoritos."
    actionText="Comenzar"
    onAction={onGetStarted}
  />
);

export const FirstBookState = ({ onAddFirstBook }) => (
  <EmptyState
    icon="book-plus"
    title="¡Tu primer libro te espera!"
    description="Busca tu libro favorito y agrégalo a tu librería personal para comenzar tu colección."
    actionText="Buscar mi primer libro"
    onAction={onAddFirstBook}
  />
);

export const BookDetailEmptyState = () => (
  <EmptyState
    icon="book-outline"
    title="Libro no encontrado"
    description="No pudimos encontrar la información de este libro. Puede que haya sido eliminado o movido."
  />
);

export const ReviewsEmptyState = ({ bookTitle, onWriteReview }) => (
  <EmptyState
    icon="comment-text-outline"
    title="Aún sin reseñas"
    description={bookTitle 
      ? `"${bookTitle}" aún no tiene reseñas. ¡Sé el primero en compartir tu opinión!`
      : 'Este libro aún no tiene reseñas.'
    }
    actionText="Escribir reseña"
    onAction={onWriteReview}
  />
);

// **HOOK PARA MANEJO DE ESTADOS** 🪝
export const useEmptyState = (initialState = 'loading') => {
  const [state, setState] = React.useState(initialState);
  const [error, setError] = React.useState(null);

  const setLoading = React.useCallback(() => {
    setState('loading');
    setError(null);
  }, []);

  const setEmpty = React.useCallback(() => {
    setState('empty');
    setError(null);
  }, []);

  const setError = React.useCallback((errorMessage) => {
    setState('error');
    setError(errorMessage);
  }, []);

  const setSuccess = React.useCallback(() => {
    setState('success');
    setError(null);
  }, []);

  const reset = React.useCallback(() => {
    setState('loading');
    setError(null);
  }, []);

  return {
    state,
    error,
    setLoading,
    setEmpty,
    setError,
    setSuccess,
    reset,
    isEmpty: state === 'empty',
    isLoading: state === 'loading',
    isError: state === 'error',
    isSuccess: state === 'success'
  };
};

export default EmptyState;