import { supabase } from '@/utils/supabase';
import { useQuery } from '@tanstack/react-query';
import { Stack } from 'expo-router';
import { Alert, SafeAreaView, Text } from 'react-native';

export default function Root() {
  const { data, isLoading, error } = useQuery({
    queryKey: ['todos'],
    queryFn: async () => {
      const { data, error } = await supabase.from('todos').select('*');
      if (error) {
        throw new Error(error.message);
      }

      return data;
    },
  });

  if (isLoading) {
    return (
      <SafeAreaView>
        <Text>Loading...</Text>
      </SafeAreaView>
    );
  }

  if (error) {
    Alert.alert(error.name, error.message);
  }

  if (data) {
    console.log(data);
  }

  return (
    <>
      <Stack.Screen options={{ title: 'Home' }} />
      <SafeAreaView />
    </>
  );
}
