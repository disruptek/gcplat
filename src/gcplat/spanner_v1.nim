
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Spanner
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Cloud Spanner is a managed, mission-critical, globally consistent and scalable relational database service.
## 
## https://cloud.google.com/spanner/
type
  Scheme {.pure.} = enum
    Https = "https", Http = "http", Wss = "wss", Ws = "ws"
  ValidatorSignature = proc (query: JsonNode = nil; body: JsonNode = nil;
                          header: JsonNode = nil; path: JsonNode = nil;
                          formData: JsonNode = nil): JsonNode
  OpenApiRestCall = ref object of RestCall
    validator*: ValidatorSignature
    route*: string
    base*: string
    host*: string
    schemes*: set[Scheme]
    url*: proc (protocol: Scheme; host: string; base: string; route: string;
              path: JsonNode; query: JsonNode): Uri

  OpenApiRestCall_593421 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593421](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593421): Option[Scheme] {.used.} =
  ## select a supported scheme from a set of candidates
  for scheme in Scheme.low ..
      Scheme.high:
    if scheme notin t.schemes:
      continue
    if scheme in [Scheme.Https, Scheme.Wss]:
      when defined(ssl):
        return some(scheme)
      else:
        continue
    return some(scheme)

proc validateParameter(js: JsonNode; kind: JsonNodeKind; required: bool;
                      default: JsonNode = nil): JsonNode =
  ## ensure an input is of the correct json type and yield
  ## a suitable default value when appropriate
  if js ==
      nil:
    if default != nil:
      return validateParameter(default, kind, required = required)
  result = js
  if result ==
      nil:
    assert not required, $kind & " expected; received nil"
    if required:
      result = newJNull()
  else:
    assert js.kind ==
        kind, $kind & " expected; received " &
        $js.kind

type
  KeyVal {.used.} = tuple[key: string, val: string]
  PathTokenKind = enum
    ConstantSegment, VariableSegment
  PathToken = tuple[kind: PathTokenKind, value: string]
