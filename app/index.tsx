import { supabase } from '@/utils/supabase';
import React from 'react';
import { View } from 'react-native';

export default function Root() {
  React.useEffect(() => {
    supabase
      .from('todos')
      .select('*')
      .then(({ data, error }) => {
        if (error) {
          console.error(error.message);
          throw new Error(error.message);
        }

        if (data) {
          console.log(data);
        }
      });
  });
  return <View />;
}
