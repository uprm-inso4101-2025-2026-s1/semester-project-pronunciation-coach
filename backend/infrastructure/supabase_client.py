"""
Supabase Client Configuration
Handles database connection and operations for quiz progress storage
"""

import os
from dotenv import load_dotenv
from supabase import create_client, Client
from typing import Optional

# Load environment variables from .env file
load_dotenv()

def get_supabase_client() -> Client:
    """Get configured Supabase client"""
    url = os.getenv("SUPABASE_URL")
    key = os.getenv("SUPABASE_ANON_KEY")

    if not url or not key:
        raise ValueError("SUPABASE_URL and SUPABASE_ANON_KEY environment variables must be set")

    return create_client(url, key)

# Global client instance
_supabase_client: Optional[Client] = None

def init_supabase_client():
    """Initialize the global Supabase client"""
    global _supabase_client
    _supabase_client = get_supabase_client()

def get_client() -> Client:
    """Get the global Supabase client instance"""
    if _supabase_client is None:
        init_supabase_client()
    return _supabase_client