proc queryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] =
  ## reconstitute a path with constants and variable values taken from json
  var head: string
  if segments.len == 0:
    return some("")
  head = segments[0].value
  case segments[0].kind
  of ConstantSegment:
    discard
  of VariableSegment:
    if head notin input:
      return
    let js = input[head]
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "spanner"
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpannerProjectsInstancesDatabasesDropDatabase_593690 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesDropDatabase_593692(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesDropDatabase_593691(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Drops (aka deletes) a Cloud Spanner database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database to be dropped.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_593818 = path.getOrDefault("database")
  valid_593818 = validateParameter(valid_593818, JString, required = true,
                                 default = nil)
  if valid_593818 != nil:
    section.add "database", valid_593818
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593819 = query.getOrDefault("upload_protocol")
  valid_593819 = validateParameter(valid_593819, JString, required = false,
                                 default = nil)
  if valid_593819 != nil:
    section.add "upload_protocol", valid_593819
  var valid_593820 = query.getOrDefault("fields")
  valid_593820 = validateParameter(valid_593820, JString, required = false,
                                 default = nil)
  if valid_593820 != nil:
    section.add "fields", valid_593820
  var valid_593821 = query.getOrDefault("quotaUser")
  valid_593821 = validateParameter(valid_593821, JString, required = false,
                                 default = nil)
  if valid_593821 != nil:
    section.add "quotaUser", valid_593821
  var valid_593835 = query.getOrDefault("alt")
  valid_593835 = validateParameter(valid_593835, JString, required = false,
                                 default = newJString("json"))
  if valid_593835 != nil:
    section.add "alt", valid_593835
  var valid_593836 = query.getOrDefault("oauth_token")
  valid_593836 = validateParameter(valid_593836, JString, required = false,
                                 default = nil)
  if valid_593836 != nil:
    section.add "oauth_token", valid_593836
  var valid_593837 = query.getOrDefault("callback")
  valid_593837 = validateParameter(valid_593837, JString, required = false,
                                 default = nil)
  if valid_593837 != nil:
    section.add "callback", valid_593837
  var valid_593838 = query.getOrDefault("access_token")
  valid_593838 = validateParameter(valid_593838, JString, required = false,
                                 default = nil)
  if valid_593838 != nil:
    section.add "access_token", valid_593838
  var valid_593839 = query.getOrDefault("uploadType")
  valid_593839 = validateParameter(valid_593839, JString, required = false,
                                 default = nil)
  if valid_593839 != nil:
    section.add "uploadType", valid_593839
  var valid_593840 = query.getOrDefault("key")
  valid_593840 = validateParameter(valid_593840, JString, required = false,
                                 default = nil)
  if valid_593840 != nil:
    section.add "key", valid_593840
  var valid_593841 = query.getOrDefault("$.xgafv")
  valid_593841 = validateParameter(valid_593841, JString, required = false,
                                 default = newJString("1"))
  if valid_593841 != nil:
    section.add "$.xgafv", valid_593841
  var valid_593842 = query.getOrDefault("prettyPrint")
  valid_593842 = validateParameter(valid_593842, JBool, required = false,
                                 default = newJBool(true))
  if valid_593842 != nil:
    section.add "prettyPrint", valid_593842
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593865: Call_SpannerProjectsInstancesDatabasesDropDatabase_593690;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Drops (aka deletes) a Cloud Spanner database.
  ## 
  let valid = call_593865.validator(path, query, header, formData, body)
  let scheme = call_593865.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593865.url(scheme.get, call_593865.host, call_593865.base,
                         call_593865.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593865, url, valid)

proc call*(call_593936: Call_SpannerProjectsInstancesDatabasesDropDatabase_593690;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesDropDatabase
  ## Drops (aka deletes) a Cloud Spanner database.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database to be dropped.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593937 = newJObject()
  var query_593939 = newJObject()
  add(query_593939, "upload_protocol", newJString(uploadProtocol))
  add(query_593939, "fields", newJString(fields))
  add(query_593939, "quotaUser", newJString(quotaUser))
  add(query_593939, "alt", newJString(alt))
  add(query_593939, "oauth_token", newJString(oauthToken))
  add(query_593939, "callback", newJString(callback))
  add(query_593939, "access_token", newJString(accessToken))
  add(query_593939, "uploadType", newJString(uploadType))
  add(query_593939, "key", newJString(key))
  add(path_593937, "database", newJString(database))
  add(query_593939, "$.xgafv", newJString(Xgafv))
  add(query_593939, "prettyPrint", newJBool(prettyPrint))
  result = call_593936.call(path_593937, query_593939, nil, nil, nil)

var spannerProjectsInstancesDatabasesDropDatabase* = Call_SpannerProjectsInstancesDatabasesDropDatabase_593690(
    name: "spannerProjectsInstancesDatabasesDropDatabase",
    meth: HttpMethod.HttpDelete, host: "spanner.googleapis.com",
    route: "/v1/{database}",
    validator: validate_SpannerProjectsInstancesDatabasesDropDatabase_593691,
    base: "/", url: url_SpannerProjectsInstancesDatabasesDropDatabase_593692,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetDdl_593978 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesGetDdl_593980(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/ddl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesGetDdl_593979(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database whose schema we wish to get.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_593981 = path.getOrDefault("database")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "database", valid_593981
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_593982 = query.getOrDefault("upload_protocol")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = nil)
  if valid_593982 != nil:
    section.add "upload_protocol", valid_593982
  var valid_593983 = query.getOrDefault("fields")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "fields", valid_593983
  var valid_593984 = query.getOrDefault("quotaUser")
  valid_593984 = validateParameter(valid_593984, JString, required = false,
                                 default = nil)
  if valid_593984 != nil:
    section.add "quotaUser", valid_593984
  var valid_593985 = query.getOrDefault("alt")
  valid_593985 = validateParameter(valid_593985, JString, required = false,
                                 default = newJString("json"))
  if valid_593985 != nil:
    section.add "alt", valid_593985
  var valid_593986 = query.getOrDefault("oauth_token")
  valid_593986 = validateParameter(valid_593986, JString, required = false,
                                 default = nil)
  if valid_593986 != nil:
    section.add "oauth_token", valid_593986
  var valid_593987 = query.getOrDefault("callback")
  valid_593987 = validateParameter(valid_593987, JString, required = false,
                                 default = nil)
  if valid_593987 != nil:
    section.add "callback", valid_593987
  var valid_593988 = query.getOrDefault("access_token")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "access_token", valid_593988
  var valid_593989 = query.getOrDefault("uploadType")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "uploadType", valid_593989
  var valid_593990 = query.getOrDefault("key")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "key", valid_593990
  var valid_593991 = query.getOrDefault("$.xgafv")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("1"))
  if valid_593991 != nil:
    section.add "$.xgafv", valid_593991
  var valid_593992 = query.getOrDefault("prettyPrint")
  valid_593992 = validateParameter(valid_593992, JBool, required = false,
                                 default = newJBool(true))
  if valid_593992 != nil:
    section.add "prettyPrint", valid_593992
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593993: Call_SpannerProjectsInstancesDatabasesGetDdl_593978;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ## 
  let valid = call_593993.validator(path, query, header, formData, body)
  let scheme = call_593993.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593993.url(scheme.get, call_593993.host, call_593993.base,
                         call_593993.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593993, url, valid)

proc call*(call_593994: Call_SpannerProjectsInstancesDatabasesGetDdl_593978;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesGetDdl
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database whose schema we wish to get.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_593995 = newJObject()
  var query_593996 = newJObject()
  add(query_593996, "upload_protocol", newJString(uploadProtocol))
  add(query_593996, "fields", newJString(fields))
  add(query_593996, "quotaUser", newJString(quotaUser))
  add(query_593996, "alt", newJString(alt))
  add(query_593996, "oauth_token", newJString(oauthToken))
  add(query_593996, "callback", newJString(callback))
  add(query_593996, "access_token", newJString(accessToken))
  add(query_593996, "uploadType", newJString(uploadType))
  add(query_593996, "key", newJString(key))
  add(path_593995, "database", newJString(database))
  add(query_593996, "$.xgafv", newJString(Xgafv))
  add(query_593996, "prettyPrint", newJBool(prettyPrint))
  result = call_593994.call(path_593995, query_593996, nil, nil, nil)

var spannerProjectsInstancesDatabasesGetDdl* = Call_SpannerProjectsInstancesDatabasesGetDdl_593978(
    name: "spannerProjectsInstancesDatabasesGetDdl", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesGetDdl_593979, base: "/",
    url: url_SpannerProjectsInstancesDatabasesGetDdl_593980,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesUpdateDdl_593997 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesUpdateDdl_593999(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/ddl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesUpdateDdl_593998(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database to update.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_594000 = path.getOrDefault("database")
  valid_594000 = validateParameter(valid_594000, JString, required = true,
                                 default = nil)
  if valid_594000 != nil:
    section.add "database", valid_594000
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594001 = query.getOrDefault("upload_protocol")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = nil)
  if valid_594001 != nil:
    section.add "upload_protocol", valid_594001
  var valid_594002 = query.getOrDefault("fields")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "fields", valid_594002
  var valid_594003 = query.getOrDefault("quotaUser")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "quotaUser", valid_594003
  var valid_594004 = query.getOrDefault("alt")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = newJString("json"))
  if valid_594004 != nil:
    section.add "alt", valid_594004
  var valid_594005 = query.getOrDefault("oauth_token")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = nil)
  if valid_594005 != nil:
    section.add "oauth_token", valid_594005
  var valid_594006 = query.getOrDefault("callback")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "callback", valid_594006
  var valid_594007 = query.getOrDefault("access_token")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "access_token", valid_594007
  var valid_594008 = query.getOrDefault("uploadType")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "uploadType", valid_594008
  var valid_594009 = query.getOrDefault("key")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = nil)
  if valid_594009 != nil:
    section.add "key", valid_594009
  var valid_594010 = query.getOrDefault("$.xgafv")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = newJString("1"))
  if valid_594010 != nil:
    section.add "$.xgafv", valid_594010
  var valid_594011 = query.getOrDefault("prettyPrint")
  valid_594011 = validateParameter(valid_594011, JBool, required = false,
                                 default = newJBool(true))
  if valid_594011 != nil:
    section.add "prettyPrint", valid_594011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594013: Call_SpannerProjectsInstancesDatabasesUpdateDdl_593997;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ## 
  let valid = call_594013.validator(path, query, header, formData, body)
  let scheme = call_594013.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594013.url(scheme.get, call_594013.host, call_594013.base,
                         call_594013.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594013, url, valid)

proc call*(call_594014: Call_SpannerProjectsInstancesDatabasesUpdateDdl_593997;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesUpdateDdl
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database to update.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594015 = newJObject()
  var query_594016 = newJObject()
  var body_594017 = newJObject()
  add(query_594016, "upload_protocol", newJString(uploadProtocol))
  add(query_594016, "fields", newJString(fields))
  add(query_594016, "quotaUser", newJString(quotaUser))
  add(query_594016, "alt", newJString(alt))
  add(query_594016, "oauth_token", newJString(oauthToken))
  add(query_594016, "callback", newJString(callback))
  add(query_594016, "access_token", newJString(accessToken))
  add(query_594016, "uploadType", newJString(uploadType))
  add(query_594016, "key", newJString(key))
  add(path_594015, "database", newJString(database))
  add(query_594016, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594017 = body
  add(query_594016, "prettyPrint", newJBool(prettyPrint))
  result = call_594014.call(path_594015, query_594016, nil, nil, body_594017)

var spannerProjectsInstancesDatabasesUpdateDdl* = Call_SpannerProjectsInstancesDatabasesUpdateDdl_593997(
    name: "spannerProjectsInstancesDatabasesUpdateDdl",
    meth: HttpMethod.HttpPatch, host: "spanner.googleapis.com",
    route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesUpdateDdl_593998,
    base: "/", url: url_SpannerProjectsInstancesDatabasesUpdateDdl_593999,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCreate_594040 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsCreate_594042(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/sessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsCreate_594041(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a new session. A session can be used to perform
  ## transactions that read and/or modify data in a Cloud Spanner database.
  ## Sessions are meant to be reused for many consecutive
  ## transactions.
  ## 
  ## Sessions can only execute one transaction at a time. To execute
  ## multiple concurrent read-write/write-only transactions, create
  ## multiple sessions. Note that standalone reads and queries use a
  ## transaction internally, and count toward the one transaction
  ## limit.
  ## 
  ## Active sessions use additional server resources, so it is a good idea to
  ## delete idle and unneeded sessions.
  ## Aside from explicit deletes, Cloud Spanner can delete sessions for which no
  ## operations are sent for more than an hour. If a session is deleted,
  ## requests to it return `NOT_FOUND`.
  ## 
  ## Idle sessions can be kept alive by sending a trivial SQL query
  ## periodically, e.g., `"SELECT 1"`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database in which the new session is created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_594043 = path.getOrDefault("database")
  valid_594043 = validateParameter(valid_594043, JString, required = true,
                                 default = nil)
  if valid_594043 != nil:
    section.add "database", valid_594043
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594044 = query.getOrDefault("upload_protocol")
  valid_594044 = validateParameter(valid_594044, JString, required = false,
                                 default = nil)
  if valid_594044 != nil:
    section.add "upload_protocol", valid_594044
  var valid_594045 = query.getOrDefault("fields")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "fields", valid_594045
  var valid_594046 = query.getOrDefault("quotaUser")
  valid_594046 = validateParameter(valid_594046, JString, required = false,
                                 default = nil)
  if valid_594046 != nil:
    section.add "quotaUser", valid_594046
  var valid_594047 = query.getOrDefault("alt")
  valid_594047 = validateParameter(valid_594047, JString, required = false,
                                 default = newJString("json"))
  if valid_594047 != nil:
    section.add "alt", valid_594047
  var valid_594048 = query.getOrDefault("oauth_token")
  valid_594048 = validateParameter(valid_594048, JString, required = false,
                                 default = nil)
  if valid_594048 != nil:
    section.add "oauth_token", valid_594048
  var valid_594049 = query.getOrDefault("callback")
  valid_594049 = validateParameter(valid_594049, JString, required = false,
                                 default = nil)
  if valid_594049 != nil:
    section.add "callback", valid_594049
  var valid_594050 = query.getOrDefault("access_token")
  valid_594050 = validateParameter(valid_594050, JString, required = false,
                                 default = nil)
  if valid_594050 != nil:
    section.add "access_token", valid_594050
  var valid_594051 = query.getOrDefault("uploadType")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "uploadType", valid_594051
  var valid_594052 = query.getOrDefault("key")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "key", valid_594052
  var valid_594053 = query.getOrDefault("$.xgafv")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("1"))
  if valid_594053 != nil:
    section.add "$.xgafv", valid_594053
  var valid_594054 = query.getOrDefault("prettyPrint")
  valid_594054 = validateParameter(valid_594054, JBool, required = false,
                                 default = newJBool(true))
  if valid_594054 != nil:
    section.add "prettyPrint", valid_594054
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594056: Call_SpannerProjectsInstancesDatabasesSessionsCreate_594040;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new session. A session can be used to perform
  ## transactions that read and/or modify data in a Cloud Spanner database.
  ## Sessions are meant to be reused for many consecutive
  ## transactions.
  ## 
  ## Sessions can only execute one transaction at a time. To execute
  ## multiple concurrent read-write/write-only transactions, create
  ## multiple sessions. Note that standalone reads and queries use a
  ## transaction internally, and count toward the one transaction
  ## limit.
  ## 
  ## Active sessions use additional server resources, so it is a good idea to
  ## delete idle and unneeded sessions.
  ## Aside from explicit deletes, Cloud Spanner can delete sessions for which no
  ## operations are sent for more than an hour. If a session is deleted,
  ## requests to it return `NOT_FOUND`.
  ## 
  ## Idle sessions can be kept alive by sending a trivial SQL query
  ## periodically, e.g., `"SELECT 1"`.
  ## 
  let valid = call_594056.validator(path, query, header, formData, body)
  let scheme = call_594056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594056.url(scheme.get, call_594056.host, call_594056.base,
                         call_594056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594056, url, valid)

proc call*(call_594057: Call_SpannerProjectsInstancesDatabasesSessionsCreate_594040;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsCreate
  ## Creates a new session. A session can be used to perform
  ## transactions that read and/or modify data in a Cloud Spanner database.
  ## Sessions are meant to be reused for many consecutive
  ## transactions.
  ## 
  ## Sessions can only execute one transaction at a time. To execute
  ## multiple concurrent read-write/write-only transactions, create
  ## multiple sessions. Note that standalone reads and queries use a
  ## transaction internally, and count toward the one transaction
  ## limit.
  ## 
  ## Active sessions use additional server resources, so it is a good idea to
  ## delete idle and unneeded sessions.
  ## Aside from explicit deletes, Cloud Spanner can delete sessions for which no
  ## operations are sent for more than an hour. If a session is deleted,
  ## requests to it return `NOT_FOUND`.
  ## 
  ## Idle sessions can be kept alive by sending a trivial SQL query
  ## periodically, e.g., `"SELECT 1"`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database in which the new session is created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594058 = newJObject()
  var query_594059 = newJObject()
  var body_594060 = newJObject()
  add(query_594059, "upload_protocol", newJString(uploadProtocol))
  add(query_594059, "fields", newJString(fields))
  add(query_594059, "quotaUser", newJString(quotaUser))
  add(query_594059, "alt", newJString(alt))
  add(query_594059, "oauth_token", newJString(oauthToken))
  add(query_594059, "callback", newJString(callback))
  add(query_594059, "access_token", newJString(accessToken))
  add(query_594059, "uploadType", newJString(uploadType))
  add(query_594059, "key", newJString(key))
  add(path_594058, "database", newJString(database))
  add(query_594059, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594060 = body
  add(query_594059, "prettyPrint", newJBool(prettyPrint))
  result = call_594057.call(path_594058, query_594059, nil, nil, body_594060)

var spannerProjectsInstancesDatabasesSessionsCreate* = Call_SpannerProjectsInstancesDatabasesSessionsCreate_594040(
    name: "spannerProjectsInstancesDatabasesSessionsCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCreate_594041,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCreate_594042,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsList_594018 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsList_594020(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/sessions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsList_594019(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists all sessions in a given database.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database in which to list sessions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_594021 = path.getOrDefault("database")
  valid_594021 = validateParameter(valid_594021, JString, required = true,
                                 default = nil)
  if valid_594021 != nil:
    section.add "database", valid_594021
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `labels.env:*` --> The session has the label "env".
  ##   * `labels.env:dev` --> The session has the label "env" and the value of
  ##                        the label contains the string "dev".
  section = newJObject()
  var valid_594022 = query.getOrDefault("upload_protocol")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "upload_protocol", valid_594022
  var valid_594023 = query.getOrDefault("fields")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "fields", valid_594023
  var valid_594024 = query.getOrDefault("pageToken")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "pageToken", valid_594024
  var valid_594025 = query.getOrDefault("quotaUser")
  valid_594025 = validateParameter(valid_594025, JString, required = false,
                                 default = nil)
  if valid_594025 != nil:
    section.add "quotaUser", valid_594025
  var valid_594026 = query.getOrDefault("alt")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = newJString("json"))
  if valid_594026 != nil:
    section.add "alt", valid_594026
  var valid_594027 = query.getOrDefault("oauth_token")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "oauth_token", valid_594027
  var valid_594028 = query.getOrDefault("callback")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "callback", valid_594028
  var valid_594029 = query.getOrDefault("access_token")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = nil)
  if valid_594029 != nil:
    section.add "access_token", valid_594029
  var valid_594030 = query.getOrDefault("uploadType")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "uploadType", valid_594030
  var valid_594031 = query.getOrDefault("key")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "key", valid_594031
  var valid_594032 = query.getOrDefault("$.xgafv")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = newJString("1"))
  if valid_594032 != nil:
    section.add "$.xgafv", valid_594032
  var valid_594033 = query.getOrDefault("pageSize")
  valid_594033 = validateParameter(valid_594033, JInt, required = false, default = nil)
  if valid_594033 != nil:
    section.add "pageSize", valid_594033
  var valid_594034 = query.getOrDefault("prettyPrint")
  valid_594034 = validateParameter(valid_594034, JBool, required = false,
                                 default = newJBool(true))
  if valid_594034 != nil:
    section.add "prettyPrint", valid_594034
  var valid_594035 = query.getOrDefault("filter")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "filter", valid_594035
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594036: Call_SpannerProjectsInstancesDatabasesSessionsList_594018;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sessions in a given database.
  ## 
  let valid = call_594036.validator(path, query, header, formData, body)
  let scheme = call_594036.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594036.url(scheme.get, call_594036.host, call_594036.base,
                         call_594036.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594036, url, valid)

proc call*(call_594037: Call_SpannerProjectsInstancesDatabasesSessionsList_594018;
          database: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsList
  ## Lists all sessions in a given database.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database in which to list sessions.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `labels.env:*` --> The session has the label "env".
  ##   * `labels.env:dev` --> The session has the label "env" and the value of
  ##                        the label contains the string "dev".
  var path_594038 = newJObject()
  var query_594039 = newJObject()
  add(query_594039, "upload_protocol", newJString(uploadProtocol))
  add(query_594039, "fields", newJString(fields))
  add(query_594039, "pageToken", newJString(pageToken))
  add(query_594039, "quotaUser", newJString(quotaUser))
  add(query_594039, "alt", newJString(alt))
  add(query_594039, "oauth_token", newJString(oauthToken))
  add(query_594039, "callback", newJString(callback))
  add(query_594039, "access_token", newJString(accessToken))
  add(query_594039, "uploadType", newJString(uploadType))
  add(query_594039, "key", newJString(key))
  add(path_594038, "database", newJString(database))
  add(query_594039, "$.xgafv", newJString(Xgafv))
  add(query_594039, "pageSize", newJInt(pageSize))
  add(query_594039, "prettyPrint", newJBool(prettyPrint))
  add(query_594039, "filter", newJString(filter))
  result = call_594037.call(path_594038, query_594039, nil, nil, nil)

var spannerProjectsInstancesDatabasesSessionsList* = Call_SpannerProjectsInstancesDatabasesSessionsList_594018(
    name: "spannerProjectsInstancesDatabasesSessionsList",
    meth: HttpMethod.HttpGet, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsList_594019,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsList_594020,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594061 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594063(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database"),
               (kind: ConstantSegment, value: "/sessions:batchCreate")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594062(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   database: JString (required)
  ##           : Required. The database in which the new sessions are created.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `database` field"
  var valid_594064 = path.getOrDefault("database")
  valid_594064 = validateParameter(valid_594064, JString, required = true,
                                 default = nil)
  if valid_594064 != nil:
    section.add "database", valid_594064
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594065 = query.getOrDefault("upload_protocol")
  valid_594065 = validateParameter(valid_594065, JString, required = false,
                                 default = nil)
  if valid_594065 != nil:
    section.add "upload_protocol", valid_594065
  var valid_594066 = query.getOrDefault("fields")
  valid_594066 = validateParameter(valid_594066, JString, required = false,
                                 default = nil)
  if valid_594066 != nil:
    section.add "fields", valid_594066
  var valid_594067 = query.getOrDefault("quotaUser")
  valid_594067 = validateParameter(valid_594067, JString, required = false,
                                 default = nil)
  if valid_594067 != nil:
    section.add "quotaUser", valid_594067
  var valid_594068 = query.getOrDefault("alt")
  valid_594068 = validateParameter(valid_594068, JString, required = false,
                                 default = newJString("json"))
  if valid_594068 != nil:
    section.add "alt", valid_594068
  var valid_594069 = query.getOrDefault("oauth_token")
  valid_594069 = validateParameter(valid_594069, JString, required = false,
                                 default = nil)
  if valid_594069 != nil:
    section.add "oauth_token", valid_594069
  var valid_594070 = query.getOrDefault("callback")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "callback", valid_594070
  var valid_594071 = query.getOrDefault("access_token")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "access_token", valid_594071
  var valid_594072 = query.getOrDefault("uploadType")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = nil)
  if valid_594072 != nil:
    section.add "uploadType", valid_594072
  var valid_594073 = query.getOrDefault("key")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "key", valid_594073
  var valid_594074 = query.getOrDefault("$.xgafv")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = newJString("1"))
  if valid_594074 != nil:
    section.add "$.xgafv", valid_594074
  var valid_594075 = query.getOrDefault("prettyPrint")
  valid_594075 = validateParameter(valid_594075, JBool, required = false,
                                 default = newJBool(true))
  if valid_594075 != nil:
    section.add "prettyPrint", valid_594075
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594077: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ## 
  let valid = call_594077.validator(path, query, header, formData, body)
  let scheme = call_594077.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594077.url(scheme.get, call_594077.host, call_594077.base,
                         call_594077.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594077, url, valid)

proc call*(call_594078: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594061;
          database: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBatchCreate
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   database: string (required)
  ##           : Required. The database in which the new sessions are created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594079 = newJObject()
  var query_594080 = newJObject()
  var body_594081 = newJObject()
  add(query_594080, "upload_protocol", newJString(uploadProtocol))
  add(query_594080, "fields", newJString(fields))
  add(query_594080, "quotaUser", newJString(quotaUser))
  add(query_594080, "alt", newJString(alt))
  add(query_594080, "oauth_token", newJString(oauthToken))
  add(query_594080, "callback", newJString(callback))
  add(query_594080, "access_token", newJString(accessToken))
  add(query_594080, "uploadType", newJString(uploadType))
  add(query_594080, "key", newJString(key))
  add(path_594079, "database", newJString(database))
  add(query_594080, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594081 = body
  add(query_594080, "prettyPrint", newJBool(prettyPrint))
  result = call_594078.call(path_594079, query_594080, nil, nil, body_594081)

var spannerProjectsInstancesDatabasesSessionsBatchCreate* = Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594061(
    name: "spannerProjectsInstancesDatabasesSessionsBatchCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions:batchCreate",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594062,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_594063,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsGet_594082 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstanceConfigsGet_594084(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstanceConfigsGet_594083(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets information about a particular instance configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the requested instance configuration. Values are of
  ## the form `projects/<project>/instanceConfigs/<config>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594085 = path.getOrDefault("name")
  valid_594085 = validateParameter(valid_594085, JString, required = true,
                                 default = nil)
  if valid_594085 != nil:
    section.add "name", valid_594085
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594086 = query.getOrDefault("upload_protocol")
  valid_594086 = validateParameter(valid_594086, JString, required = false,
                                 default = nil)
  if valid_594086 != nil:
    section.add "upload_protocol", valid_594086
  var valid_594087 = query.getOrDefault("fields")
  valid_594087 = validateParameter(valid_594087, JString, required = false,
                                 default = nil)
  if valid_594087 != nil:
    section.add "fields", valid_594087
  var valid_594088 = query.getOrDefault("quotaUser")
  valid_594088 = validateParameter(valid_594088, JString, required = false,
                                 default = nil)
  if valid_594088 != nil:
    section.add "quotaUser", valid_594088
  var valid_594089 = query.getOrDefault("alt")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = newJString("json"))
  if valid_594089 != nil:
    section.add "alt", valid_594089
  var valid_594090 = query.getOrDefault("oauth_token")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "oauth_token", valid_594090
  var valid_594091 = query.getOrDefault("callback")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = nil)
  if valid_594091 != nil:
    section.add "callback", valid_594091
  var valid_594092 = query.getOrDefault("access_token")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "access_token", valid_594092
  var valid_594093 = query.getOrDefault("uploadType")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "uploadType", valid_594093
  var valid_594094 = query.getOrDefault("key")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "key", valid_594094
  var valid_594095 = query.getOrDefault("$.xgafv")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = newJString("1"))
  if valid_594095 != nil:
    section.add "$.xgafv", valid_594095
  var valid_594096 = query.getOrDefault("prettyPrint")
  valid_594096 = validateParameter(valid_594096, JBool, required = false,
                                 default = newJBool(true))
  if valid_594096 != nil:
    section.add "prettyPrint", valid_594096
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594097: Call_SpannerProjectsInstanceConfigsGet_594082;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a particular instance configuration.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_SpannerProjectsInstanceConfigsGet_594082;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstanceConfigsGet
  ## Gets information about a particular instance configuration.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the requested instance configuration. Values are of
  ## the form `projects/<project>/instanceConfigs/<config>`.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  add(query_594100, "upload_protocol", newJString(uploadProtocol))
  add(query_594100, "fields", newJString(fields))
  add(query_594100, "quotaUser", newJString(quotaUser))
  add(path_594099, "name", newJString(name))
  add(query_594100, "alt", newJString(alt))
  add(query_594100, "oauth_token", newJString(oauthToken))
  add(query_594100, "callback", newJString(callback))
  add(query_594100, "access_token", newJString(accessToken))
  add(query_594100, "uploadType", newJString(uploadType))
  add(query_594100, "key", newJString(key))
  add(query_594100, "$.xgafv", newJString(Xgafv))
  add(query_594100, "prettyPrint", newJBool(prettyPrint))
  result = call_594098.call(path_594099, query_594100, nil, nil, nil)

var spannerProjectsInstanceConfigsGet* = Call_SpannerProjectsInstanceConfigsGet_594082(
    name: "spannerProjectsInstanceConfigsGet", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstanceConfigsGet_594083, base: "/",
    url: url_SpannerProjectsInstanceConfigsGet_594084, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesPatch_594120 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesPatch_594122(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesPatch_594121(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an instance, and begins allocating or releasing resources
  ## as requested. The returned long-running
  ## operation can be used to track the
  ## progress of updating the instance. If the named instance does not
  ## exist, returns `NOT_FOUND`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * For resource types for which a decrease in the instance's allocation
  ##     has been requested, billing is based on the newly-requested level.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation sets its metadata's
  ##     cancel_time, and begins
  ##     restoring resources to their pre-request values. The operation
  ##     is guaranteed to succeed at undoing all resource changes,
  ##     after which point it terminates with a `CANCELLED` status.
  ##   * All other attempts to modify the instance are rejected.
  ##   * Reading the instance via the API continues to give the pre-request
  ##     resource levels.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing begins for all successfully-allocated resources (some types
  ##     may have lower than the requested levels).
  ##   * All newly-reserved resources are available for serving the instance's
  ##     tables.
  ##   * The instance's new resource levels are readable via the API.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track the instance modification.  The
  ## metadata field type is
  ## UpdateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  ## Authorization requires `spanner.instances.update` permission on
  ## resource name.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. A unique identifier for the instance, which cannot be changed
  ## after the instance is created. Values are of the form
  ## `projects/<project>/instances/a-z*[a-z0-9]`. The final
  ## segment of the name must be between 2 and 64 characters in length.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594123 = path.getOrDefault("name")
  valid_594123 = validateParameter(valid_594123, JString, required = true,
                                 default = nil)
  if valid_594123 != nil:
    section.add "name", valid_594123
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594124 = query.getOrDefault("upload_protocol")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "upload_protocol", valid_594124
  var valid_594125 = query.getOrDefault("fields")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = nil)
  if valid_594125 != nil:
    section.add "fields", valid_594125
  var valid_594126 = query.getOrDefault("quotaUser")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "quotaUser", valid_594126
  var valid_594127 = query.getOrDefault("alt")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = newJString("json"))
  if valid_594127 != nil:
    section.add "alt", valid_594127
  var valid_594128 = query.getOrDefault("oauth_token")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "oauth_token", valid_594128
  var valid_594129 = query.getOrDefault("callback")
  valid_594129 = validateParameter(valid_594129, JString, required = false,
                                 default = nil)
  if valid_594129 != nil:
    section.add "callback", valid_594129
  var valid_594130 = query.getOrDefault("access_token")
  valid_594130 = validateParameter(valid_594130, JString, required = false,
                                 default = nil)
  if valid_594130 != nil:
    section.add "access_token", valid_594130
  var valid_594131 = query.getOrDefault("uploadType")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "uploadType", valid_594131
  var valid_594132 = query.getOrDefault("key")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "key", valid_594132
  var valid_594133 = query.getOrDefault("$.xgafv")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = newJString("1"))
  if valid_594133 != nil:
    section.add "$.xgafv", valid_594133
  var valid_594134 = query.getOrDefault("prettyPrint")
  valid_594134 = validateParameter(valid_594134, JBool, required = false,
                                 default = newJBool(true))
  if valid_594134 != nil:
    section.add "prettyPrint", valid_594134
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594136: Call_SpannerProjectsInstancesPatch_594120; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an instance, and begins allocating or releasing resources
  ## as requested. The returned long-running
  ## operation can be used to track the
  ## progress of updating the instance. If the named instance does not
  ## exist, returns `NOT_FOUND`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * For resource types for which a decrease in the instance's allocation
  ##     has been requested, billing is based on the newly-requested level.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation sets its metadata's
  ##     cancel_time, and begins
  ##     restoring resources to their pre-request values. The operation
  ##     is guaranteed to succeed at undoing all resource changes,
  ##     after which point it terminates with a `CANCELLED` status.
  ##   * All other attempts to modify the instance are rejected.
  ##   * Reading the instance via the API continues to give the pre-request
  ##     resource levels.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing begins for all successfully-allocated resources (some types
  ##     may have lower than the requested levels).
  ##   * All newly-reserved resources are available for serving the instance's
  ##     tables.
  ##   * The instance's new resource levels are readable via the API.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track the instance modification.  The
  ## metadata field type is
  ## UpdateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  ## Authorization requires `spanner.instances.update` permission on
  ## resource name.
  ## 
  let valid = call_594136.validator(path, query, header, formData, body)
  let scheme = call_594136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594136.url(scheme.get, call_594136.host, call_594136.base,
                         call_594136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594136, url, valid)

proc call*(call_594137: Call_SpannerProjectsInstancesPatch_594120; name: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesPatch
  ## Updates an instance, and begins allocating or releasing resources
  ## as requested. The returned long-running
  ## operation can be used to track the
  ## progress of updating the instance. If the named instance does not
  ## exist, returns `NOT_FOUND`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * For resource types for which a decrease in the instance's allocation
  ##     has been requested, billing is based on the newly-requested level.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation sets its metadata's
  ##     cancel_time, and begins
  ##     restoring resources to their pre-request values. The operation
  ##     is guaranteed to succeed at undoing all resource changes,
  ##     after which point it terminates with a `CANCELLED` status.
  ##   * All other attempts to modify the instance are rejected.
  ##   * Reading the instance via the API continues to give the pre-request
  ##     resource levels.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing begins for all successfully-allocated resources (some types
  ##     may have lower than the requested levels).
  ##   * All newly-reserved resources are available for serving the instance's
  ##     tables.
  ##   * The instance's new resource levels are readable via the API.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track the instance modification.  The
  ## metadata field type is
  ## UpdateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  ## Authorization requires `spanner.instances.update` permission on
  ## resource name.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. A unique identifier for the instance, which cannot be changed
  ## after the instance is created. Values are of the form
  ## `projects/<project>/instances/a-z*[a-z0-9]`. The final
  ## segment of the name must be between 2 and 64 characters in length.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594138 = newJObject()
  var query_594139 = newJObject()
  var body_594140 = newJObject()
  add(query_594139, "upload_protocol", newJString(uploadProtocol))
  add(query_594139, "fields", newJString(fields))
  add(query_594139, "quotaUser", newJString(quotaUser))
  add(path_594138, "name", newJString(name))
  add(query_594139, "alt", newJString(alt))
  add(query_594139, "oauth_token", newJString(oauthToken))
  add(query_594139, "callback", newJString(callback))
  add(query_594139, "access_token", newJString(accessToken))
  add(query_594139, "uploadType", newJString(uploadType))
  add(query_594139, "key", newJString(key))
  add(query_594139, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594140 = body
  add(query_594139, "prettyPrint", newJBool(prettyPrint))
  result = call_594137.call(path_594138, query_594139, nil, nil, body_594140)

var spannerProjectsInstancesPatch* = Call_SpannerProjectsInstancesPatch_594120(
    name: "spannerProjectsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesPatch_594121, base: "/",
    url: url_SpannerProjectsInstancesPatch_594122, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsDelete_594101 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsDelete_594103(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsDelete_594102(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Ends a session, releasing server resources associated with it. This will
  ## asynchronously trigger cancellation of any operations that are running with
  ## this session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. The name of the session to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594104 = path.getOrDefault("name")
  valid_594104 = validateParameter(valid_594104, JString, required = true,
                                 default = nil)
  if valid_594104 != nil:
    section.add "name", valid_594104
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594105 = query.getOrDefault("upload_protocol")
  valid_594105 = validateParameter(valid_594105, JString, required = false,
                                 default = nil)
  if valid_594105 != nil:
    section.add "upload_protocol", valid_594105
  var valid_594106 = query.getOrDefault("fields")
  valid_594106 = validateParameter(valid_594106, JString, required = false,
                                 default = nil)
  if valid_594106 != nil:
    section.add "fields", valid_594106
  var valid_594107 = query.getOrDefault("quotaUser")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "quotaUser", valid_594107
  var valid_594108 = query.getOrDefault("alt")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = newJString("json"))
  if valid_594108 != nil:
    section.add "alt", valid_594108
  var valid_594109 = query.getOrDefault("oauth_token")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = nil)
  if valid_594109 != nil:
    section.add "oauth_token", valid_594109
  var valid_594110 = query.getOrDefault("callback")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "callback", valid_594110
  var valid_594111 = query.getOrDefault("access_token")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "access_token", valid_594111
  var valid_594112 = query.getOrDefault("uploadType")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "uploadType", valid_594112
  var valid_594113 = query.getOrDefault("key")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = nil)
  if valid_594113 != nil:
    section.add "key", valid_594113
  var valid_594114 = query.getOrDefault("$.xgafv")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = newJString("1"))
  if valid_594114 != nil:
    section.add "$.xgafv", valid_594114
  var valid_594115 = query.getOrDefault("prettyPrint")
  valid_594115 = validateParameter(valid_594115, JBool, required = false,
                                 default = newJBool(true))
  if valid_594115 != nil:
    section.add "prettyPrint", valid_594115
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594116: Call_SpannerProjectsInstancesDatabasesSessionsDelete_594101;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Ends a session, releasing server resources associated with it. This will
  ## asynchronously trigger cancellation of any operations that are running with
  ## this session.
  ## 
  let valid = call_594116.validator(path, query, header, formData, body)
  let scheme = call_594116.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594116.url(scheme.get, call_594116.host, call_594116.base,
                         call_594116.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594116, url, valid)

proc call*(call_594117: Call_SpannerProjectsInstancesDatabasesSessionsDelete_594101;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsDelete
  ## Ends a session, releasing server resources associated with it. This will
  ## asynchronously trigger cancellation of any operations that are running with
  ## this session.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the session to delete.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594118 = newJObject()
  var query_594119 = newJObject()
  add(query_594119, "upload_protocol", newJString(uploadProtocol))
  add(query_594119, "fields", newJString(fields))
  add(query_594119, "quotaUser", newJString(quotaUser))
  add(path_594118, "name", newJString(name))
  add(query_594119, "alt", newJString(alt))
  add(query_594119, "oauth_token", newJString(oauthToken))
  add(query_594119, "callback", newJString(callback))
  add(query_594119, "access_token", newJString(accessToken))
  add(query_594119, "uploadType", newJString(uploadType))
  add(query_594119, "key", newJString(key))
  add(query_594119, "$.xgafv", newJString(Xgafv))
  add(query_594119, "prettyPrint", newJBool(prettyPrint))
  result = call_594117.call(path_594118, query_594119, nil, nil, nil)

var spannerProjectsInstancesDatabasesSessionsDelete* = Call_SpannerProjectsInstancesDatabasesSessionsDelete_594101(
    name: "spannerProjectsInstancesDatabasesSessionsDelete",
    meth: HttpMethod.HttpDelete, host: "spanner.googleapis.com",
    route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsDelete_594102,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsDelete_594103,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesOperationsCancel_594141 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesOperationsCancel_594143(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesOperationsCancel_594142(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be cancelled.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_594144 = path.getOrDefault("name")
  valid_594144 = validateParameter(valid_594144, JString, required = true,
                                 default = nil)
  if valid_594144 != nil:
    section.add "name", valid_594144
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594145 = query.getOrDefault("upload_protocol")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "upload_protocol", valid_594145
  var valid_594146 = query.getOrDefault("fields")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "fields", valid_594146
  var valid_594147 = query.getOrDefault("quotaUser")
  valid_594147 = validateParameter(valid_594147, JString, required = false,
                                 default = nil)
  if valid_594147 != nil:
    section.add "quotaUser", valid_594147
  var valid_594148 = query.getOrDefault("alt")
  valid_594148 = validateParameter(valid_594148, JString, required = false,
                                 default = newJString("json"))
  if valid_594148 != nil:
    section.add "alt", valid_594148
  var valid_594149 = query.getOrDefault("oauth_token")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "oauth_token", valid_594149
  var valid_594150 = query.getOrDefault("callback")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "callback", valid_594150
  var valid_594151 = query.getOrDefault("access_token")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = nil)
  if valid_594151 != nil:
    section.add "access_token", valid_594151
  var valid_594152 = query.getOrDefault("uploadType")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "uploadType", valid_594152
  var valid_594153 = query.getOrDefault("key")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "key", valid_594153
  var valid_594154 = query.getOrDefault("$.xgafv")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = newJString("1"))
  if valid_594154 != nil:
    section.add "$.xgafv", valid_594154
  var valid_594155 = query.getOrDefault("prettyPrint")
  valid_594155 = validateParameter(valid_594155, JBool, required = false,
                                 default = newJBool(true))
  if valid_594155 != nil:
    section.add "prettyPrint", valid_594155
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594156: Call_SpannerProjectsInstancesDatabasesOperationsCancel_594141;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ## 
  let valid = call_594156.validator(path, query, header, formData, body)
  let scheme = call_594156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594156.url(scheme.get, call_594156.host, call_594156.base,
                         call_594156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594156, url, valid)

proc call*(call_594157: Call_SpannerProjectsInstancesDatabasesOperationsCancel_594141;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesOperationsCancel
  ## Starts asynchronous cancellation on a long-running operation.  The server
  ## makes a best effort to cancel the operation, but success is not
  ## guaranteed.  If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.  Clients can use
  ## Operations.GetOperation or
  ## other methods to check whether the cancellation succeeded or whether the
  ## operation completed despite cancellation. On successful cancellation,
  ## the operation is not deleted; instead, it becomes an operation with
  ## an Operation.error value with a google.rpc.Status.code of 1,
  ## corresponding to `Code.CANCELLED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594158 = newJObject()
  var query_594159 = newJObject()
  add(query_594159, "upload_protocol", newJString(uploadProtocol))
  add(query_594159, "fields", newJString(fields))
  add(query_594159, "quotaUser", newJString(quotaUser))
  add(path_594158, "name", newJString(name))
  add(query_594159, "alt", newJString(alt))
  add(query_594159, "oauth_token", newJString(oauthToken))
  add(query_594159, "callback", newJString(callback))
  add(query_594159, "access_token", newJString(accessToken))
  add(query_594159, "uploadType", newJString(uploadType))
  add(query_594159, "key", newJString(key))
  add(query_594159, "$.xgafv", newJString(Xgafv))
  add(query_594159, "prettyPrint", newJBool(prettyPrint))
  result = call_594157.call(path_594158, query_594159, nil, nil, nil)

var spannerProjectsInstancesDatabasesOperationsCancel* = Call_SpannerProjectsInstancesDatabasesOperationsCancel_594141(
    name: "spannerProjectsInstancesDatabasesOperationsCancel",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{name}:cancel",
    validator: validate_SpannerProjectsInstancesDatabasesOperationsCancel_594142,
    base: "/", url: url_SpannerProjectsInstancesDatabasesOperationsCancel_594143,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesCreate_594181 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesCreate_594183(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesCreate_594182(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the instance that will serve the new database.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594184 = path.getOrDefault("parent")
  valid_594184 = validateParameter(valid_594184, JString, required = true,
                                 default = nil)
  if valid_594184 != nil:
    section.add "parent", valid_594184
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594185 = query.getOrDefault("upload_protocol")
  valid_594185 = validateParameter(valid_594185, JString, required = false,
                                 default = nil)
  if valid_594185 != nil:
    section.add "upload_protocol", valid_594185
  var valid_594186 = query.getOrDefault("fields")
  valid_594186 = validateParameter(valid_594186, JString, required = false,
                                 default = nil)
  if valid_594186 != nil:
    section.add "fields", valid_594186
  var valid_594187 = query.getOrDefault("quotaUser")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "quotaUser", valid_594187
  var valid_594188 = query.getOrDefault("alt")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = newJString("json"))
  if valid_594188 != nil:
    section.add "alt", valid_594188
  var valid_594189 = query.getOrDefault("oauth_token")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = nil)
  if valid_594189 != nil:
    section.add "oauth_token", valid_594189
  var valid_594190 = query.getOrDefault("callback")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "callback", valid_594190
  var valid_594191 = query.getOrDefault("access_token")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "access_token", valid_594191
  var valid_594192 = query.getOrDefault("uploadType")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "uploadType", valid_594192
  var valid_594193 = query.getOrDefault("key")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "key", valid_594193
  var valid_594194 = query.getOrDefault("$.xgafv")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = newJString("1"))
  if valid_594194 != nil:
    section.add "$.xgafv", valid_594194
  var valid_594195 = query.getOrDefault("prettyPrint")
  valid_594195 = validateParameter(valid_594195, JBool, required = false,
                                 default = newJBool(true))
  if valid_594195 != nil:
    section.add "prettyPrint", valid_594195
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594197: Call_SpannerProjectsInstancesDatabasesCreate_594181;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_SpannerProjectsInstancesDatabasesCreate_594181;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesCreate
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the instance that will serve the new database.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  var body_594201 = newJObject()
  add(query_594200, "upload_protocol", newJString(uploadProtocol))
  add(query_594200, "fields", newJString(fields))
  add(query_594200, "quotaUser", newJString(quotaUser))
  add(query_594200, "alt", newJString(alt))
  add(query_594200, "oauth_token", newJString(oauthToken))
  add(query_594200, "callback", newJString(callback))
  add(query_594200, "access_token", newJString(accessToken))
  add(query_594200, "uploadType", newJString(uploadType))
  add(path_594199, "parent", newJString(parent))
  add(query_594200, "key", newJString(key))
  add(query_594200, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594201 = body
  add(query_594200, "prettyPrint", newJBool(prettyPrint))
  result = call_594198.call(path_594199, query_594200, nil, nil, body_594201)

var spannerProjectsInstancesDatabasesCreate* = Call_SpannerProjectsInstancesDatabasesCreate_594181(
    name: "spannerProjectsInstancesDatabasesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesCreate_594182, base: "/",
    url: url_SpannerProjectsInstancesDatabasesCreate_594183,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesList_594160 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesList_594162(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/databases")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesList_594161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists Cloud Spanner databases.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The instance whose databases should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594163 = path.getOrDefault("parent")
  valid_594163 = validateParameter(valid_594163, JString, required = true,
                                 default = nil)
  if valid_594163 != nil:
    section.add "parent", valid_594163
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594164 = query.getOrDefault("upload_protocol")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "upload_protocol", valid_594164
  var valid_594165 = query.getOrDefault("fields")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "fields", valid_594165
  var valid_594166 = query.getOrDefault("pageToken")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = nil)
  if valid_594166 != nil:
    section.add "pageToken", valid_594166
  var valid_594167 = query.getOrDefault("quotaUser")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "quotaUser", valid_594167
  var valid_594168 = query.getOrDefault("alt")
  valid_594168 = validateParameter(valid_594168, JString, required = false,
                                 default = newJString("json"))
  if valid_594168 != nil:
    section.add "alt", valid_594168
  var valid_594169 = query.getOrDefault("oauth_token")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "oauth_token", valid_594169
  var valid_594170 = query.getOrDefault("callback")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "callback", valid_594170
  var valid_594171 = query.getOrDefault("access_token")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = nil)
  if valid_594171 != nil:
    section.add "access_token", valid_594171
  var valid_594172 = query.getOrDefault("uploadType")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "uploadType", valid_594172
  var valid_594173 = query.getOrDefault("key")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "key", valid_594173
  var valid_594174 = query.getOrDefault("$.xgafv")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = newJString("1"))
  if valid_594174 != nil:
    section.add "$.xgafv", valid_594174
  var valid_594175 = query.getOrDefault("pageSize")
  valid_594175 = validateParameter(valid_594175, JInt, required = false, default = nil)
  if valid_594175 != nil:
    section.add "pageSize", valid_594175
  var valid_594176 = query.getOrDefault("prettyPrint")
  valid_594176 = validateParameter(valid_594176, JBool, required = false,
                                 default = newJBool(true))
  if valid_594176 != nil:
    section.add "prettyPrint", valid_594176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594177: Call_SpannerProjectsInstancesDatabasesList_594160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Cloud Spanner databases.
  ## 
  let valid = call_594177.validator(path, query, header, formData, body)
  let scheme = call_594177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594177.url(scheme.get, call_594177.host, call_594177.base,
                         call_594177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594177, url, valid)

proc call*(call_594178: Call_SpannerProjectsInstancesDatabasesList_594160;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesList
  ## Lists Cloud Spanner databases.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The instance whose databases should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594179 = newJObject()
  var query_594180 = newJObject()
  add(query_594180, "upload_protocol", newJString(uploadProtocol))
  add(query_594180, "fields", newJString(fields))
  add(query_594180, "pageToken", newJString(pageToken))
  add(query_594180, "quotaUser", newJString(quotaUser))
  add(query_594180, "alt", newJString(alt))
  add(query_594180, "oauth_token", newJString(oauthToken))
  add(query_594180, "callback", newJString(callback))
  add(query_594180, "access_token", newJString(accessToken))
  add(query_594180, "uploadType", newJString(uploadType))
  add(path_594179, "parent", newJString(parent))
  add(query_594180, "key", newJString(key))
  add(query_594180, "$.xgafv", newJString(Xgafv))
  add(query_594180, "pageSize", newJInt(pageSize))
  add(query_594180, "prettyPrint", newJBool(prettyPrint))
  result = call_594178.call(path_594179, query_594180, nil, nil, nil)

var spannerProjectsInstancesDatabasesList* = Call_SpannerProjectsInstancesDatabasesList_594160(
    name: "spannerProjectsInstancesDatabasesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesList_594161, base: "/",
    url: url_SpannerProjectsInstancesDatabasesList_594162, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsList_594202 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstanceConfigsList_594204(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instanceConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstanceConfigsList_594203(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists the supported instance configurations for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project for which a list of supported instance
  ## configurations is requested. Values are of the form
  ## `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594205 = path.getOrDefault("parent")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "parent", valid_594205
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594206 = query.getOrDefault("upload_protocol")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "upload_protocol", valid_594206
  var valid_594207 = query.getOrDefault("fields")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "fields", valid_594207
  var valid_594208 = query.getOrDefault("pageToken")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = nil)
  if valid_594208 != nil:
    section.add "pageToken", valid_594208
  var valid_594209 = query.getOrDefault("quotaUser")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "quotaUser", valid_594209
  var valid_594210 = query.getOrDefault("alt")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = newJString("json"))
  if valid_594210 != nil:
    section.add "alt", valid_594210
  var valid_594211 = query.getOrDefault("oauth_token")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "oauth_token", valid_594211
  var valid_594212 = query.getOrDefault("callback")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "callback", valid_594212
  var valid_594213 = query.getOrDefault("access_token")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "access_token", valid_594213
  var valid_594214 = query.getOrDefault("uploadType")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "uploadType", valid_594214
  var valid_594215 = query.getOrDefault("key")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "key", valid_594215
  var valid_594216 = query.getOrDefault("$.xgafv")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = newJString("1"))
  if valid_594216 != nil:
    section.add "$.xgafv", valid_594216
  var valid_594217 = query.getOrDefault("pageSize")
  valid_594217 = validateParameter(valid_594217, JInt, required = false, default = nil)
  if valid_594217 != nil:
    section.add "pageSize", valid_594217
  var valid_594218 = query.getOrDefault("prettyPrint")
  valid_594218 = validateParameter(valid_594218, JBool, required = false,
                                 default = newJBool(true))
  if valid_594218 != nil:
    section.add "prettyPrint", valid_594218
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594219: Call_SpannerProjectsInstanceConfigsList_594202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the supported instance configurations for a given project.
  ## 
  let valid = call_594219.validator(path, query, header, formData, body)
  let scheme = call_594219.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594219.url(scheme.get, call_594219.host, call_594219.base,
                         call_594219.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594219, url, valid)

proc call*(call_594220: Call_SpannerProjectsInstanceConfigsList_594202;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstanceConfigsList
  ## Lists the supported instance configurations for a given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of supported instance
  ## configurations is requested. Values are of the form
  ## `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594221 = newJObject()
  var query_594222 = newJObject()
  add(query_594222, "upload_protocol", newJString(uploadProtocol))
  add(query_594222, "fields", newJString(fields))
  add(query_594222, "pageToken", newJString(pageToken))
  add(query_594222, "quotaUser", newJString(quotaUser))
  add(query_594222, "alt", newJString(alt))
  add(query_594222, "oauth_token", newJString(oauthToken))
  add(query_594222, "callback", newJString(callback))
  add(query_594222, "access_token", newJString(accessToken))
  add(query_594222, "uploadType", newJString(uploadType))
  add(path_594221, "parent", newJString(parent))
  add(query_594222, "key", newJString(key))
  add(query_594222, "$.xgafv", newJString(Xgafv))
  add(query_594222, "pageSize", newJInt(pageSize))
  add(query_594222, "prettyPrint", newJBool(prettyPrint))
  result = call_594220.call(path_594221, query_594222, nil, nil, nil)

var spannerProjectsInstanceConfigsList* = Call_SpannerProjectsInstanceConfigsList_594202(
    name: "spannerProjectsInstanceConfigsList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instanceConfigs",
    validator: validate_SpannerProjectsInstanceConfigsList_594203, base: "/",
    url: url_SpannerProjectsInstanceConfigsList_594204, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesCreate_594245 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesCreate_594247(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesCreate_594246(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates an instance and begins preparing it to begin serving. The
  ## returned long-running operation
  ## can be used to track the progress of preparing the new
  ## instance. The instance name is assigned by the caller. If the
  ## named instance already exists, `CreateInstance` returns
  ## `ALREADY_EXISTS`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * The instance is readable via the API, with all requested attributes
  ##     but no allocated resources. Its state is `CREATING`.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation renders the instance immediately unreadable
  ##     via the API.
  ##   * The instance can be deleted.
  ##   * All other attempts to modify the instance are rejected.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing for all successfully-allocated resources begins (some types
  ##     may have lower than the requested levels).
  ##   * Databases can be created in the instance.
  ##   * The instance's allocated resource levels are readable via the API.
  ##   * The instance's state becomes `READY`.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track creation of the instance.  The
  ## metadata field type is
  ## CreateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project in which to create the instance. Values
  ## are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594248 = path.getOrDefault("parent")
  valid_594248 = validateParameter(valid_594248, JString, required = true,
                                 default = nil)
  if valid_594248 != nil:
    section.add "parent", valid_594248
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594249 = query.getOrDefault("upload_protocol")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "upload_protocol", valid_594249
  var valid_594250 = query.getOrDefault("fields")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "fields", valid_594250
  var valid_594251 = query.getOrDefault("quotaUser")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "quotaUser", valid_594251
  var valid_594252 = query.getOrDefault("alt")
  valid_594252 = validateParameter(valid_594252, JString, required = false,
                                 default = newJString("json"))
  if valid_594252 != nil:
    section.add "alt", valid_594252
  var valid_594253 = query.getOrDefault("oauth_token")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "oauth_token", valid_594253
  var valid_594254 = query.getOrDefault("callback")
  valid_594254 = validateParameter(valid_594254, JString, required = false,
                                 default = nil)
  if valid_594254 != nil:
    section.add "callback", valid_594254
  var valid_594255 = query.getOrDefault("access_token")
  valid_594255 = validateParameter(valid_594255, JString, required = false,
                                 default = nil)
  if valid_594255 != nil:
    section.add "access_token", valid_594255
  var valid_594256 = query.getOrDefault("uploadType")
  valid_594256 = validateParameter(valid_594256, JString, required = false,
                                 default = nil)
  if valid_594256 != nil:
    section.add "uploadType", valid_594256
  var valid_594257 = query.getOrDefault("key")
  valid_594257 = validateParameter(valid_594257, JString, required = false,
                                 default = nil)
  if valid_594257 != nil:
    section.add "key", valid_594257
  var valid_594258 = query.getOrDefault("$.xgafv")
  valid_594258 = validateParameter(valid_594258, JString, required = false,
                                 default = newJString("1"))
  if valid_594258 != nil:
    section.add "$.xgafv", valid_594258
  var valid_594259 = query.getOrDefault("prettyPrint")
  valid_594259 = validateParameter(valid_594259, JBool, required = false,
                                 default = newJBool(true))
  if valid_594259 != nil:
    section.add "prettyPrint", valid_594259
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594261: Call_SpannerProjectsInstancesCreate_594245; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates an instance and begins preparing it to begin serving. The
  ## returned long-running operation
  ## can be used to track the progress of preparing the new
  ## instance. The instance name is assigned by the caller. If the
  ## named instance already exists, `CreateInstance` returns
  ## `ALREADY_EXISTS`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * The instance is readable via the API, with all requested attributes
  ##     but no allocated resources. Its state is `CREATING`.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation renders the instance immediately unreadable
  ##     via the API.
  ##   * The instance can be deleted.
  ##   * All other attempts to modify the instance are rejected.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing for all successfully-allocated resources begins (some types
  ##     may have lower than the requested levels).
  ##   * Databases can be created in the instance.
  ##   * The instance's allocated resource levels are readable via the API.
  ##   * The instance's state becomes `READY`.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track creation of the instance.  The
  ## metadata field type is
  ## CreateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ## 
  let valid = call_594261.validator(path, query, header, formData, body)
  let scheme = call_594261.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594261.url(scheme.get, call_594261.host, call_594261.base,
                         call_594261.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594261, url, valid)

proc call*(call_594262: Call_SpannerProjectsInstancesCreate_594245; parent: string;
          uploadProtocol: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; callback: string = "";
          accessToken: string = ""; uploadType: string = ""; key: string = "";
          Xgafv: string = "1"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesCreate
  ## Creates an instance and begins preparing it to begin serving. The
  ## returned long-running operation
  ## can be used to track the progress of preparing the new
  ## instance. The instance name is assigned by the caller. If the
  ## named instance already exists, `CreateInstance` returns
  ## `ALREADY_EXISTS`.
  ## 
  ## Immediately upon completion of this request:
  ## 
  ##   * The instance is readable via the API, with all requested attributes
  ##     but no allocated resources. Its state is `CREATING`.
  ## 
  ## Until completion of the returned operation:
  ## 
  ##   * Cancelling the operation renders the instance immediately unreadable
  ##     via the API.
  ##   * The instance can be deleted.
  ##   * All other attempts to modify the instance are rejected.
  ## 
  ## Upon completion of the returned operation:
  ## 
  ##   * Billing for all successfully-allocated resources begins (some types
  ##     may have lower than the requested levels).
  ##   * Databases can be created in the instance.
  ##   * The instance's allocated resource levels are readable via the API.
  ##   * The instance's state becomes `READY`.
  ## 
  ## The returned long-running operation will
  ## have a name of the format `<instance_name>/operations/<operation_id>` and
  ## can be used to track creation of the instance.  The
  ## metadata field type is
  ## CreateInstanceMetadata.
  ## The response field type is
  ## Instance, if successful.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the project in which to create the instance. Values
  ## are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594263 = newJObject()
  var query_594264 = newJObject()
  var body_594265 = newJObject()
  add(query_594264, "upload_protocol", newJString(uploadProtocol))
  add(query_594264, "fields", newJString(fields))
  add(query_594264, "quotaUser", newJString(quotaUser))
  add(query_594264, "alt", newJString(alt))
  add(query_594264, "oauth_token", newJString(oauthToken))
  add(query_594264, "callback", newJString(callback))
  add(query_594264, "access_token", newJString(accessToken))
  add(query_594264, "uploadType", newJString(uploadType))
  add(path_594263, "parent", newJString(parent))
  add(query_594264, "key", newJString(key))
  add(query_594264, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594265 = body
  add(query_594264, "prettyPrint", newJBool(prettyPrint))
  result = call_594262.call(path_594263, query_594264, nil, nil, body_594265)

var spannerProjectsInstancesCreate* = Call_SpannerProjectsInstancesCreate_594245(
    name: "spannerProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesCreate_594246, base: "/",
    url: url_SpannerProjectsInstancesCreate_594247, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesList_594223 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesList_594225(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesList_594224(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all instances in the given project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The name of the project for which a list of instances is
  ## requested. Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_594226 = path.getOrDefault("parent")
  valid_594226 = validateParameter(valid_594226, JString, required = true,
                                 default = nil)
  if valid_594226 != nil:
    section.add "parent", valid_594226
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `name`
  ##   * `display_name`
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `name:*` --> The instance has a name.
  ##   * `name:Howl` --> The instance's name contains the string "howl".
  ##   * `name:HOWL` --> Equivalent to above.
  ##   * `NAME:howl` --> Equivalent to above.
  ##   * `labels.env:*` --> The instance has the label "env".
  ##   * `labels.env:dev` --> The instance has the label "env" and the value of
  ##                        the label contains the string "dev".
  ##   * `name:howl labels.env:dev` --> The instance's name contains "howl" and
  ##                                  it has the label "env" with its value
  ##                                  containing "dev".
  section = newJObject()
  var valid_594227 = query.getOrDefault("upload_protocol")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = nil)
  if valid_594227 != nil:
    section.add "upload_protocol", valid_594227
  var valid_594228 = query.getOrDefault("fields")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "fields", valid_594228
  var valid_594229 = query.getOrDefault("pageToken")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "pageToken", valid_594229
  var valid_594230 = query.getOrDefault("quotaUser")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "quotaUser", valid_594230
  var valid_594231 = query.getOrDefault("alt")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = newJString("json"))
  if valid_594231 != nil:
    section.add "alt", valid_594231
  var valid_594232 = query.getOrDefault("oauth_token")
  valid_594232 = validateParameter(valid_594232, JString, required = false,
                                 default = nil)
  if valid_594232 != nil:
    section.add "oauth_token", valid_594232
  var valid_594233 = query.getOrDefault("callback")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "callback", valid_594233
  var valid_594234 = query.getOrDefault("access_token")
  valid_594234 = validateParameter(valid_594234, JString, required = false,
                                 default = nil)
  if valid_594234 != nil:
    section.add "access_token", valid_594234
  var valid_594235 = query.getOrDefault("uploadType")
  valid_594235 = validateParameter(valid_594235, JString, required = false,
                                 default = nil)
  if valid_594235 != nil:
    section.add "uploadType", valid_594235
  var valid_594236 = query.getOrDefault("key")
  valid_594236 = validateParameter(valid_594236, JString, required = false,
                                 default = nil)
  if valid_594236 != nil:
    section.add "key", valid_594236
  var valid_594237 = query.getOrDefault("$.xgafv")
  valid_594237 = validateParameter(valid_594237, JString, required = false,
                                 default = newJString("1"))
  if valid_594237 != nil:
    section.add "$.xgafv", valid_594237
  var valid_594238 = query.getOrDefault("pageSize")
  valid_594238 = validateParameter(valid_594238, JInt, required = false, default = nil)
  if valid_594238 != nil:
    section.add "pageSize", valid_594238
  var valid_594239 = query.getOrDefault("prettyPrint")
  valid_594239 = validateParameter(valid_594239, JBool, required = false,
                                 default = newJBool(true))
  if valid_594239 != nil:
    section.add "prettyPrint", valid_594239
  var valid_594240 = query.getOrDefault("filter")
  valid_594240 = validateParameter(valid_594240, JString, required = false,
                                 default = nil)
  if valid_594240 != nil:
    section.add "filter", valid_594240
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594241: Call_SpannerProjectsInstancesList_594223; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instances in the given project.
  ## 
  let valid = call_594241.validator(path, query, header, formData, body)
  let scheme = call_594241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594241.url(scheme.get, call_594241.host, call_594241.base,
                         call_594241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594241, url, valid)

proc call*(call_594242: Call_SpannerProjectsInstancesList_594223; parent: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## spannerProjectsInstancesList
  ## Lists all instances in the given project.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of instances is
  ## requested. Values are of the form `projects/<project>`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : An expression for filtering the results of the request. Filter rules are
  ## case insensitive. The fields eligible for filtering are:
  ## 
  ##   * `name`
  ##   * `display_name`
  ##   * `labels.key` where key is the name of a label
  ## 
  ## Some examples of using filters are:
  ## 
  ##   * `name:*` --> The instance has a name.
  ##   * `name:Howl` --> The instance's name contains the string "howl".
  ##   * `name:HOWL` --> Equivalent to above.
  ##   * `NAME:howl` --> Equivalent to above.
  ##   * `labels.env:*` --> The instance has the label "env".
  ##   * `labels.env:dev` --> The instance has the label "env" and the value of
  ##                        the label contains the string "dev".
  ##   * `name:howl labels.env:dev` --> The instance's name contains "howl" and
  ##                                  it has the label "env" with its value
  ##                                  containing "dev".
  var path_594243 = newJObject()
  var query_594244 = newJObject()
  add(query_594244, "upload_protocol", newJString(uploadProtocol))
  add(query_594244, "fields", newJString(fields))
  add(query_594244, "pageToken", newJString(pageToken))
  add(query_594244, "quotaUser", newJString(quotaUser))
  add(query_594244, "alt", newJString(alt))
  add(query_594244, "oauth_token", newJString(oauthToken))
  add(query_594244, "callback", newJString(callback))
  add(query_594244, "access_token", newJString(accessToken))
  add(query_594244, "uploadType", newJString(uploadType))
  add(path_594243, "parent", newJString(parent))
  add(query_594244, "key", newJString(key))
  add(query_594244, "$.xgafv", newJString(Xgafv))
  add(query_594244, "pageSize", newJInt(pageSize))
  add(query_594244, "prettyPrint", newJBool(prettyPrint))
  add(query_594244, "filter", newJString(filter))
  result = call_594242.call(path_594243, query_594244, nil, nil, nil)

var spannerProjectsInstancesList* = Call_SpannerProjectsInstancesList_594223(
    name: "spannerProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesList_594224, base: "/",
    url: url_SpannerProjectsInstancesList_594225, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetIamPolicy_594266 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesGetIamPolicy_594268(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesGetIamPolicy_594267(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being retrieved. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594269 = path.getOrDefault("resource")
  valid_594269 = validateParameter(valid_594269, JString, required = true,
                                 default = nil)
  if valid_594269 != nil:
    section.add "resource", valid_594269
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594270 = query.getOrDefault("upload_protocol")
  valid_594270 = validateParameter(valid_594270, JString, required = false,
                                 default = nil)
  if valid_594270 != nil:
    section.add "upload_protocol", valid_594270
  var valid_594271 = query.getOrDefault("fields")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "fields", valid_594271
  var valid_594272 = query.getOrDefault("quotaUser")
  valid_594272 = validateParameter(valid_594272, JString, required = false,
                                 default = nil)
  if valid_594272 != nil:
    section.add "quotaUser", valid_594272
  var valid_594273 = query.getOrDefault("alt")
  valid_594273 = validateParameter(valid_594273, JString, required = false,
                                 default = newJString("json"))
  if valid_594273 != nil:
    section.add "alt", valid_594273
  var valid_594274 = query.getOrDefault("oauth_token")
  valid_594274 = validateParameter(valid_594274, JString, required = false,
                                 default = nil)
  if valid_594274 != nil:
    section.add "oauth_token", valid_594274
  var valid_594275 = query.getOrDefault("callback")
  valid_594275 = validateParameter(valid_594275, JString, required = false,
                                 default = nil)
  if valid_594275 != nil:
    section.add "callback", valid_594275
  var valid_594276 = query.getOrDefault("access_token")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "access_token", valid_594276
  var valid_594277 = query.getOrDefault("uploadType")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "uploadType", valid_594277
  var valid_594278 = query.getOrDefault("key")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "key", valid_594278
  var valid_594279 = query.getOrDefault("$.xgafv")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = newJString("1"))
  if valid_594279 != nil:
    section.add "$.xgafv", valid_594279
  var valid_594280 = query.getOrDefault("prettyPrint")
  valid_594280 = validateParameter(valid_594280, JBool, required = false,
                                 default = newJBool(true))
  if valid_594280 != nil:
    section.add "prettyPrint", valid_594280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594282: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_594266;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ## 
  let valid = call_594282.validator(path, query, header, formData, body)
  let scheme = call_594282.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594282.url(scheme.get, call_594282.host, call_594282.base,
                         call_594282.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594282, url, valid)

proc call*(call_594283: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_594266;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesGetIamPolicy
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being retrieved. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594284 = newJObject()
  var query_594285 = newJObject()
  var body_594286 = newJObject()
  add(query_594285, "upload_protocol", newJString(uploadProtocol))
  add(query_594285, "fields", newJString(fields))
  add(query_594285, "quotaUser", newJString(quotaUser))
  add(query_594285, "alt", newJString(alt))
  add(query_594285, "oauth_token", newJString(oauthToken))
  add(query_594285, "callback", newJString(callback))
  add(query_594285, "access_token", newJString(accessToken))
  add(query_594285, "uploadType", newJString(uploadType))
  add(query_594285, "key", newJString(key))
  add(query_594285, "$.xgafv", newJString(Xgafv))
  add(path_594284, "resource", newJString(resource))
  if body != nil:
    body_594286 = body
  add(query_594285, "prettyPrint", newJBool(prettyPrint))
  result = call_594283.call(path_594284, query_594285, nil, nil, body_594286)

var spannerProjectsInstancesDatabasesGetIamPolicy* = Call_SpannerProjectsInstancesDatabasesGetIamPolicy_594266(
    name: "spannerProjectsInstancesDatabasesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesGetIamPolicy_594267,
    base: "/", url: url_SpannerProjectsInstancesDatabasesGetIamPolicy_594268,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSetIamPolicy_594287 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSetIamPolicy_594289(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSetIamPolicy_594288(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being set. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for databases resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594290 = path.getOrDefault("resource")
  valid_594290 = validateParameter(valid_594290, JString, required = true,
                                 default = nil)
  if valid_594290 != nil:
    section.add "resource", valid_594290
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594291 = query.getOrDefault("upload_protocol")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "upload_protocol", valid_594291
  var valid_594292 = query.getOrDefault("fields")
  valid_594292 = validateParameter(valid_594292, JString, required = false,
                                 default = nil)
  if valid_594292 != nil:
    section.add "fields", valid_594292
  var valid_594293 = query.getOrDefault("quotaUser")
  valid_594293 = validateParameter(valid_594293, JString, required = false,
                                 default = nil)
  if valid_594293 != nil:
    section.add "quotaUser", valid_594293
  var valid_594294 = query.getOrDefault("alt")
  valid_594294 = validateParameter(valid_594294, JString, required = false,
                                 default = newJString("json"))
  if valid_594294 != nil:
    section.add "alt", valid_594294
  var valid_594295 = query.getOrDefault("oauth_token")
  valid_594295 = validateParameter(valid_594295, JString, required = false,
                                 default = nil)
  if valid_594295 != nil:
    section.add "oauth_token", valid_594295
  var valid_594296 = query.getOrDefault("callback")
  valid_594296 = validateParameter(valid_594296, JString, required = false,
                                 default = nil)
  if valid_594296 != nil:
    section.add "callback", valid_594296
  var valid_594297 = query.getOrDefault("access_token")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "access_token", valid_594297
  var valid_594298 = query.getOrDefault("uploadType")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "uploadType", valid_594298
  var valid_594299 = query.getOrDefault("key")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "key", valid_594299
  var valid_594300 = query.getOrDefault("$.xgafv")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = newJString("1"))
  if valid_594300 != nil:
    section.add "$.xgafv", valid_594300
  var valid_594301 = query.getOrDefault("prettyPrint")
  valid_594301 = validateParameter(valid_594301, JBool, required = false,
                                 default = newJBool(true))
  if valid_594301 != nil:
    section.add "prettyPrint", valid_594301
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594303: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_594287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ## 
  let valid = call_594303.validator(path, query, header, formData, body)
  let scheme = call_594303.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594303.url(scheme.get, call_594303.host, call_594303.base,
                         call_594303.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594303, url, valid)

proc call*(call_594304: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_594287;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSetIamPolicy
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being set. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for databases resources.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594305 = newJObject()
  var query_594306 = newJObject()
  var body_594307 = newJObject()
  add(query_594306, "upload_protocol", newJString(uploadProtocol))
  add(query_594306, "fields", newJString(fields))
  add(query_594306, "quotaUser", newJString(quotaUser))
  add(query_594306, "alt", newJString(alt))
  add(query_594306, "oauth_token", newJString(oauthToken))
  add(query_594306, "callback", newJString(callback))
  add(query_594306, "access_token", newJString(accessToken))
  add(query_594306, "uploadType", newJString(uploadType))
  add(query_594306, "key", newJString(key))
  add(query_594306, "$.xgafv", newJString(Xgafv))
  add(path_594305, "resource", newJString(resource))
  if body != nil:
    body_594307 = body
  add(query_594306, "prettyPrint", newJBool(prettyPrint))
  result = call_594304.call(path_594305, query_594306, nil, nil, body_594307)

var spannerProjectsInstancesDatabasesSetIamPolicy* = Call_SpannerProjectsInstancesDatabasesSetIamPolicy_594287(
    name: "spannerProjectsInstancesDatabasesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesSetIamPolicy_594288,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSetIamPolicy_594289,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesTestIamPermissions_594308 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesTestIamPermissions_594310(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesTestIamPermissions_594309(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The Cloud Spanner resource for which permissions are being tested. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_594311 = path.getOrDefault("resource")
  valid_594311 = validateParameter(valid_594311, JString, required = true,
                                 default = nil)
  if valid_594311 != nil:
    section.add "resource", valid_594311
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594312 = query.getOrDefault("upload_protocol")
  valid_594312 = validateParameter(valid_594312, JString, required = false,
                                 default = nil)
  if valid_594312 != nil:
    section.add "upload_protocol", valid_594312
  var valid_594313 = query.getOrDefault("fields")
  valid_594313 = validateParameter(valid_594313, JString, required = false,
                                 default = nil)
  if valid_594313 != nil:
    section.add "fields", valid_594313
  var valid_594314 = query.getOrDefault("quotaUser")
  valid_594314 = validateParameter(valid_594314, JString, required = false,
                                 default = nil)
  if valid_594314 != nil:
    section.add "quotaUser", valid_594314
  var valid_594315 = query.getOrDefault("alt")
  valid_594315 = validateParameter(valid_594315, JString, required = false,
                                 default = newJString("json"))
  if valid_594315 != nil:
    section.add "alt", valid_594315
  var valid_594316 = query.getOrDefault("oauth_token")
  valid_594316 = validateParameter(valid_594316, JString, required = false,
                                 default = nil)
  if valid_594316 != nil:
    section.add "oauth_token", valid_594316
  var valid_594317 = query.getOrDefault("callback")
  valid_594317 = validateParameter(valid_594317, JString, required = false,
                                 default = nil)
  if valid_594317 != nil:
    section.add "callback", valid_594317
  var valid_594318 = query.getOrDefault("access_token")
  valid_594318 = validateParameter(valid_594318, JString, required = false,
                                 default = nil)
  if valid_594318 != nil:
    section.add "access_token", valid_594318
  var valid_594319 = query.getOrDefault("uploadType")
  valid_594319 = validateParameter(valid_594319, JString, required = false,
                                 default = nil)
  if valid_594319 != nil:
    section.add "uploadType", valid_594319
  var valid_594320 = query.getOrDefault("key")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "key", valid_594320
  var valid_594321 = query.getOrDefault("$.xgafv")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = newJString("1"))
  if valid_594321 != nil:
    section.add "$.xgafv", valid_594321
  var valid_594322 = query.getOrDefault("prettyPrint")
  valid_594322 = validateParameter(valid_594322, JBool, required = false,
                                 default = newJBool(true))
  if valid_594322 != nil:
    section.add "prettyPrint", valid_594322
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594324: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_594308;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ## 
  let valid = call_594324.validator(path, query, header, formData, body)
  let scheme = call_594324.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594324.url(scheme.get, call_594324.host, call_594324.base,
                         call_594324.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594324, url, valid)

proc call*(call_594325: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_594308;
          resource: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesTestIamPermissions
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which permissions are being tested. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594326 = newJObject()
  var query_594327 = newJObject()
  var body_594328 = newJObject()
  add(query_594327, "upload_protocol", newJString(uploadProtocol))
  add(query_594327, "fields", newJString(fields))
  add(query_594327, "quotaUser", newJString(quotaUser))
  add(query_594327, "alt", newJString(alt))
  add(query_594327, "oauth_token", newJString(oauthToken))
  add(query_594327, "callback", newJString(callback))
  add(query_594327, "access_token", newJString(accessToken))
  add(query_594327, "uploadType", newJString(uploadType))
  add(query_594327, "key", newJString(key))
  add(query_594327, "$.xgafv", newJString(Xgafv))
  add(path_594326, "resource", newJString(resource))
  if body != nil:
    body_594328 = body
  add(query_594327, "prettyPrint", newJBool(prettyPrint))
  result = call_594325.call(path_594326, query_594327, nil, nil, body_594328)

var spannerProjectsInstancesDatabasesTestIamPermissions* = Call_SpannerProjectsInstancesDatabasesTestIamPermissions_594308(
    name: "spannerProjectsInstancesDatabasesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SpannerProjectsInstancesDatabasesTestIamPermissions_594309,
    base: "/", url: url_SpannerProjectsInstancesDatabasesTestIamPermissions_594310,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594329 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594331(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":beginTransaction")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594330(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the transaction runs.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594332 = path.getOrDefault("session")
  valid_594332 = validateParameter(valid_594332, JString, required = true,
                                 default = nil)
  if valid_594332 != nil:
    section.add "session", valid_594332
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594333 = query.getOrDefault("upload_protocol")
  valid_594333 = validateParameter(valid_594333, JString, required = false,
                                 default = nil)
  if valid_594333 != nil:
    section.add "upload_protocol", valid_594333
  var valid_594334 = query.getOrDefault("fields")
  valid_594334 = validateParameter(valid_594334, JString, required = false,
                                 default = nil)
  if valid_594334 != nil:
    section.add "fields", valid_594334
  var valid_594335 = query.getOrDefault("quotaUser")
  valid_594335 = validateParameter(valid_594335, JString, required = false,
                                 default = nil)
  if valid_594335 != nil:
    section.add "quotaUser", valid_594335
  var valid_594336 = query.getOrDefault("alt")
  valid_594336 = validateParameter(valid_594336, JString, required = false,
                                 default = newJString("json"))
  if valid_594336 != nil:
    section.add "alt", valid_594336
  var valid_594337 = query.getOrDefault("oauth_token")
  valid_594337 = validateParameter(valid_594337, JString, required = false,
                                 default = nil)
  if valid_594337 != nil:
    section.add "oauth_token", valid_594337
  var valid_594338 = query.getOrDefault("callback")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "callback", valid_594338
  var valid_594339 = query.getOrDefault("access_token")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "access_token", valid_594339
  var valid_594340 = query.getOrDefault("uploadType")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = nil)
  if valid_594340 != nil:
    section.add "uploadType", valid_594340
  var valid_594341 = query.getOrDefault("key")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "key", valid_594341
  var valid_594342 = query.getOrDefault("$.xgafv")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = newJString("1"))
  if valid_594342 != nil:
    section.add "$.xgafv", valid_594342
  var valid_594343 = query.getOrDefault("prettyPrint")
  valid_594343 = validateParameter(valid_594343, JBool, required = false,
                                 default = newJBool(true))
  if valid_594343 != nil:
    section.add "prettyPrint", valid_594343
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594345: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ## 
  let valid = call_594345.validator(path, query, header, formData, body)
  let scheme = call_594345.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594345.url(scheme.get, call_594345.host, call_594345.base,
                         call_594345.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594345, url, valid)

proc call*(call_594346: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594329;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBeginTransaction
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the transaction runs.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594347 = newJObject()
  var query_594348 = newJObject()
  var body_594349 = newJObject()
  add(query_594348, "upload_protocol", newJString(uploadProtocol))
  add(path_594347, "session", newJString(session))
  add(query_594348, "fields", newJString(fields))
  add(query_594348, "quotaUser", newJString(quotaUser))
  add(query_594348, "alt", newJString(alt))
  add(query_594348, "oauth_token", newJString(oauthToken))
  add(query_594348, "callback", newJString(callback))
  add(query_594348, "access_token", newJString(accessToken))
  add(query_594348, "uploadType", newJString(uploadType))
  add(query_594348, "key", newJString(key))
  add(query_594348, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594349 = body
  add(query_594348, "prettyPrint", newJBool(prettyPrint))
  result = call_594346.call(path_594347, query_594348, nil, nil, body_594349)

var spannerProjectsInstancesDatabasesSessionsBeginTransaction* = Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594329(
    name: "spannerProjectsInstancesDatabasesSessionsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:beginTransaction", validator: validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594330,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_594331,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCommit_594350 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsCommit_594352(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":commit")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsCommit_594351(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the transaction to be committed is running.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594353 = path.getOrDefault("session")
  valid_594353 = validateParameter(valid_594353, JString, required = true,
                                 default = nil)
  if valid_594353 != nil:
    section.add "session", valid_594353
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594354 = query.getOrDefault("upload_protocol")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "upload_protocol", valid_594354
  var valid_594355 = query.getOrDefault("fields")
  valid_594355 = validateParameter(valid_594355, JString, required = false,
                                 default = nil)
  if valid_594355 != nil:
    section.add "fields", valid_594355
  var valid_594356 = query.getOrDefault("quotaUser")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "quotaUser", valid_594356
  var valid_594357 = query.getOrDefault("alt")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = newJString("json"))
  if valid_594357 != nil:
    section.add "alt", valid_594357
  var valid_594358 = query.getOrDefault("oauth_token")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "oauth_token", valid_594358
  var valid_594359 = query.getOrDefault("callback")
  valid_594359 = validateParameter(valid_594359, JString, required = false,
                                 default = nil)
  if valid_594359 != nil:
    section.add "callback", valid_594359
  var valid_594360 = query.getOrDefault("access_token")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = nil)
  if valid_594360 != nil:
    section.add "access_token", valid_594360
  var valid_594361 = query.getOrDefault("uploadType")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "uploadType", valid_594361
  var valid_594362 = query.getOrDefault("key")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "key", valid_594362
  var valid_594363 = query.getOrDefault("$.xgafv")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = newJString("1"))
  if valid_594363 != nil:
    section.add "$.xgafv", valid_594363
  var valid_594364 = query.getOrDefault("prettyPrint")
  valid_594364 = validateParameter(valid_594364, JBool, required = false,
                                 default = newJBool(true))
  if valid_594364 != nil:
    section.add "prettyPrint", valid_594364
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594366: Call_SpannerProjectsInstancesDatabasesSessionsCommit_594350;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
  ## 
  let valid = call_594366.validator(path, query, header, formData, body)
  let scheme = call_594366.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594366.url(scheme.get, call_594366.host, call_594366.base,
                         call_594366.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594366, url, valid)

proc call*(call_594367: Call_SpannerProjectsInstancesDatabasesSessionsCommit_594350;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsCommit
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the transaction to be committed is running.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594368 = newJObject()
  var query_594369 = newJObject()
  var body_594370 = newJObject()
  add(query_594369, "upload_protocol", newJString(uploadProtocol))
  add(path_594368, "session", newJString(session))
  add(query_594369, "fields", newJString(fields))
  add(query_594369, "quotaUser", newJString(quotaUser))
  add(query_594369, "alt", newJString(alt))
  add(query_594369, "oauth_token", newJString(oauthToken))
  add(query_594369, "callback", newJString(callback))
  add(query_594369, "access_token", newJString(accessToken))
  add(query_594369, "uploadType", newJString(uploadType))
  add(query_594369, "key", newJString(key))
  add(query_594369, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594370 = body
  add(query_594369, "prettyPrint", newJBool(prettyPrint))
  result = call_594367.call(path_594368, query_594369, nil, nil, body_594370)

var spannerProjectsInstancesDatabasesSessionsCommit* = Call_SpannerProjectsInstancesDatabasesSessionsCommit_594350(
    name: "spannerProjectsInstancesDatabasesSessionsCommit",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:commit",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCommit_594351,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCommit_594352,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594371 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594373(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":executeBatchDml")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594372(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Executes a batch of SQL DML statements. This method allows many statements
  ## to be run with lower latency than submitting them sequentially with
  ## ExecuteSql.
  ## 
  ## Statements are executed in sequential order. A request can succeed even if
  ## a statement fails. The ExecuteBatchDmlResponse.status field in the
  ## response provides information about the statement that failed. Clients must
  ## inspect this field to determine whether an error occurred.
  ## 
  ## Execution stops after the first failed statement; the remaining statements
  ## are not executed.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the DML statements should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594374 = path.getOrDefault("session")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "session", valid_594374
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594375 = query.getOrDefault("upload_protocol")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "upload_protocol", valid_594375
  var valid_594376 = query.getOrDefault("fields")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "fields", valid_594376
  var valid_594377 = query.getOrDefault("quotaUser")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = nil)
  if valid_594377 != nil:
    section.add "quotaUser", valid_594377
  var valid_594378 = query.getOrDefault("alt")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = newJString("json"))
  if valid_594378 != nil:
    section.add "alt", valid_594378
  var valid_594379 = query.getOrDefault("oauth_token")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "oauth_token", valid_594379
  var valid_594380 = query.getOrDefault("callback")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "callback", valid_594380
  var valid_594381 = query.getOrDefault("access_token")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "access_token", valid_594381
  var valid_594382 = query.getOrDefault("uploadType")
  valid_594382 = validateParameter(valid_594382, JString, required = false,
                                 default = nil)
  if valid_594382 != nil:
    section.add "uploadType", valid_594382
  var valid_594383 = query.getOrDefault("key")
  valid_594383 = validateParameter(valid_594383, JString, required = false,
                                 default = nil)
  if valid_594383 != nil:
    section.add "key", valid_594383
  var valid_594384 = query.getOrDefault("$.xgafv")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = newJString("1"))
  if valid_594384 != nil:
    section.add "$.xgafv", valid_594384
  var valid_594385 = query.getOrDefault("prettyPrint")
  valid_594385 = validateParameter(valid_594385, JBool, required = false,
                                 default = newJBool(true))
  if valid_594385 != nil:
    section.add "prettyPrint", valid_594385
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594387: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes a batch of SQL DML statements. This method allows many statements
  ## to be run with lower latency than submitting them sequentially with
  ## ExecuteSql.
  ## 
  ## Statements are executed in sequential order. A request can succeed even if
  ## a statement fails. The ExecuteBatchDmlResponse.status field in the
  ## response provides information about the statement that failed. Clients must
  ## inspect this field to determine whether an error occurred.
  ## 
  ## Execution stops after the first failed statement; the remaining statements
  ## are not executed.
  ## 
  let valid = call_594387.validator(path, query, header, formData, body)
  let scheme = call_594387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594387.url(scheme.get, call_594387.host, call_594387.base,
                         call_594387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594387, url, valid)

proc call*(call_594388: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594371;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteBatchDml
  ## Executes a batch of SQL DML statements. This method allows many statements
  ## to be run with lower latency than submitting them sequentially with
  ## ExecuteSql.
  ## 
  ## Statements are executed in sequential order. A request can succeed even if
  ## a statement fails. The ExecuteBatchDmlResponse.status field in the
  ## response provides information about the statement that failed. Clients must
  ## inspect this field to determine whether an error occurred.
  ## 
  ## Execution stops after the first failed statement; the remaining statements
  ## are not executed.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the DML statements should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594389 = newJObject()
  var query_594390 = newJObject()
  var body_594391 = newJObject()
  add(query_594390, "upload_protocol", newJString(uploadProtocol))
  add(path_594389, "session", newJString(session))
  add(query_594390, "fields", newJString(fields))
  add(query_594390, "quotaUser", newJString(quotaUser))
  add(query_594390, "alt", newJString(alt))
  add(query_594390, "oauth_token", newJString(oauthToken))
  add(query_594390, "callback", newJString(callback))
  add(query_594390, "access_token", newJString(accessToken))
  add(query_594390, "uploadType", newJString(uploadType))
  add(query_594390, "key", newJString(key))
  add(query_594390, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594391 = body
  add(query_594390, "prettyPrint", newJBool(prettyPrint))
  result = call_594388.call(path_594389, query_594390, nil, nil, body_594391)

var spannerProjectsInstancesDatabasesSessionsExecuteBatchDml* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594371(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteBatchDml",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeBatchDml", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594372,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_594373,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594392 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594394(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":executeSql")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594393(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Executes an SQL statement, returning all results in a single reply. This
  ## method cannot be used to return a result set larger than 10 MiB;
  ## if the query yields more data than that, the query fails with
  ## a `FAILED_PRECONDITION` error.
  ## 
  ## Operations inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be fetched in streaming fashion by calling
  ## ExecuteStreamingSql instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the SQL query should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594395 = path.getOrDefault("session")
  valid_594395 = validateParameter(valid_594395, JString, required = true,
                                 default = nil)
  if valid_594395 != nil:
    section.add "session", valid_594395
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594396 = query.getOrDefault("upload_protocol")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "upload_protocol", valid_594396
  var valid_594397 = query.getOrDefault("fields")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "fields", valid_594397
  var valid_594398 = query.getOrDefault("quotaUser")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "quotaUser", valid_594398
  var valid_594399 = query.getOrDefault("alt")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = newJString("json"))
  if valid_594399 != nil:
    section.add "alt", valid_594399
  var valid_594400 = query.getOrDefault("oauth_token")
  valid_594400 = validateParameter(valid_594400, JString, required = false,
                                 default = nil)
  if valid_594400 != nil:
    section.add "oauth_token", valid_594400
  var valid_594401 = query.getOrDefault("callback")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "callback", valid_594401
  var valid_594402 = query.getOrDefault("access_token")
  valid_594402 = validateParameter(valid_594402, JString, required = false,
                                 default = nil)
  if valid_594402 != nil:
    section.add "access_token", valid_594402
  var valid_594403 = query.getOrDefault("uploadType")
  valid_594403 = validateParameter(valid_594403, JString, required = false,
                                 default = nil)
  if valid_594403 != nil:
    section.add "uploadType", valid_594403
  var valid_594404 = query.getOrDefault("key")
  valid_594404 = validateParameter(valid_594404, JString, required = false,
                                 default = nil)
  if valid_594404 != nil:
    section.add "key", valid_594404
  var valid_594405 = query.getOrDefault("$.xgafv")
  valid_594405 = validateParameter(valid_594405, JString, required = false,
                                 default = newJString("1"))
  if valid_594405 != nil:
    section.add "$.xgafv", valid_594405
  var valid_594406 = query.getOrDefault("prettyPrint")
  valid_594406 = validateParameter(valid_594406, JBool, required = false,
                                 default = newJBool(true))
  if valid_594406 != nil:
    section.add "prettyPrint", valid_594406
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594408: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594392;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Executes an SQL statement, returning all results in a single reply. This
  ## method cannot be used to return a result set larger than 10 MiB;
  ## if the query yields more data than that, the query fails with
  ## a `FAILED_PRECONDITION` error.
  ## 
  ## Operations inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be fetched in streaming fashion by calling
  ## ExecuteStreamingSql instead.
  ## 
  let valid = call_594408.validator(path, query, header, formData, body)
  let scheme = call_594408.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594408.url(scheme.get, call_594408.host, call_594408.base,
                         call_594408.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594408, url, valid)

proc call*(call_594409: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594392;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteSql
  ## Executes an SQL statement, returning all results in a single reply. This
  ## method cannot be used to return a result set larger than 10 MiB;
  ## if the query yields more data than that, the query fails with
  ## a `FAILED_PRECONDITION` error.
  ## 
  ## Operations inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be fetched in streaming fashion by calling
  ## ExecuteStreamingSql instead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594410 = newJObject()
  var query_594411 = newJObject()
  var body_594412 = newJObject()
  add(query_594411, "upload_protocol", newJString(uploadProtocol))
  add(path_594410, "session", newJString(session))
  add(query_594411, "fields", newJString(fields))
  add(query_594411, "quotaUser", newJString(quotaUser))
  add(query_594411, "alt", newJString(alt))
  add(query_594411, "oauth_token", newJString(oauthToken))
  add(query_594411, "callback", newJString(callback))
  add(query_594411, "access_token", newJString(accessToken))
  add(query_594411, "uploadType", newJString(uploadType))
  add(query_594411, "key", newJString(key))
  add(query_594411, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594412 = body
  add(query_594411, "prettyPrint", newJBool(prettyPrint))
  result = call_594409.call(path_594410, query_594411, nil, nil, body_594412)

var spannerProjectsInstancesDatabasesSessionsExecuteSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594392(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeSql",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594393,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_594394,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594413 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594415(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":executeStreamingSql")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594414(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the SQL query should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594416 = path.getOrDefault("session")
  valid_594416 = validateParameter(valid_594416, JString, required = true,
                                 default = nil)
  if valid_594416 != nil:
    section.add "session", valid_594416
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594417 = query.getOrDefault("upload_protocol")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "upload_protocol", valid_594417
  var valid_594418 = query.getOrDefault("fields")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "fields", valid_594418
  var valid_594419 = query.getOrDefault("quotaUser")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = nil)
  if valid_594419 != nil:
    section.add "quotaUser", valid_594419
  var valid_594420 = query.getOrDefault("alt")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = newJString("json"))
  if valid_594420 != nil:
    section.add "alt", valid_594420
  var valid_594421 = query.getOrDefault("oauth_token")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "oauth_token", valid_594421
  var valid_594422 = query.getOrDefault("callback")
  valid_594422 = validateParameter(valid_594422, JString, required = false,
                                 default = nil)
  if valid_594422 != nil:
    section.add "callback", valid_594422
  var valid_594423 = query.getOrDefault("access_token")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "access_token", valid_594423
  var valid_594424 = query.getOrDefault("uploadType")
  valid_594424 = validateParameter(valid_594424, JString, required = false,
                                 default = nil)
  if valid_594424 != nil:
    section.add "uploadType", valid_594424
  var valid_594425 = query.getOrDefault("key")
  valid_594425 = validateParameter(valid_594425, JString, required = false,
                                 default = nil)
  if valid_594425 != nil:
    section.add "key", valid_594425
  var valid_594426 = query.getOrDefault("$.xgafv")
  valid_594426 = validateParameter(valid_594426, JString, required = false,
                                 default = newJString("1"))
  if valid_594426 != nil:
    section.add "$.xgafv", valid_594426
  var valid_594427 = query.getOrDefault("prettyPrint")
  valid_594427 = validateParameter(valid_594427, JBool, required = false,
                                 default = newJBool(true))
  if valid_594427 != nil:
    section.add "prettyPrint", valid_594427
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594429: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594413;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ## 
  let valid = call_594429.validator(path, query, header, formData, body)
  let scheme = call_594429.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594429.url(scheme.get, call_594429.host, call_594429.base,
                         call_594429.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594429, url, valid)

proc call*(call_594430: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594413;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594431 = newJObject()
  var query_594432 = newJObject()
  var body_594433 = newJObject()
  add(query_594432, "upload_protocol", newJString(uploadProtocol))
  add(path_594431, "session", newJString(session))
  add(query_594432, "fields", newJString(fields))
  add(query_594432, "quotaUser", newJString(quotaUser))
  add(query_594432, "alt", newJString(alt))
  add(query_594432, "oauth_token", newJString(oauthToken))
  add(query_594432, "callback", newJString(callback))
  add(query_594432, "access_token", newJString(accessToken))
  add(query_594432, "uploadType", newJString(uploadType))
  add(query_594432, "key", newJString(key))
  add(query_594432, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594433 = body
  add(query_594432, "prettyPrint", newJBool(prettyPrint))
  result = call_594430.call(path_594431, query_594432, nil, nil, body_594433)

var spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594413(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeStreamingSql", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594414,
    base: "/",
    url: url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_594415,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594434 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594436(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":partitionQuery")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594435(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a set of partition tokens that can be used to execute a query
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by ExecuteStreamingSql to specify a subset
  ## of the query result to read.  The same session and read-only transaction
  ## must be used by the PartitionQueryRequest used to create the
  ## partition tokens and the ExecuteSqlRequests that use the partition tokens.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the query, and
  ## the whole operation must be restarted from the beginning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session used to create the partitions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594437 = path.getOrDefault("session")
  valid_594437 = validateParameter(valid_594437, JString, required = true,
                                 default = nil)
  if valid_594437 != nil:
    section.add "session", valid_594437
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594438 = query.getOrDefault("upload_protocol")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "upload_protocol", valid_594438
  var valid_594439 = query.getOrDefault("fields")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "fields", valid_594439
  var valid_594440 = query.getOrDefault("quotaUser")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "quotaUser", valid_594440
  var valid_594441 = query.getOrDefault("alt")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = newJString("json"))
  if valid_594441 != nil:
    section.add "alt", valid_594441
  var valid_594442 = query.getOrDefault("oauth_token")
  valid_594442 = validateParameter(valid_594442, JString, required = false,
                                 default = nil)
  if valid_594442 != nil:
    section.add "oauth_token", valid_594442
  var valid_594443 = query.getOrDefault("callback")
  valid_594443 = validateParameter(valid_594443, JString, required = false,
                                 default = nil)
  if valid_594443 != nil:
    section.add "callback", valid_594443
  var valid_594444 = query.getOrDefault("access_token")
  valid_594444 = validateParameter(valid_594444, JString, required = false,
                                 default = nil)
  if valid_594444 != nil:
    section.add "access_token", valid_594444
  var valid_594445 = query.getOrDefault("uploadType")
  valid_594445 = validateParameter(valid_594445, JString, required = false,
                                 default = nil)
  if valid_594445 != nil:
    section.add "uploadType", valid_594445
  var valid_594446 = query.getOrDefault("key")
  valid_594446 = validateParameter(valid_594446, JString, required = false,
                                 default = nil)
  if valid_594446 != nil:
    section.add "key", valid_594446
  var valid_594447 = query.getOrDefault("$.xgafv")
  valid_594447 = validateParameter(valid_594447, JString, required = false,
                                 default = newJString("1"))
  if valid_594447 != nil:
    section.add "$.xgafv", valid_594447
  var valid_594448 = query.getOrDefault("prettyPrint")
  valid_594448 = validateParameter(valid_594448, JBool, required = false,
                                 default = newJBool(true))
  if valid_594448 != nil:
    section.add "prettyPrint", valid_594448
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594450: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594434;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a set of partition tokens that can be used to execute a query
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by ExecuteStreamingSql to specify a subset
  ## of the query result to read.  The same session and read-only transaction
  ## must be used by the PartitionQueryRequest used to create the
  ## partition tokens and the ExecuteSqlRequests that use the partition tokens.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the query, and
  ## the whole operation must be restarted from the beginning.
  ## 
  let valid = call_594450.validator(path, query, header, formData, body)
  let scheme = call_594450.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594450.url(scheme.get, call_594450.host, call_594450.base,
                         call_594450.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594450, url, valid)

proc call*(call_594451: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594434;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsPartitionQuery
  ## Creates a set of partition tokens that can be used to execute a query
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by ExecuteStreamingSql to specify a subset
  ## of the query result to read.  The same session and read-only transaction
  ## must be used by the PartitionQueryRequest used to create the
  ## partition tokens and the ExecuteSqlRequests that use the partition tokens.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the query, and
  ## the whole operation must be restarted from the beginning.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594452 = newJObject()
  var query_594453 = newJObject()
  var body_594454 = newJObject()
  add(query_594453, "upload_protocol", newJString(uploadProtocol))
  add(path_594452, "session", newJString(session))
  add(query_594453, "fields", newJString(fields))
  add(query_594453, "quotaUser", newJString(quotaUser))
  add(query_594453, "alt", newJString(alt))
  add(query_594453, "oauth_token", newJString(oauthToken))
  add(query_594453, "callback", newJString(callback))
  add(query_594453, "access_token", newJString(accessToken))
  add(query_594453, "uploadType", newJString(uploadType))
  add(query_594453, "key", newJString(key))
  add(query_594453, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594454 = body
  add(query_594453, "prettyPrint", newJBool(prettyPrint))
  result = call_594451.call(path_594452, query_594453, nil, nil, body_594454)

var spannerProjectsInstancesDatabasesSessionsPartitionQuery* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594434(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionQuery",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionQuery", validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594435,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_594436,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594455 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594457(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":partitionRead")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594456(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates a set of partition tokens that can be used to execute a read
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by StreamingRead to specify a subset of the read
  ## result to read.  The same session and read-only transaction must be used by
  ## the PartitionReadRequest used to create the partition tokens and the
  ## ReadRequests that use the partition tokens.  There are no ordering
  ## guarantees on rows returned among the returned partition tokens, or even
  ## within each individual StreamingRead call issued with a partition_token.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the read, and
  ## the whole operation must be restarted from the beginning.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session used to create the partitions.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594458 = path.getOrDefault("session")
  valid_594458 = validateParameter(valid_594458, JString, required = true,
                                 default = nil)
  if valid_594458 != nil:
    section.add "session", valid_594458
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594459 = query.getOrDefault("upload_protocol")
  valid_594459 = validateParameter(valid_594459, JString, required = false,
                                 default = nil)
  if valid_594459 != nil:
    section.add "upload_protocol", valid_594459
  var valid_594460 = query.getOrDefault("fields")
  valid_594460 = validateParameter(valid_594460, JString, required = false,
                                 default = nil)
  if valid_594460 != nil:
    section.add "fields", valid_594460
  var valid_594461 = query.getOrDefault("quotaUser")
  valid_594461 = validateParameter(valid_594461, JString, required = false,
                                 default = nil)
  if valid_594461 != nil:
    section.add "quotaUser", valid_594461
  var valid_594462 = query.getOrDefault("alt")
  valid_594462 = validateParameter(valid_594462, JString, required = false,
                                 default = newJString("json"))
  if valid_594462 != nil:
    section.add "alt", valid_594462
  var valid_594463 = query.getOrDefault("oauth_token")
  valid_594463 = validateParameter(valid_594463, JString, required = false,
                                 default = nil)
  if valid_594463 != nil:
    section.add "oauth_token", valid_594463
  var valid_594464 = query.getOrDefault("callback")
  valid_594464 = validateParameter(valid_594464, JString, required = false,
                                 default = nil)
  if valid_594464 != nil:
    section.add "callback", valid_594464
  var valid_594465 = query.getOrDefault("access_token")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "access_token", valid_594465
  var valid_594466 = query.getOrDefault("uploadType")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "uploadType", valid_594466
  var valid_594467 = query.getOrDefault("key")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "key", valid_594467
  var valid_594468 = query.getOrDefault("$.xgafv")
  valid_594468 = validateParameter(valid_594468, JString, required = false,
                                 default = newJString("1"))
  if valid_594468 != nil:
    section.add "$.xgafv", valid_594468
  var valid_594469 = query.getOrDefault("prettyPrint")
  valid_594469 = validateParameter(valid_594469, JBool, required = false,
                                 default = newJBool(true))
  if valid_594469 != nil:
    section.add "prettyPrint", valid_594469
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594471: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594455;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a set of partition tokens that can be used to execute a read
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by StreamingRead to specify a subset of the read
  ## result to read.  The same session and read-only transaction must be used by
  ## the PartitionReadRequest used to create the partition tokens and the
  ## ReadRequests that use the partition tokens.  There are no ordering
  ## guarantees on rows returned among the returned partition tokens, or even
  ## within each individual StreamingRead call issued with a partition_token.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the read, and
  ## the whole operation must be restarted from the beginning.
  ## 
  let valid = call_594471.validator(path, query, header, formData, body)
  let scheme = call_594471.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594471.url(scheme.get, call_594471.host, call_594471.base,
                         call_594471.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594471, url, valid)

proc call*(call_594472: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594455;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsPartitionRead
  ## Creates a set of partition tokens that can be used to execute a read
  ## operation in parallel.  Each of the returned partition tokens can be used
  ## by StreamingRead to specify a subset of the read
  ## result to read.  The same session and read-only transaction must be used by
  ## the PartitionReadRequest used to create the partition tokens and the
  ## ReadRequests that use the partition tokens.  There are no ordering
  ## guarantees on rows returned among the returned partition tokens, or even
  ## within each individual StreamingRead call issued with a partition_token.
  ## 
  ## Partition tokens become invalid when the session used to create them
  ## is deleted, is idle for too long, begins a new transaction, or becomes too
  ## old.  When any of these happen, it is not possible to resume the read, and
  ## the whole operation must be restarted from the beginning.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594473 = newJObject()
  var query_594474 = newJObject()
  var body_594475 = newJObject()
  add(query_594474, "upload_protocol", newJString(uploadProtocol))
  add(path_594473, "session", newJString(session))
  add(query_594474, "fields", newJString(fields))
  add(query_594474, "quotaUser", newJString(quotaUser))
  add(query_594474, "alt", newJString(alt))
  add(query_594474, "oauth_token", newJString(oauthToken))
  add(query_594474, "callback", newJString(callback))
  add(query_594474, "access_token", newJString(accessToken))
  add(query_594474, "uploadType", newJString(uploadType))
  add(query_594474, "key", newJString(key))
  add(query_594474, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594475 = body
  add(query_594474, "prettyPrint", newJBool(prettyPrint))
  result = call_594472.call(path_594473, query_594474, nil, nil, body_594475)

var spannerProjectsInstancesDatabasesSessionsPartitionRead* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594455(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594456,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_594457,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRead_594476 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsRead_594478(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":read")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsRead_594477(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Reads rows from the database using key lookups and scans, as a
  ## simple key/value style alternative to
  ## ExecuteSql.  This method cannot be used to
  ## return a result set larger than 10 MiB; if the read matches more
  ## data than that, the read fails with a `FAILED_PRECONDITION`
  ## error.
  ## 
  ## Reads inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be yielded in streaming fashion by calling
  ## StreamingRead instead.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the read should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594479 = path.getOrDefault("session")
  valid_594479 = validateParameter(valid_594479, JString, required = true,
                                 default = nil)
  if valid_594479 != nil:
    section.add "session", valid_594479
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594480 = query.getOrDefault("upload_protocol")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = nil)
  if valid_594480 != nil:
    section.add "upload_protocol", valid_594480
  var valid_594481 = query.getOrDefault("fields")
  valid_594481 = validateParameter(valid_594481, JString, required = false,
                                 default = nil)
  if valid_594481 != nil:
    section.add "fields", valid_594481
  var valid_594482 = query.getOrDefault("quotaUser")
  valid_594482 = validateParameter(valid_594482, JString, required = false,
                                 default = nil)
  if valid_594482 != nil:
    section.add "quotaUser", valid_594482
  var valid_594483 = query.getOrDefault("alt")
  valid_594483 = validateParameter(valid_594483, JString, required = false,
                                 default = newJString("json"))
  if valid_594483 != nil:
    section.add "alt", valid_594483
  var valid_594484 = query.getOrDefault("oauth_token")
  valid_594484 = validateParameter(valid_594484, JString, required = false,
                                 default = nil)
  if valid_594484 != nil:
    section.add "oauth_token", valid_594484
  var valid_594485 = query.getOrDefault("callback")
  valid_594485 = validateParameter(valid_594485, JString, required = false,
                                 default = nil)
  if valid_594485 != nil:
    section.add "callback", valid_594485
  var valid_594486 = query.getOrDefault("access_token")
  valid_594486 = validateParameter(valid_594486, JString, required = false,
                                 default = nil)
  if valid_594486 != nil:
    section.add "access_token", valid_594486
  var valid_594487 = query.getOrDefault("uploadType")
  valid_594487 = validateParameter(valid_594487, JString, required = false,
                                 default = nil)
  if valid_594487 != nil:
    section.add "uploadType", valid_594487
  var valid_594488 = query.getOrDefault("key")
  valid_594488 = validateParameter(valid_594488, JString, required = false,
                                 default = nil)
  if valid_594488 != nil:
    section.add "key", valid_594488
  var valid_594489 = query.getOrDefault("$.xgafv")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = newJString("1"))
  if valid_594489 != nil:
    section.add "$.xgafv", valid_594489
  var valid_594490 = query.getOrDefault("prettyPrint")
  valid_594490 = validateParameter(valid_594490, JBool, required = false,
                                 default = newJBool(true))
  if valid_594490 != nil:
    section.add "prettyPrint", valid_594490
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594492: Call_SpannerProjectsInstancesDatabasesSessionsRead_594476;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Reads rows from the database using key lookups and scans, as a
  ## simple key/value style alternative to
  ## ExecuteSql.  This method cannot be used to
  ## return a result set larger than 10 MiB; if the read matches more
  ## data than that, the read fails with a `FAILED_PRECONDITION`
  ## error.
  ## 
  ## Reads inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be yielded in streaming fashion by calling
  ## StreamingRead instead.
  ## 
  let valid = call_594492.validator(path, query, header, formData, body)
  let scheme = call_594492.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594492.url(scheme.get, call_594492.host, call_594492.base,
                         call_594492.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594492, url, valid)

proc call*(call_594493: Call_SpannerProjectsInstancesDatabasesSessionsRead_594476;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsRead
  ## Reads rows from the database using key lookups and scans, as a
  ## simple key/value style alternative to
  ## ExecuteSql.  This method cannot be used to
  ## return a result set larger than 10 MiB; if the read matches more
  ## data than that, the read fails with a `FAILED_PRECONDITION`
  ## error.
  ## 
  ## Reads inside read-write transactions might return `ABORTED`. If
  ## this occurs, the application should restart the transaction from
  ## the beginning. See Transaction for more details.
  ## 
  ## Larger result sets can be yielded in streaming fashion by calling
  ## StreamingRead instead.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594494 = newJObject()
  var query_594495 = newJObject()
  var body_594496 = newJObject()
  add(query_594495, "upload_protocol", newJString(uploadProtocol))
  add(path_594494, "session", newJString(session))
  add(query_594495, "fields", newJString(fields))
  add(query_594495, "quotaUser", newJString(quotaUser))
  add(query_594495, "alt", newJString(alt))
  add(query_594495, "oauth_token", newJString(oauthToken))
  add(query_594495, "callback", newJString(callback))
  add(query_594495, "access_token", newJString(accessToken))
  add(query_594495, "uploadType", newJString(uploadType))
  add(query_594495, "key", newJString(key))
  add(query_594495, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594496 = body
  add(query_594495, "prettyPrint", newJBool(prettyPrint))
  result = call_594493.call(path_594494, query_594495, nil, nil, body_594496)

var spannerProjectsInstancesDatabasesSessionsRead* = Call_SpannerProjectsInstancesDatabasesSessionsRead_594476(
    name: "spannerProjectsInstancesDatabasesSessionsRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:read",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRead_594477,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRead_594478,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRollback_594497 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsRollback_594499(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":rollback")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsRollback_594498(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the transaction to roll back is running.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594500 = path.getOrDefault("session")
  valid_594500 = validateParameter(valid_594500, JString, required = true,
                                 default = nil)
  if valid_594500 != nil:
    section.add "session", valid_594500
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594501 = query.getOrDefault("upload_protocol")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "upload_protocol", valid_594501
  var valid_594502 = query.getOrDefault("fields")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = nil)
  if valid_594502 != nil:
    section.add "fields", valid_594502
  var valid_594503 = query.getOrDefault("quotaUser")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "quotaUser", valid_594503
  var valid_594504 = query.getOrDefault("alt")
  valid_594504 = validateParameter(valid_594504, JString, required = false,
                                 default = newJString("json"))
  if valid_594504 != nil:
    section.add "alt", valid_594504
  var valid_594505 = query.getOrDefault("oauth_token")
  valid_594505 = validateParameter(valid_594505, JString, required = false,
                                 default = nil)
  if valid_594505 != nil:
    section.add "oauth_token", valid_594505
  var valid_594506 = query.getOrDefault("callback")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = nil)
  if valid_594506 != nil:
    section.add "callback", valid_594506
  var valid_594507 = query.getOrDefault("access_token")
  valid_594507 = validateParameter(valid_594507, JString, required = false,
                                 default = nil)
  if valid_594507 != nil:
    section.add "access_token", valid_594507
  var valid_594508 = query.getOrDefault("uploadType")
  valid_594508 = validateParameter(valid_594508, JString, required = false,
                                 default = nil)
  if valid_594508 != nil:
    section.add "uploadType", valid_594508
  var valid_594509 = query.getOrDefault("key")
  valid_594509 = validateParameter(valid_594509, JString, required = false,
                                 default = nil)
  if valid_594509 != nil:
    section.add "key", valid_594509
  var valid_594510 = query.getOrDefault("$.xgafv")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = newJString("1"))
  if valid_594510 != nil:
    section.add "$.xgafv", valid_594510
  var valid_594511 = query.getOrDefault("prettyPrint")
  valid_594511 = validateParameter(valid_594511, JBool, required = false,
                                 default = newJBool(true))
  if valid_594511 != nil:
    section.add "prettyPrint", valid_594511
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594513: Call_SpannerProjectsInstancesDatabasesSessionsRollback_594497;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
  ## 
  let valid = call_594513.validator(path, query, header, formData, body)
  let scheme = call_594513.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594513.url(scheme.get, call_594513.host, call_594513.base,
                         call_594513.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594513, url, valid)

proc call*(call_594514: Call_SpannerProjectsInstancesDatabasesSessionsRollback_594497;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsRollback
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the transaction to roll back is running.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594515 = newJObject()
  var query_594516 = newJObject()
  var body_594517 = newJObject()
  add(query_594516, "upload_protocol", newJString(uploadProtocol))
  add(path_594515, "session", newJString(session))
  add(query_594516, "fields", newJString(fields))
  add(query_594516, "quotaUser", newJString(quotaUser))
  add(query_594516, "alt", newJString(alt))
  add(query_594516, "oauth_token", newJString(oauthToken))
  add(query_594516, "callback", newJString(callback))
  add(query_594516, "access_token", newJString(accessToken))
  add(query_594516, "uploadType", newJString(uploadType))
  add(query_594516, "key", newJString(key))
  add(query_594516, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594517 = body
  add(query_594516, "prettyPrint", newJBool(prettyPrint))
  result = call_594514.call(path_594515, query_594516, nil, nil, body_594517)

var spannerProjectsInstancesDatabasesSessionsRollback* = Call_SpannerProjectsInstancesDatabasesSessionsRollback_594497(
    name: "spannerProjectsInstancesDatabasesSessionsRollback",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:rollback",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRollback_594498,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRollback_594499,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594518 = ref object of OpenApiRestCall_593421
proc url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594520(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "session" in path, "`session` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "session"),
               (kind: ConstantSegment, value: ":streamingRead")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594519(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   session: JString (required)
  ##          : Required. The session in which the read should be performed.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `session` field"
  var valid_594521 = path.getOrDefault("session")
  valid_594521 = validateParameter(valid_594521, JString, required = true,
                                 default = nil)
  if valid_594521 != nil:
    section.add "session", valid_594521
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   callback: JString
  ##           : JSONP
  ##   access_token: JString
  ##               : OAuth access token.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594522 = query.getOrDefault("upload_protocol")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "upload_protocol", valid_594522
  var valid_594523 = query.getOrDefault("fields")
  valid_594523 = validateParameter(valid_594523, JString, required = false,
                                 default = nil)
  if valid_594523 != nil:
    section.add "fields", valid_594523
  var valid_594524 = query.getOrDefault("quotaUser")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = nil)
  if valid_594524 != nil:
    section.add "quotaUser", valid_594524
  var valid_594525 = query.getOrDefault("alt")
  valid_594525 = validateParameter(valid_594525, JString, required = false,
                                 default = newJString("json"))
  if valid_594525 != nil:
    section.add "alt", valid_594525
  var valid_594526 = query.getOrDefault("oauth_token")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = nil)
  if valid_594526 != nil:
    section.add "oauth_token", valid_594526
  var valid_594527 = query.getOrDefault("callback")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "callback", valid_594527
  var valid_594528 = query.getOrDefault("access_token")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "access_token", valid_594528
  var valid_594529 = query.getOrDefault("uploadType")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "uploadType", valid_594529
  var valid_594530 = query.getOrDefault("key")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = nil)
  if valid_594530 != nil:
    section.add "key", valid_594530
  var valid_594531 = query.getOrDefault("$.xgafv")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = newJString("1"))
  if valid_594531 != nil:
    section.add "$.xgafv", valid_594531
  var valid_594532 = query.getOrDefault("prettyPrint")
  valid_594532 = validateParameter(valid_594532, JBool, required = false,
                                 default = newJBool(true))
  if valid_594532 != nil:
    section.add "prettyPrint", valid_594532
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   body: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_594534: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594518;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ## 
  let valid = call_594534.validator(path, query, header, formData, body)
  let scheme = call_594534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594534.url(scheme.get, call_594534.host, call_594534.base,
                         call_594534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594534, url, valid)

proc call*(call_594535: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594518;
          session: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsStreamingRead
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   alt: string
  ##      : Data format for response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   callback: string
  ##           : JSONP
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594536 = newJObject()
  var query_594537 = newJObject()
  var body_594538 = newJObject()
  add(query_594537, "upload_protocol", newJString(uploadProtocol))
  add(path_594536, "session", newJString(session))
  add(query_594537, "fields", newJString(fields))
  add(query_594537, "quotaUser", newJString(quotaUser))
  add(query_594537, "alt", newJString(alt))
  add(query_594537, "oauth_token", newJString(oauthToken))
  add(query_594537, "callback", newJString(callback))
  add(query_594537, "access_token", newJString(accessToken))
  add(query_594537, "uploadType", newJString(uploadType))
  add(query_594537, "key", newJString(key))
  add(query_594537, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594538 = body
  add(query_594537, "prettyPrint", newJBool(prettyPrint))
  result = call_594535.call(path_594536, query_594537, nil, nil, body_594538)

var spannerProjectsInstancesDatabasesSessionsStreamingRead* = Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594518(
    name: "spannerProjectsInstancesDatabasesSessionsStreamingRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:streamingRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594519,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_594520,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
