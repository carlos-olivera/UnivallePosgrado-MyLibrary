/**
 * **ÍNDICE DE COMPONENTES COMUNES** 🧩
 * 
 * Exportaciones centralizadas de todos los componentes comunes
 * para facilitar las importaciones en otros módulos.
 * 
 * Patrón educativo: Barrel exports para componentes
 */

// **COMPONENTES BÁSICOS** ⚡
export { default as LoadingSpinner, LoadingSpinnerSmall, LoadingSpinnerLarge, LoadingOverlay } from './LoadingSpinner';
export { default as Button, PrimaryButton, SecondaryButton, OutlineButton, TextButton, DangerButton, SmallButton, LargeButton, FullWidthButton, LoadingButton, IconButton, FloatingActionButton, ButtonSpinner } from './Button';
export { default as Card, DefaultCard, OutlinedCard, ElevatedCard } from './Card';
export { default as BookCard, CompactBookCard, DetailedBookCard, SimpleBookCard } from './BookCard';
export { default as StatsCard, NumberStatsCard, PercentageStatsCard, CurrencyStatsCard } from './StatsCard';

// **FEEDBACK Y NOTIFICACIONES** 📢
export { default as Toast, SuccessToast, ErrorToast, WarningToast, InfoToast, useToast } from './Toast';
export { default as Modal, ConfirmationModal, AlertModal, BottomSheetModal, FullscreenModal, useModal } from './Modal';

// **ESTADOS Y MENSAJES** 📭
export { 
  default as EmptyState, 
  EmptySearchState, 
  EmptyLibraryState, 
  EmptyReviewsState, 
  ErrorState, 
  NoInternetState, 
  LoadingFailedState, 
  SuccessState,
  WelcomeState,
  FirstBookState,
  BookDetailEmptyState,
  ReviewsEmptyState,
  useEmptyState 
} from './EmptyState';

// **UTILIDADES DE IMPORTACIÓN** 🛠️

/**
 * **IMPORTAR TODOS LOS COMPONENTES COMUNES** 
 * 
 * Uso:
 * import * as CommonComponents from '@/components/common';
 */
export const CommonComponents = {
  LoadingSpinner,
  Button,
  Card,
  Toast,
  Modal,
  EmptyState
};

/**
 * **EJEMPLOS DE USO** 📚
 * 
 * // Importar componentes individuales
 * import { Button, LoadingSpinner, Toast } from '@/components/common';
 * 
 * // Importar variantes específicas
 * import { PrimaryButton, ErrorToast, EmptyLibraryState } from '@/components/common';
 * 
 * // Importar hooks
 * import { useToast, useModal, useEmptyState } from '@/components/common';
 * 
 * // Usar en componente
 * const MyComponent = () => {
 *   const { showSuccess, ToastComponent } = useToast();
 *   const { visible, showModal, hideModal } = useModal();
 *   
 *   return (
 *     <View>
 *       <PrimaryButton onPress={() => showSuccess('¡Éxito!')}>
 *         Mostrar Toast
 *       </PrimaryButton>
 *       <ToastComponent />
 *     </View>
 *   );
 * };
 */