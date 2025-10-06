/**
 * Supabase Client Configuratie
 *
 * Dit bestand initialiseert de Supabase client die wordt gebruikt
 * voor alle database operaties in de applicatie.
 */

import { createClient } from '@supabase/supabase-js'

// Haal de Supabase URL en API key op uit de environment variabelen
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL
const supabaseAnonKey = import.meta.env.VITE_SUPABASE_SUPABASE_ANON_KEY

// Maak en exporteer de Supabase client
export const supabase = createClient(supabaseUrl, supabaseAnonKey)
