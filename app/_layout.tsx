import '@/global.css';
import Providers from '@/lib/providers';

import { Stack } from 'expo-router';

export const unstable_settings = {
  initialRouteName: 'index',
};

export default function RootLayout() {
  return (
    <Providers>
      <Stack>
        <Stack.Screen name="index" options={{ headerLargeTitle: true }} />
      </Stack>
    </Providers>
  );
}
