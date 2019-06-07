<?php

namespace udzuki\translator\moodle\db\Models;

use Illuminate\Database\Eloquent\Model;

class Glossary extends Model
{
    protected $table = 'glossary';

    public function getIdAttribute($value): string
    {
        return "{$this->getConnection()->getConfig('app_url')}/mod/glossary/{$value}";
    }

    public function getCourseAttribute($value): int
    {
        return $value;
    }

    public function getNameAttribute($value): string
    {
        return $value;
    }
}