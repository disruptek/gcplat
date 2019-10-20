
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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

  OpenApiRestCall_578348 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_578348](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_578348): Option[Scheme] {.used.} =
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
proc queryString(query: JsonNode): string {.used.} =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs)

proc hydratePath(input: JsonNode; segments: seq[PathToken]): Option[string] {.used.} =
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
    case js.kind
    of JInt, JFloat, JNull, JBool:
      head = $js
    of JString:
      head = js.getStr
    else:
      return
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "spanner"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_SpannerProjectsInstancesDatabasesDropDatabase_578619 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesDropDatabase_578621(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "database" in path, "`database` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "database")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesDatabasesDropDatabase_578620(
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
  var valid_578747 = path.getOrDefault("database")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "database", valid_578747
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578748 = query.getOrDefault("key")
  valid_578748 = validateParameter(valid_578748, JString, required = false,
                                 default = nil)
  if valid_578748 != nil:
    section.add "key", valid_578748
  var valid_578762 = query.getOrDefault("prettyPrint")
  valid_578762 = validateParameter(valid_578762, JBool, required = false,
                                 default = newJBool(true))
  if valid_578762 != nil:
    section.add "prettyPrint", valid_578762
  var valid_578763 = query.getOrDefault("oauth_token")
  valid_578763 = validateParameter(valid_578763, JString, required = false,
                                 default = nil)
  if valid_578763 != nil:
    section.add "oauth_token", valid_578763
  var valid_578764 = query.getOrDefault("$.xgafv")
  valid_578764 = validateParameter(valid_578764, JString, required = false,
                                 default = newJString("1"))
  if valid_578764 != nil:
    section.add "$.xgafv", valid_578764
  var valid_578765 = query.getOrDefault("alt")
  valid_578765 = validateParameter(valid_578765, JString, required = false,
                                 default = newJString("json"))
  if valid_578765 != nil:
    section.add "alt", valid_578765
  var valid_578766 = query.getOrDefault("uploadType")
  valid_578766 = validateParameter(valid_578766, JString, required = false,
                                 default = nil)
  if valid_578766 != nil:
    section.add "uploadType", valid_578766
  var valid_578767 = query.getOrDefault("quotaUser")
  valid_578767 = validateParameter(valid_578767, JString, required = false,
                                 default = nil)
  if valid_578767 != nil:
    section.add "quotaUser", valid_578767
  var valid_578768 = query.getOrDefault("callback")
  valid_578768 = validateParameter(valid_578768, JString, required = false,
                                 default = nil)
  if valid_578768 != nil:
    section.add "callback", valid_578768
  var valid_578769 = query.getOrDefault("fields")
  valid_578769 = validateParameter(valid_578769, JString, required = false,
                                 default = nil)
  if valid_578769 != nil:
    section.add "fields", valid_578769
  var valid_578770 = query.getOrDefault("access_token")
  valid_578770 = validateParameter(valid_578770, JString, required = false,
                                 default = nil)
  if valid_578770 != nil:
    section.add "access_token", valid_578770
  var valid_578771 = query.getOrDefault("upload_protocol")
  valid_578771 = validateParameter(valid_578771, JString, required = false,
                                 default = nil)
  if valid_578771 != nil:
    section.add "upload_protocol", valid_578771
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578794: Call_SpannerProjectsInstancesDatabasesDropDatabase_578619;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Drops (aka deletes) a Cloud Spanner database.
  ## 
  let valid = call_578794.validator(path, query, header, formData, body)
  let scheme = call_578794.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578794.url(scheme.get, call_578794.host, call_578794.base,
                         call_578794.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578794, url, valid)

proc call*(call_578865: Call_SpannerProjectsInstancesDatabasesDropDatabase_578619;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesDropDatabase
  ## Drops (aka deletes) a Cloud Spanner database.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database to be dropped.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578866 = newJObject()
  var query_578868 = newJObject()
  add(query_578868, "key", newJString(key))
  add(query_578868, "prettyPrint", newJBool(prettyPrint))
  add(query_578868, "oauth_token", newJString(oauthToken))
  add(path_578866, "database", newJString(database))
  add(query_578868, "$.xgafv", newJString(Xgafv))
  add(query_578868, "alt", newJString(alt))
  add(query_578868, "uploadType", newJString(uploadType))
  add(query_578868, "quotaUser", newJString(quotaUser))
  add(query_578868, "callback", newJString(callback))
  add(query_578868, "fields", newJString(fields))
  add(query_578868, "access_token", newJString(accessToken))
  add(query_578868, "upload_protocol", newJString(uploadProtocol))
  result = call_578865.call(path_578866, query_578868, nil, nil, nil)

var spannerProjectsInstancesDatabasesDropDatabase* = Call_SpannerProjectsInstancesDatabasesDropDatabase_578619(
    name: "spannerProjectsInstancesDatabasesDropDatabase",
    meth: HttpMethod.HttpDelete, host: "spanner.googleapis.com",
    route: "/v1/{database}",
    validator: validate_SpannerProjectsInstancesDatabasesDropDatabase_578620,
    base: "/", url: url_SpannerProjectsInstancesDatabasesDropDatabase_578621,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetDdl_578907 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesGetDdl_578909(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesGetDdl_578908(path: JsonNode;
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
  var valid_578910 = path.getOrDefault("database")
  valid_578910 = validateParameter(valid_578910, JString, required = true,
                                 default = nil)
  if valid_578910 != nil:
    section.add "database", valid_578910
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578911 = query.getOrDefault("key")
  valid_578911 = validateParameter(valid_578911, JString, required = false,
                                 default = nil)
  if valid_578911 != nil:
    section.add "key", valid_578911
  var valid_578912 = query.getOrDefault("prettyPrint")
  valid_578912 = validateParameter(valid_578912, JBool, required = false,
                                 default = newJBool(true))
  if valid_578912 != nil:
    section.add "prettyPrint", valid_578912
  var valid_578913 = query.getOrDefault("oauth_token")
  valid_578913 = validateParameter(valid_578913, JString, required = false,
                                 default = nil)
  if valid_578913 != nil:
    section.add "oauth_token", valid_578913
  var valid_578914 = query.getOrDefault("$.xgafv")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = newJString("1"))
  if valid_578914 != nil:
    section.add "$.xgafv", valid_578914
  var valid_578915 = query.getOrDefault("alt")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("json"))
  if valid_578915 != nil:
    section.add "alt", valid_578915
  var valid_578916 = query.getOrDefault("uploadType")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = nil)
  if valid_578916 != nil:
    section.add "uploadType", valid_578916
  var valid_578917 = query.getOrDefault("quotaUser")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "quotaUser", valid_578917
  var valid_578918 = query.getOrDefault("callback")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "callback", valid_578918
  var valid_578919 = query.getOrDefault("fields")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "fields", valid_578919
  var valid_578920 = query.getOrDefault("access_token")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "access_token", valid_578920
  var valid_578921 = query.getOrDefault("upload_protocol")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "upload_protocol", valid_578921
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578922: Call_SpannerProjectsInstancesDatabasesGetDdl_578907;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ## 
  let valid = call_578922.validator(path, query, header, formData, body)
  let scheme = call_578922.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578922.url(scheme.get, call_578922.host, call_578922.base,
                         call_578922.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578922, url, valid)

proc call*(call_578923: Call_SpannerProjectsInstancesDatabasesGetDdl_578907;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesGetDdl
  ## Returns the schema of a Cloud Spanner database as a list of formatted
  ## DDL statements. This method does not show pending schema updates, those may
  ## be queried using the Operations API.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database whose schema we wish to get.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578924 = newJObject()
  var query_578925 = newJObject()
  add(query_578925, "key", newJString(key))
  add(query_578925, "prettyPrint", newJBool(prettyPrint))
  add(query_578925, "oauth_token", newJString(oauthToken))
  add(path_578924, "database", newJString(database))
  add(query_578925, "$.xgafv", newJString(Xgafv))
  add(query_578925, "alt", newJString(alt))
  add(query_578925, "uploadType", newJString(uploadType))
  add(query_578925, "quotaUser", newJString(quotaUser))
  add(query_578925, "callback", newJString(callback))
  add(query_578925, "fields", newJString(fields))
  add(query_578925, "access_token", newJString(accessToken))
  add(query_578925, "upload_protocol", newJString(uploadProtocol))
  result = call_578923.call(path_578924, query_578925, nil, nil, nil)

var spannerProjectsInstancesDatabasesGetDdl* = Call_SpannerProjectsInstancesDatabasesGetDdl_578907(
    name: "spannerProjectsInstancesDatabasesGetDdl", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesGetDdl_578908, base: "/",
    url: url_SpannerProjectsInstancesDatabasesGetDdl_578909,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesUpdateDdl_578926 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesUpdateDdl_578928(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesUpdateDdl_578927(path: JsonNode;
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
  var valid_578929 = path.getOrDefault("database")
  valid_578929 = validateParameter(valid_578929, JString, required = true,
                                 default = nil)
  if valid_578929 != nil:
    section.add "database", valid_578929
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578930 = query.getOrDefault("key")
  valid_578930 = validateParameter(valid_578930, JString, required = false,
                                 default = nil)
  if valid_578930 != nil:
    section.add "key", valid_578930
  var valid_578931 = query.getOrDefault("prettyPrint")
  valid_578931 = validateParameter(valid_578931, JBool, required = false,
                                 default = newJBool(true))
  if valid_578931 != nil:
    section.add "prettyPrint", valid_578931
  var valid_578932 = query.getOrDefault("oauth_token")
  valid_578932 = validateParameter(valid_578932, JString, required = false,
                                 default = nil)
  if valid_578932 != nil:
    section.add "oauth_token", valid_578932
  var valid_578933 = query.getOrDefault("$.xgafv")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = newJString("1"))
  if valid_578933 != nil:
    section.add "$.xgafv", valid_578933
  var valid_578934 = query.getOrDefault("alt")
  valid_578934 = validateParameter(valid_578934, JString, required = false,
                                 default = newJString("json"))
  if valid_578934 != nil:
    section.add "alt", valid_578934
  var valid_578935 = query.getOrDefault("uploadType")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "uploadType", valid_578935
  var valid_578936 = query.getOrDefault("quotaUser")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = nil)
  if valid_578936 != nil:
    section.add "quotaUser", valid_578936
  var valid_578937 = query.getOrDefault("callback")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = nil)
  if valid_578937 != nil:
    section.add "callback", valid_578937
  var valid_578938 = query.getOrDefault("fields")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "fields", valid_578938
  var valid_578939 = query.getOrDefault("access_token")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "access_token", valid_578939
  var valid_578940 = query.getOrDefault("upload_protocol")
  valid_578940 = validateParameter(valid_578940, JString, required = false,
                                 default = nil)
  if valid_578940 != nil:
    section.add "upload_protocol", valid_578940
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

proc call*(call_578942: Call_SpannerProjectsInstancesDatabasesUpdateDdl_578926;
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
  let valid = call_578942.validator(path, query, header, formData, body)
  let scheme = call_578942.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578942.url(scheme.get, call_578942.host, call_578942.base,
                         call_578942.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578942, url, valid)

proc call*(call_578943: Call_SpannerProjectsInstancesDatabasesUpdateDdl_578926;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesUpdateDdl
  ## Updates the schema of a Cloud Spanner database by
  ## creating/altering/dropping tables, columns, indexes, etc. The returned
  ## long-running operation will have a name of
  ## the format `<database_name>/operations/<operation_id>` and can be used to
  ## track execution of the schema change(s). The
  ## metadata field type is
  ## UpdateDatabaseDdlMetadata.  The operation has no response.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database to update.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578944 = newJObject()
  var query_578945 = newJObject()
  var body_578946 = newJObject()
  add(query_578945, "key", newJString(key))
  add(query_578945, "prettyPrint", newJBool(prettyPrint))
  add(query_578945, "oauth_token", newJString(oauthToken))
  add(path_578944, "database", newJString(database))
  add(query_578945, "$.xgafv", newJString(Xgafv))
  add(query_578945, "alt", newJString(alt))
  add(query_578945, "uploadType", newJString(uploadType))
  add(query_578945, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578946 = body
  add(query_578945, "callback", newJString(callback))
  add(query_578945, "fields", newJString(fields))
  add(query_578945, "access_token", newJString(accessToken))
  add(query_578945, "upload_protocol", newJString(uploadProtocol))
  result = call_578943.call(path_578944, query_578945, nil, nil, body_578946)

var spannerProjectsInstancesDatabasesUpdateDdl* = Call_SpannerProjectsInstancesDatabasesUpdateDdl_578926(
    name: "spannerProjectsInstancesDatabasesUpdateDdl",
    meth: HttpMethod.HttpPatch, host: "spanner.googleapis.com",
    route: "/v1/{database}/ddl",
    validator: validate_SpannerProjectsInstancesDatabasesUpdateDdl_578927,
    base: "/", url: url_SpannerProjectsInstancesDatabasesUpdateDdl_578928,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCreate_578969 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsCreate_578971(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsCreate_578970(
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
  var valid_578972 = path.getOrDefault("database")
  valid_578972 = validateParameter(valid_578972, JString, required = true,
                                 default = nil)
  if valid_578972 != nil:
    section.add "database", valid_578972
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578973 = query.getOrDefault("key")
  valid_578973 = validateParameter(valid_578973, JString, required = false,
                                 default = nil)
  if valid_578973 != nil:
    section.add "key", valid_578973
  var valid_578974 = query.getOrDefault("prettyPrint")
  valid_578974 = validateParameter(valid_578974, JBool, required = false,
                                 default = newJBool(true))
  if valid_578974 != nil:
    section.add "prettyPrint", valid_578974
  var valid_578975 = query.getOrDefault("oauth_token")
  valid_578975 = validateParameter(valid_578975, JString, required = false,
                                 default = nil)
  if valid_578975 != nil:
    section.add "oauth_token", valid_578975
  var valid_578976 = query.getOrDefault("$.xgafv")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = newJString("1"))
  if valid_578976 != nil:
    section.add "$.xgafv", valid_578976
  var valid_578977 = query.getOrDefault("alt")
  valid_578977 = validateParameter(valid_578977, JString, required = false,
                                 default = newJString("json"))
  if valid_578977 != nil:
    section.add "alt", valid_578977
  var valid_578978 = query.getOrDefault("uploadType")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "uploadType", valid_578978
  var valid_578979 = query.getOrDefault("quotaUser")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = nil)
  if valid_578979 != nil:
    section.add "quotaUser", valid_578979
  var valid_578980 = query.getOrDefault("callback")
  valid_578980 = validateParameter(valid_578980, JString, required = false,
                                 default = nil)
  if valid_578980 != nil:
    section.add "callback", valid_578980
  var valid_578981 = query.getOrDefault("fields")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = nil)
  if valid_578981 != nil:
    section.add "fields", valid_578981
  var valid_578982 = query.getOrDefault("access_token")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "access_token", valid_578982
  var valid_578983 = query.getOrDefault("upload_protocol")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "upload_protocol", valid_578983
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

proc call*(call_578985: Call_SpannerProjectsInstancesDatabasesSessionsCreate_578969;
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
  let valid = call_578985.validator(path, query, header, formData, body)
  let scheme = call_578985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578985.url(scheme.get, call_578985.host, call_578985.base,
                         call_578985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578985, url, valid)

proc call*(call_578986: Call_SpannerProjectsInstancesDatabasesSessionsCreate_578969;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database in which the new session is created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578987 = newJObject()
  var query_578988 = newJObject()
  var body_578989 = newJObject()
  add(query_578988, "key", newJString(key))
  add(query_578988, "prettyPrint", newJBool(prettyPrint))
  add(query_578988, "oauth_token", newJString(oauthToken))
  add(path_578987, "database", newJString(database))
  add(query_578988, "$.xgafv", newJString(Xgafv))
  add(query_578988, "alt", newJString(alt))
  add(query_578988, "uploadType", newJString(uploadType))
  add(query_578988, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_578989 = body
  add(query_578988, "callback", newJString(callback))
  add(query_578988, "fields", newJString(fields))
  add(query_578988, "access_token", newJString(accessToken))
  add(query_578988, "upload_protocol", newJString(uploadProtocol))
  result = call_578986.call(path_578987, query_578988, nil, nil, body_578989)

var spannerProjectsInstancesDatabasesSessionsCreate* = Call_SpannerProjectsInstancesDatabasesSessionsCreate_578969(
    name: "spannerProjectsInstancesDatabasesSessionsCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCreate_578970,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCreate_578971,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsList_578947 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsList_578949(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsList_578948(
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
  var valid_578950 = path.getOrDefault("database")
  valid_578950 = validateParameter(valid_578950, JString, required = true,
                                 default = nil)
  if valid_578950 != nil:
    section.add "database", valid_578950
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578951 = query.getOrDefault("key")
  valid_578951 = validateParameter(valid_578951, JString, required = false,
                                 default = nil)
  if valid_578951 != nil:
    section.add "key", valid_578951
  var valid_578952 = query.getOrDefault("prettyPrint")
  valid_578952 = validateParameter(valid_578952, JBool, required = false,
                                 default = newJBool(true))
  if valid_578952 != nil:
    section.add "prettyPrint", valid_578952
  var valid_578953 = query.getOrDefault("oauth_token")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "oauth_token", valid_578953
  var valid_578954 = query.getOrDefault("$.xgafv")
  valid_578954 = validateParameter(valid_578954, JString, required = false,
                                 default = newJString("1"))
  if valid_578954 != nil:
    section.add "$.xgafv", valid_578954
  var valid_578955 = query.getOrDefault("pageSize")
  valid_578955 = validateParameter(valid_578955, JInt, required = false, default = nil)
  if valid_578955 != nil:
    section.add "pageSize", valid_578955
  var valid_578956 = query.getOrDefault("alt")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("json"))
  if valid_578956 != nil:
    section.add "alt", valid_578956
  var valid_578957 = query.getOrDefault("uploadType")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = nil)
  if valid_578957 != nil:
    section.add "uploadType", valid_578957
  var valid_578958 = query.getOrDefault("quotaUser")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "quotaUser", valid_578958
  var valid_578959 = query.getOrDefault("filter")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "filter", valid_578959
  var valid_578960 = query.getOrDefault("pageToken")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "pageToken", valid_578960
  var valid_578961 = query.getOrDefault("callback")
  valid_578961 = validateParameter(valid_578961, JString, required = false,
                                 default = nil)
  if valid_578961 != nil:
    section.add "callback", valid_578961
  var valid_578962 = query.getOrDefault("fields")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "fields", valid_578962
  var valid_578963 = query.getOrDefault("access_token")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "access_token", valid_578963
  var valid_578964 = query.getOrDefault("upload_protocol")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "upload_protocol", valid_578964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578965: Call_SpannerProjectsInstancesDatabasesSessionsList_578947;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all sessions in a given database.
  ## 
  let valid = call_578965.validator(path, query, header, formData, body)
  let scheme = call_578965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578965.url(scheme.get, call_578965.host, call_578965.base,
                         call_578965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578965, url, valid)

proc call*(call_578966: Call_SpannerProjectsInstancesDatabasesSessionsList_578947;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsList
  ## Lists all sessions in a given database.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database in which to list sessions.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of sessions to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a previous
  ## ListSessionsResponse.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578967 = newJObject()
  var query_578968 = newJObject()
  add(query_578968, "key", newJString(key))
  add(query_578968, "prettyPrint", newJBool(prettyPrint))
  add(query_578968, "oauth_token", newJString(oauthToken))
  add(path_578967, "database", newJString(database))
  add(query_578968, "$.xgafv", newJString(Xgafv))
  add(query_578968, "pageSize", newJInt(pageSize))
  add(query_578968, "alt", newJString(alt))
  add(query_578968, "uploadType", newJString(uploadType))
  add(query_578968, "quotaUser", newJString(quotaUser))
  add(query_578968, "filter", newJString(filter))
  add(query_578968, "pageToken", newJString(pageToken))
  add(query_578968, "callback", newJString(callback))
  add(query_578968, "fields", newJString(fields))
  add(query_578968, "access_token", newJString(accessToken))
  add(query_578968, "upload_protocol", newJString(uploadProtocol))
  result = call_578966.call(path_578967, query_578968, nil, nil, nil)

var spannerProjectsInstancesDatabasesSessionsList* = Call_SpannerProjectsInstancesDatabasesSessionsList_578947(
    name: "spannerProjectsInstancesDatabasesSessionsList",
    meth: HttpMethod.HttpGet, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsList_578948,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsList_578949,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578990 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578992(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578991(
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
  var valid_578993 = path.getOrDefault("database")
  valid_578993 = validateParameter(valid_578993, JString, required = true,
                                 default = nil)
  if valid_578993 != nil:
    section.add "database", valid_578993
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578994 = query.getOrDefault("key")
  valid_578994 = validateParameter(valid_578994, JString, required = false,
                                 default = nil)
  if valid_578994 != nil:
    section.add "key", valid_578994
  var valid_578995 = query.getOrDefault("prettyPrint")
  valid_578995 = validateParameter(valid_578995, JBool, required = false,
                                 default = newJBool(true))
  if valid_578995 != nil:
    section.add "prettyPrint", valid_578995
  var valid_578996 = query.getOrDefault("oauth_token")
  valid_578996 = validateParameter(valid_578996, JString, required = false,
                                 default = nil)
  if valid_578996 != nil:
    section.add "oauth_token", valid_578996
  var valid_578997 = query.getOrDefault("$.xgafv")
  valid_578997 = validateParameter(valid_578997, JString, required = false,
                                 default = newJString("1"))
  if valid_578997 != nil:
    section.add "$.xgafv", valid_578997
  var valid_578998 = query.getOrDefault("alt")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = newJString("json"))
  if valid_578998 != nil:
    section.add "alt", valid_578998
  var valid_578999 = query.getOrDefault("uploadType")
  valid_578999 = validateParameter(valid_578999, JString, required = false,
                                 default = nil)
  if valid_578999 != nil:
    section.add "uploadType", valid_578999
  var valid_579000 = query.getOrDefault("quotaUser")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "quotaUser", valid_579000
  var valid_579001 = query.getOrDefault("callback")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = nil)
  if valid_579001 != nil:
    section.add "callback", valid_579001
  var valid_579002 = query.getOrDefault("fields")
  valid_579002 = validateParameter(valid_579002, JString, required = false,
                                 default = nil)
  if valid_579002 != nil:
    section.add "fields", valid_579002
  var valid_579003 = query.getOrDefault("access_token")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = nil)
  if valid_579003 != nil:
    section.add "access_token", valid_579003
  var valid_579004 = query.getOrDefault("upload_protocol")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "upload_protocol", valid_579004
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

proc call*(call_579006: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578990;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ## 
  let valid = call_579006.validator(path, query, header, formData, body)
  let scheme = call_579006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579006.url(scheme.get, call_579006.host, call_579006.base,
                         call_579006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579006, url, valid)

proc call*(call_579007: Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578990;
          database: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBatchCreate
  ## Creates multiple new sessions.
  ## 
  ## This API can be used to initialize a session cache on the clients.
  ## See https://goo.gl/TgSFN2 for best practices on session cache management.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   database: string (required)
  ##           : Required. The database in which the new sessions are created.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579008 = newJObject()
  var query_579009 = newJObject()
  var body_579010 = newJObject()
  add(query_579009, "key", newJString(key))
  add(query_579009, "prettyPrint", newJBool(prettyPrint))
  add(query_579009, "oauth_token", newJString(oauthToken))
  add(path_579008, "database", newJString(database))
  add(query_579009, "$.xgafv", newJString(Xgafv))
  add(query_579009, "alt", newJString(alt))
  add(query_579009, "uploadType", newJString(uploadType))
  add(query_579009, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579010 = body
  add(query_579009, "callback", newJString(callback))
  add(query_579009, "fields", newJString(fields))
  add(query_579009, "access_token", newJString(accessToken))
  add(query_579009, "upload_protocol", newJString(uploadProtocol))
  result = call_579007.call(path_579008, query_579009, nil, nil, body_579010)

var spannerProjectsInstancesDatabasesSessionsBatchCreate* = Call_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578990(
    name: "spannerProjectsInstancesDatabasesSessionsBatchCreate",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{database}/sessions:batchCreate",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578991,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBatchCreate_578992,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsGet_579011 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstanceConfigsGet_579013(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstanceConfigsGet_579012(path: JsonNode;
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
  var valid_579014 = path.getOrDefault("name")
  valid_579014 = validateParameter(valid_579014, JString, required = true,
                                 default = nil)
  if valid_579014 != nil:
    section.add "name", valid_579014
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579015 = query.getOrDefault("key")
  valid_579015 = validateParameter(valid_579015, JString, required = false,
                                 default = nil)
  if valid_579015 != nil:
    section.add "key", valid_579015
  var valid_579016 = query.getOrDefault("prettyPrint")
  valid_579016 = validateParameter(valid_579016, JBool, required = false,
                                 default = newJBool(true))
  if valid_579016 != nil:
    section.add "prettyPrint", valid_579016
  var valid_579017 = query.getOrDefault("oauth_token")
  valid_579017 = validateParameter(valid_579017, JString, required = false,
                                 default = nil)
  if valid_579017 != nil:
    section.add "oauth_token", valid_579017
  var valid_579018 = query.getOrDefault("$.xgafv")
  valid_579018 = validateParameter(valid_579018, JString, required = false,
                                 default = newJString("1"))
  if valid_579018 != nil:
    section.add "$.xgafv", valid_579018
  var valid_579019 = query.getOrDefault("alt")
  valid_579019 = validateParameter(valid_579019, JString, required = false,
                                 default = newJString("json"))
  if valid_579019 != nil:
    section.add "alt", valid_579019
  var valid_579020 = query.getOrDefault("uploadType")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "uploadType", valid_579020
  var valid_579021 = query.getOrDefault("quotaUser")
  valid_579021 = validateParameter(valid_579021, JString, required = false,
                                 default = nil)
  if valid_579021 != nil:
    section.add "quotaUser", valid_579021
  var valid_579022 = query.getOrDefault("callback")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "callback", valid_579022
  var valid_579023 = query.getOrDefault("fields")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = nil)
  if valid_579023 != nil:
    section.add "fields", valid_579023
  var valid_579024 = query.getOrDefault("access_token")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = nil)
  if valid_579024 != nil:
    section.add "access_token", valid_579024
  var valid_579025 = query.getOrDefault("upload_protocol")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "upload_protocol", valid_579025
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579026: Call_SpannerProjectsInstanceConfigsGet_579011;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets information about a particular instance configuration.
  ## 
  let valid = call_579026.validator(path, query, header, formData, body)
  let scheme = call_579026.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579026.url(scheme.get, call_579026.host, call_579026.base,
                         call_579026.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579026, url, valid)

proc call*(call_579027: Call_SpannerProjectsInstanceConfigsGet_579011;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstanceConfigsGet
  ## Gets information about a particular instance configuration.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. The name of the requested instance configuration. Values are of
  ## the form `projects/<project>/instanceConfigs/<config>`.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579028 = newJObject()
  var query_579029 = newJObject()
  add(query_579029, "key", newJString(key))
  add(query_579029, "prettyPrint", newJBool(prettyPrint))
  add(query_579029, "oauth_token", newJString(oauthToken))
  add(query_579029, "$.xgafv", newJString(Xgafv))
  add(query_579029, "alt", newJString(alt))
  add(query_579029, "uploadType", newJString(uploadType))
  add(query_579029, "quotaUser", newJString(quotaUser))
  add(path_579028, "name", newJString(name))
  add(query_579029, "callback", newJString(callback))
  add(query_579029, "fields", newJString(fields))
  add(query_579029, "access_token", newJString(accessToken))
  add(query_579029, "upload_protocol", newJString(uploadProtocol))
  result = call_579027.call(path_579028, query_579029, nil, nil, nil)

var spannerProjectsInstanceConfigsGet* = Call_SpannerProjectsInstanceConfigsGet_579011(
    name: "spannerProjectsInstanceConfigsGet", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstanceConfigsGet_579012, base: "/",
    url: url_SpannerProjectsInstanceConfigsGet_579013, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesPatch_579049 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesPatch_579051(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesPatch_579050(path: JsonNode; query: JsonNode;
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
  var valid_579052 = path.getOrDefault("name")
  valid_579052 = validateParameter(valid_579052, JString, required = true,
                                 default = nil)
  if valid_579052 != nil:
    section.add "name", valid_579052
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579053 = query.getOrDefault("key")
  valid_579053 = validateParameter(valid_579053, JString, required = false,
                                 default = nil)
  if valid_579053 != nil:
    section.add "key", valid_579053
  var valid_579054 = query.getOrDefault("prettyPrint")
  valid_579054 = validateParameter(valid_579054, JBool, required = false,
                                 default = newJBool(true))
  if valid_579054 != nil:
    section.add "prettyPrint", valid_579054
  var valid_579055 = query.getOrDefault("oauth_token")
  valid_579055 = validateParameter(valid_579055, JString, required = false,
                                 default = nil)
  if valid_579055 != nil:
    section.add "oauth_token", valid_579055
  var valid_579056 = query.getOrDefault("$.xgafv")
  valid_579056 = validateParameter(valid_579056, JString, required = false,
                                 default = newJString("1"))
  if valid_579056 != nil:
    section.add "$.xgafv", valid_579056
  var valid_579057 = query.getOrDefault("alt")
  valid_579057 = validateParameter(valid_579057, JString, required = false,
                                 default = newJString("json"))
  if valid_579057 != nil:
    section.add "alt", valid_579057
  var valid_579058 = query.getOrDefault("uploadType")
  valid_579058 = validateParameter(valid_579058, JString, required = false,
                                 default = nil)
  if valid_579058 != nil:
    section.add "uploadType", valid_579058
  var valid_579059 = query.getOrDefault("quotaUser")
  valid_579059 = validateParameter(valid_579059, JString, required = false,
                                 default = nil)
  if valid_579059 != nil:
    section.add "quotaUser", valid_579059
  var valid_579060 = query.getOrDefault("callback")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "callback", valid_579060
  var valid_579061 = query.getOrDefault("fields")
  valid_579061 = validateParameter(valid_579061, JString, required = false,
                                 default = nil)
  if valid_579061 != nil:
    section.add "fields", valid_579061
  var valid_579062 = query.getOrDefault("access_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "access_token", valid_579062
  var valid_579063 = query.getOrDefault("upload_protocol")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = nil)
  if valid_579063 != nil:
    section.add "upload_protocol", valid_579063
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

proc call*(call_579065: Call_SpannerProjectsInstancesPatch_579049; path: JsonNode;
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
  let valid = call_579065.validator(path, query, header, formData, body)
  let scheme = call_579065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579065.url(scheme.get, call_579065.host, call_579065.base,
                         call_579065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579065, url, valid)

proc call*(call_579066: Call_SpannerProjectsInstancesPatch_579049; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. A unique identifier for the instance, which cannot be changed
  ## after the instance is created. Values are of the form
  ## `projects/<project>/instances/a-z*[a-z0-9]`. The final
  ## segment of the name must be between 2 and 64 characters in length.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579067 = newJObject()
  var query_579068 = newJObject()
  var body_579069 = newJObject()
  add(query_579068, "key", newJString(key))
  add(query_579068, "prettyPrint", newJBool(prettyPrint))
  add(query_579068, "oauth_token", newJString(oauthToken))
  add(query_579068, "$.xgafv", newJString(Xgafv))
  add(query_579068, "alt", newJString(alt))
  add(query_579068, "uploadType", newJString(uploadType))
  add(query_579068, "quotaUser", newJString(quotaUser))
  add(path_579067, "name", newJString(name))
  if body != nil:
    body_579069 = body
  add(query_579068, "callback", newJString(callback))
  add(query_579068, "fields", newJString(fields))
  add(query_579068, "access_token", newJString(accessToken))
  add(query_579068, "upload_protocol", newJString(uploadProtocol))
  result = call_579066.call(path_579067, query_579068, nil, nil, body_579069)

var spannerProjectsInstancesPatch* = Call_SpannerProjectsInstancesPatch_579049(
    name: "spannerProjectsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesPatch_579050, base: "/",
    url: url_SpannerProjectsInstancesPatch_579051, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesOperationsDelete_579030 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesOperationsDelete_579032(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_SpannerProjectsInstancesOperationsDelete_579031(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579033 = path.getOrDefault("name")
  valid_579033 = validateParameter(valid_579033, JString, required = true,
                                 default = nil)
  if valid_579033 != nil:
    section.add "name", valid_579033
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579034 = query.getOrDefault("key")
  valid_579034 = validateParameter(valid_579034, JString, required = false,
                                 default = nil)
  if valid_579034 != nil:
    section.add "key", valid_579034
  var valid_579035 = query.getOrDefault("prettyPrint")
  valid_579035 = validateParameter(valid_579035, JBool, required = false,
                                 default = newJBool(true))
  if valid_579035 != nil:
    section.add "prettyPrint", valid_579035
  var valid_579036 = query.getOrDefault("oauth_token")
  valid_579036 = validateParameter(valid_579036, JString, required = false,
                                 default = nil)
  if valid_579036 != nil:
    section.add "oauth_token", valid_579036
  var valid_579037 = query.getOrDefault("$.xgafv")
  valid_579037 = validateParameter(valid_579037, JString, required = false,
                                 default = newJString("1"))
  if valid_579037 != nil:
    section.add "$.xgafv", valid_579037
  var valid_579038 = query.getOrDefault("alt")
  valid_579038 = validateParameter(valid_579038, JString, required = false,
                                 default = newJString("json"))
  if valid_579038 != nil:
    section.add "alt", valid_579038
  var valid_579039 = query.getOrDefault("uploadType")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "uploadType", valid_579039
  var valid_579040 = query.getOrDefault("quotaUser")
  valid_579040 = validateParameter(valid_579040, JString, required = false,
                                 default = nil)
  if valid_579040 != nil:
    section.add "quotaUser", valid_579040
  var valid_579041 = query.getOrDefault("callback")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "callback", valid_579041
  var valid_579042 = query.getOrDefault("fields")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = nil)
  if valid_579042 != nil:
    section.add "fields", valid_579042
  var valid_579043 = query.getOrDefault("access_token")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = nil)
  if valid_579043 != nil:
    section.add "access_token", valid_579043
  var valid_579044 = query.getOrDefault("upload_protocol")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "upload_protocol", valid_579044
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579045: Call_SpannerProjectsInstancesOperationsDelete_579030;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_579045.validator(path, query, header, formData, body)
  let scheme = call_579045.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579045.url(scheme.get, call_579045.host, call_579045.base,
                         call_579045.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579045, url, valid)

proc call*(call_579046: Call_SpannerProjectsInstancesOperationsDelete_579030;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesOperationsDelete
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be deleted.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579047 = newJObject()
  var query_579048 = newJObject()
  add(query_579048, "key", newJString(key))
  add(query_579048, "prettyPrint", newJBool(prettyPrint))
  add(query_579048, "oauth_token", newJString(oauthToken))
  add(query_579048, "$.xgafv", newJString(Xgafv))
  add(query_579048, "alt", newJString(alt))
  add(query_579048, "uploadType", newJString(uploadType))
  add(query_579048, "quotaUser", newJString(quotaUser))
  add(path_579047, "name", newJString(name))
  add(query_579048, "callback", newJString(callback))
  add(query_579048, "fields", newJString(fields))
  add(query_579048, "access_token", newJString(accessToken))
  add(query_579048, "upload_protocol", newJString(uploadProtocol))
  result = call_579046.call(path_579047, query_579048, nil, nil, nil)

var spannerProjectsInstancesOperationsDelete* = Call_SpannerProjectsInstancesOperationsDelete_579030(
    name: "spannerProjectsInstancesOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "spanner.googleapis.com", route: "/v1/{name}",
    validator: validate_SpannerProjectsInstancesOperationsDelete_579031,
    base: "/", url: url_SpannerProjectsInstancesOperationsDelete_579032,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesOperationsCancel_579070 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesOperationsCancel_579072(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesOperationsCancel_579071(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579073 = path.getOrDefault("name")
  valid_579073 = validateParameter(valid_579073, JString, required = true,
                                 default = nil)
  if valid_579073 != nil:
    section.add "name", valid_579073
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579074 = query.getOrDefault("key")
  valid_579074 = validateParameter(valid_579074, JString, required = false,
                                 default = nil)
  if valid_579074 != nil:
    section.add "key", valid_579074
  var valid_579075 = query.getOrDefault("prettyPrint")
  valid_579075 = validateParameter(valid_579075, JBool, required = false,
                                 default = newJBool(true))
  if valid_579075 != nil:
    section.add "prettyPrint", valid_579075
  var valid_579076 = query.getOrDefault("oauth_token")
  valid_579076 = validateParameter(valid_579076, JString, required = false,
                                 default = nil)
  if valid_579076 != nil:
    section.add "oauth_token", valid_579076
  var valid_579077 = query.getOrDefault("$.xgafv")
  valid_579077 = validateParameter(valid_579077, JString, required = false,
                                 default = newJString("1"))
  if valid_579077 != nil:
    section.add "$.xgafv", valid_579077
  var valid_579078 = query.getOrDefault("alt")
  valid_579078 = validateParameter(valid_579078, JString, required = false,
                                 default = newJString("json"))
  if valid_579078 != nil:
    section.add "alt", valid_579078
  var valid_579079 = query.getOrDefault("uploadType")
  valid_579079 = validateParameter(valid_579079, JString, required = false,
                                 default = nil)
  if valid_579079 != nil:
    section.add "uploadType", valid_579079
  var valid_579080 = query.getOrDefault("quotaUser")
  valid_579080 = validateParameter(valid_579080, JString, required = false,
                                 default = nil)
  if valid_579080 != nil:
    section.add "quotaUser", valid_579080
  var valid_579081 = query.getOrDefault("callback")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "callback", valid_579081
  var valid_579082 = query.getOrDefault("fields")
  valid_579082 = validateParameter(valid_579082, JString, required = false,
                                 default = nil)
  if valid_579082 != nil:
    section.add "fields", valid_579082
  var valid_579083 = query.getOrDefault("access_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "access_token", valid_579083
  var valid_579084 = query.getOrDefault("upload_protocol")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = nil)
  if valid_579084 != nil:
    section.add "upload_protocol", valid_579084
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579085: Call_SpannerProjectsInstancesOperationsCancel_579070;
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
  let valid = call_579085.validator(path, query, header, formData, body)
  let scheme = call_579085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579085.url(scheme.get, call_579085.host, call_579085.base,
                         call_579085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579085, url, valid)

proc call*(call_579086: Call_SpannerProjectsInstancesOperationsCancel_579070;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesOperationsCancel
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation resource to be cancelled.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579087 = newJObject()
  var query_579088 = newJObject()
  add(query_579088, "key", newJString(key))
  add(query_579088, "prettyPrint", newJBool(prettyPrint))
  add(query_579088, "oauth_token", newJString(oauthToken))
  add(query_579088, "$.xgafv", newJString(Xgafv))
  add(query_579088, "alt", newJString(alt))
  add(query_579088, "uploadType", newJString(uploadType))
  add(query_579088, "quotaUser", newJString(quotaUser))
  add(path_579087, "name", newJString(name))
  add(query_579088, "callback", newJString(callback))
  add(query_579088, "fields", newJString(fields))
  add(query_579088, "access_token", newJString(accessToken))
  add(query_579088, "upload_protocol", newJString(uploadProtocol))
  result = call_579086.call(path_579087, query_579088, nil, nil, nil)

var spannerProjectsInstancesOperationsCancel* = Call_SpannerProjectsInstancesOperationsCancel_579070(
    name: "spannerProjectsInstancesOperationsCancel", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_SpannerProjectsInstancesOperationsCancel_579071,
    base: "/", url: url_SpannerProjectsInstancesOperationsCancel_579072,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesCreate_579110 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesCreate_579112(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesCreate_579111(path: JsonNode;
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
  var valid_579113 = path.getOrDefault("parent")
  valid_579113 = validateParameter(valid_579113, JString, required = true,
                                 default = nil)
  if valid_579113 != nil:
    section.add "parent", valid_579113
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579114 = query.getOrDefault("key")
  valid_579114 = validateParameter(valid_579114, JString, required = false,
                                 default = nil)
  if valid_579114 != nil:
    section.add "key", valid_579114
  var valid_579115 = query.getOrDefault("prettyPrint")
  valid_579115 = validateParameter(valid_579115, JBool, required = false,
                                 default = newJBool(true))
  if valid_579115 != nil:
    section.add "prettyPrint", valid_579115
  var valid_579116 = query.getOrDefault("oauth_token")
  valid_579116 = validateParameter(valid_579116, JString, required = false,
                                 default = nil)
  if valid_579116 != nil:
    section.add "oauth_token", valid_579116
  var valid_579117 = query.getOrDefault("$.xgafv")
  valid_579117 = validateParameter(valid_579117, JString, required = false,
                                 default = newJString("1"))
  if valid_579117 != nil:
    section.add "$.xgafv", valid_579117
  var valid_579118 = query.getOrDefault("alt")
  valid_579118 = validateParameter(valid_579118, JString, required = false,
                                 default = newJString("json"))
  if valid_579118 != nil:
    section.add "alt", valid_579118
  var valid_579119 = query.getOrDefault("uploadType")
  valid_579119 = validateParameter(valid_579119, JString, required = false,
                                 default = nil)
  if valid_579119 != nil:
    section.add "uploadType", valid_579119
  var valid_579120 = query.getOrDefault("quotaUser")
  valid_579120 = validateParameter(valid_579120, JString, required = false,
                                 default = nil)
  if valid_579120 != nil:
    section.add "quotaUser", valid_579120
  var valid_579121 = query.getOrDefault("callback")
  valid_579121 = validateParameter(valid_579121, JString, required = false,
                                 default = nil)
  if valid_579121 != nil:
    section.add "callback", valid_579121
  var valid_579122 = query.getOrDefault("fields")
  valid_579122 = validateParameter(valid_579122, JString, required = false,
                                 default = nil)
  if valid_579122 != nil:
    section.add "fields", valid_579122
  var valid_579123 = query.getOrDefault("access_token")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "access_token", valid_579123
  var valid_579124 = query.getOrDefault("upload_protocol")
  valid_579124 = validateParameter(valid_579124, JString, required = false,
                                 default = nil)
  if valid_579124 != nil:
    section.add "upload_protocol", valid_579124
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

proc call*(call_579126: Call_SpannerProjectsInstancesDatabasesCreate_579110;
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
  let valid = call_579126.validator(path, query, header, formData, body)
  let scheme = call_579126.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579126.url(scheme.get, call_579126.host, call_579126.base,
                         call_579126.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579126, url, valid)

proc call*(call_579127: Call_SpannerProjectsInstancesDatabasesCreate_579110;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesCreate
  ## Creates a new Cloud Spanner database and starts to prepare it for serving.
  ## The returned long-running operation will
  ## have a name of the format `<database_name>/operations/<operation_id>` and
  ## can be used to track preparation of the database. The
  ## metadata field type is
  ## CreateDatabaseMetadata. The
  ## response field type is
  ## Database, if successful.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the instance that will serve the new database.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579128 = newJObject()
  var query_579129 = newJObject()
  var body_579130 = newJObject()
  add(query_579129, "key", newJString(key))
  add(query_579129, "prettyPrint", newJBool(prettyPrint))
  add(query_579129, "oauth_token", newJString(oauthToken))
  add(query_579129, "$.xgafv", newJString(Xgafv))
  add(query_579129, "alt", newJString(alt))
  add(query_579129, "uploadType", newJString(uploadType))
  add(query_579129, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579130 = body
  add(query_579129, "callback", newJString(callback))
  add(path_579128, "parent", newJString(parent))
  add(query_579129, "fields", newJString(fields))
  add(query_579129, "access_token", newJString(accessToken))
  add(query_579129, "upload_protocol", newJString(uploadProtocol))
  result = call_579127.call(path_579128, query_579129, nil, nil, body_579130)

var spannerProjectsInstancesDatabasesCreate* = Call_SpannerProjectsInstancesDatabasesCreate_579110(
    name: "spannerProjectsInstancesDatabasesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesCreate_579111, base: "/",
    url: url_SpannerProjectsInstancesDatabasesCreate_579112,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesList_579089 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesList_579091(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesList_579090(path: JsonNode;
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
  var valid_579092 = path.getOrDefault("parent")
  valid_579092 = validateParameter(valid_579092, JString, required = true,
                                 default = nil)
  if valid_579092 != nil:
    section.add "parent", valid_579092
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579093 = query.getOrDefault("key")
  valid_579093 = validateParameter(valid_579093, JString, required = false,
                                 default = nil)
  if valid_579093 != nil:
    section.add "key", valid_579093
  var valid_579094 = query.getOrDefault("prettyPrint")
  valid_579094 = validateParameter(valid_579094, JBool, required = false,
                                 default = newJBool(true))
  if valid_579094 != nil:
    section.add "prettyPrint", valid_579094
  var valid_579095 = query.getOrDefault("oauth_token")
  valid_579095 = validateParameter(valid_579095, JString, required = false,
                                 default = nil)
  if valid_579095 != nil:
    section.add "oauth_token", valid_579095
  var valid_579096 = query.getOrDefault("$.xgafv")
  valid_579096 = validateParameter(valid_579096, JString, required = false,
                                 default = newJString("1"))
  if valid_579096 != nil:
    section.add "$.xgafv", valid_579096
  var valid_579097 = query.getOrDefault("pageSize")
  valid_579097 = validateParameter(valid_579097, JInt, required = false, default = nil)
  if valid_579097 != nil:
    section.add "pageSize", valid_579097
  var valid_579098 = query.getOrDefault("alt")
  valid_579098 = validateParameter(valid_579098, JString, required = false,
                                 default = newJString("json"))
  if valid_579098 != nil:
    section.add "alt", valid_579098
  var valid_579099 = query.getOrDefault("uploadType")
  valid_579099 = validateParameter(valid_579099, JString, required = false,
                                 default = nil)
  if valid_579099 != nil:
    section.add "uploadType", valid_579099
  var valid_579100 = query.getOrDefault("quotaUser")
  valid_579100 = validateParameter(valid_579100, JString, required = false,
                                 default = nil)
  if valid_579100 != nil:
    section.add "quotaUser", valid_579100
  var valid_579101 = query.getOrDefault("pageToken")
  valid_579101 = validateParameter(valid_579101, JString, required = false,
                                 default = nil)
  if valid_579101 != nil:
    section.add "pageToken", valid_579101
  var valid_579102 = query.getOrDefault("callback")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "callback", valid_579102
  var valid_579103 = query.getOrDefault("fields")
  valid_579103 = validateParameter(valid_579103, JString, required = false,
                                 default = nil)
  if valid_579103 != nil:
    section.add "fields", valid_579103
  var valid_579104 = query.getOrDefault("access_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "access_token", valid_579104
  var valid_579105 = query.getOrDefault("upload_protocol")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = nil)
  if valid_579105 != nil:
    section.add "upload_protocol", valid_579105
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579106: Call_SpannerProjectsInstancesDatabasesList_579089;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists Cloud Spanner databases.
  ## 
  let valid = call_579106.validator(path, query, header, formData, body)
  let scheme = call_579106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579106.url(scheme.get, call_579106.host, call_579106.base,
                         call_579106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579106, url, valid)

proc call*(call_579107: Call_SpannerProjectsInstancesDatabasesList_579089;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesList
  ## Lists Cloud Spanner databases.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of databases to be returned in the response. If 0 or less,
  ## defaults to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListDatabasesResponse.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The instance whose databases should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579108 = newJObject()
  var query_579109 = newJObject()
  add(query_579109, "key", newJString(key))
  add(query_579109, "prettyPrint", newJBool(prettyPrint))
  add(query_579109, "oauth_token", newJString(oauthToken))
  add(query_579109, "$.xgafv", newJString(Xgafv))
  add(query_579109, "pageSize", newJInt(pageSize))
  add(query_579109, "alt", newJString(alt))
  add(query_579109, "uploadType", newJString(uploadType))
  add(query_579109, "quotaUser", newJString(quotaUser))
  add(query_579109, "pageToken", newJString(pageToken))
  add(query_579109, "callback", newJString(callback))
  add(path_579108, "parent", newJString(parent))
  add(query_579109, "fields", newJString(fields))
  add(query_579109, "access_token", newJString(accessToken))
  add(query_579109, "upload_protocol", newJString(uploadProtocol))
  result = call_579107.call(path_579108, query_579109, nil, nil, nil)

var spannerProjectsInstancesDatabasesList* = Call_SpannerProjectsInstancesDatabasesList_579089(
    name: "spannerProjectsInstancesDatabasesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/databases",
    validator: validate_SpannerProjectsInstancesDatabasesList_579090, base: "/",
    url: url_SpannerProjectsInstancesDatabasesList_579091, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstanceConfigsList_579131 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstanceConfigsList_579133(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstanceConfigsList_579132(path: JsonNode;
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
  var valid_579134 = path.getOrDefault("parent")
  valid_579134 = validateParameter(valid_579134, JString, required = true,
                                 default = nil)
  if valid_579134 != nil:
    section.add "parent", valid_579134
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579135 = query.getOrDefault("key")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "key", valid_579135
  var valid_579136 = query.getOrDefault("prettyPrint")
  valid_579136 = validateParameter(valid_579136, JBool, required = false,
                                 default = newJBool(true))
  if valid_579136 != nil:
    section.add "prettyPrint", valid_579136
  var valid_579137 = query.getOrDefault("oauth_token")
  valid_579137 = validateParameter(valid_579137, JString, required = false,
                                 default = nil)
  if valid_579137 != nil:
    section.add "oauth_token", valid_579137
  var valid_579138 = query.getOrDefault("$.xgafv")
  valid_579138 = validateParameter(valid_579138, JString, required = false,
                                 default = newJString("1"))
  if valid_579138 != nil:
    section.add "$.xgafv", valid_579138
  var valid_579139 = query.getOrDefault("pageSize")
  valid_579139 = validateParameter(valid_579139, JInt, required = false, default = nil)
  if valid_579139 != nil:
    section.add "pageSize", valid_579139
  var valid_579140 = query.getOrDefault("alt")
  valid_579140 = validateParameter(valid_579140, JString, required = false,
                                 default = newJString("json"))
  if valid_579140 != nil:
    section.add "alt", valid_579140
  var valid_579141 = query.getOrDefault("uploadType")
  valid_579141 = validateParameter(valid_579141, JString, required = false,
                                 default = nil)
  if valid_579141 != nil:
    section.add "uploadType", valid_579141
  var valid_579142 = query.getOrDefault("quotaUser")
  valid_579142 = validateParameter(valid_579142, JString, required = false,
                                 default = nil)
  if valid_579142 != nil:
    section.add "quotaUser", valid_579142
  var valid_579143 = query.getOrDefault("pageToken")
  valid_579143 = validateParameter(valid_579143, JString, required = false,
                                 default = nil)
  if valid_579143 != nil:
    section.add "pageToken", valid_579143
  var valid_579144 = query.getOrDefault("callback")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "callback", valid_579144
  var valid_579145 = query.getOrDefault("fields")
  valid_579145 = validateParameter(valid_579145, JString, required = false,
                                 default = nil)
  if valid_579145 != nil:
    section.add "fields", valid_579145
  var valid_579146 = query.getOrDefault("access_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "access_token", valid_579146
  var valid_579147 = query.getOrDefault("upload_protocol")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = nil)
  if valid_579147 != nil:
    section.add "upload_protocol", valid_579147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579148: Call_SpannerProjectsInstanceConfigsList_579131;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists the supported instance configurations for a given project.
  ## 
  let valid = call_579148.validator(path, query, header, formData, body)
  let scheme = call_579148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579148.url(scheme.get, call_579148.host, call_579148.base,
                         call_579148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579148, url, valid)

proc call*(call_579149: Call_SpannerProjectsInstanceConfigsList_579131;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstanceConfigsList
  ## Lists the supported instance configurations for a given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instance configurations to be returned in the response. If 0 or
  ## less, defaults to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token
  ## from a previous ListInstanceConfigsResponse.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of supported instance
  ## configurations is requested. Values are of the form
  ## `projects/<project>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579150 = newJObject()
  var query_579151 = newJObject()
  add(query_579151, "key", newJString(key))
  add(query_579151, "prettyPrint", newJBool(prettyPrint))
  add(query_579151, "oauth_token", newJString(oauthToken))
  add(query_579151, "$.xgafv", newJString(Xgafv))
  add(query_579151, "pageSize", newJInt(pageSize))
  add(query_579151, "alt", newJString(alt))
  add(query_579151, "uploadType", newJString(uploadType))
  add(query_579151, "quotaUser", newJString(quotaUser))
  add(query_579151, "pageToken", newJString(pageToken))
  add(query_579151, "callback", newJString(callback))
  add(path_579150, "parent", newJString(parent))
  add(query_579151, "fields", newJString(fields))
  add(query_579151, "access_token", newJString(accessToken))
  add(query_579151, "upload_protocol", newJString(uploadProtocol))
  result = call_579149.call(path_579150, query_579151, nil, nil, nil)

var spannerProjectsInstanceConfigsList* = Call_SpannerProjectsInstanceConfigsList_579131(
    name: "spannerProjectsInstanceConfigsList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instanceConfigs",
    validator: validate_SpannerProjectsInstanceConfigsList_579132, base: "/",
    url: url_SpannerProjectsInstanceConfigsList_579133, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesCreate_579174 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesCreate_579176(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesCreate_579175(path: JsonNode;
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
  var valid_579177 = path.getOrDefault("parent")
  valid_579177 = validateParameter(valid_579177, JString, required = true,
                                 default = nil)
  if valid_579177 != nil:
    section.add "parent", valid_579177
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579178 = query.getOrDefault("key")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "key", valid_579178
  var valid_579179 = query.getOrDefault("prettyPrint")
  valid_579179 = validateParameter(valid_579179, JBool, required = false,
                                 default = newJBool(true))
  if valid_579179 != nil:
    section.add "prettyPrint", valid_579179
  var valid_579180 = query.getOrDefault("oauth_token")
  valid_579180 = validateParameter(valid_579180, JString, required = false,
                                 default = nil)
  if valid_579180 != nil:
    section.add "oauth_token", valid_579180
  var valid_579181 = query.getOrDefault("$.xgafv")
  valid_579181 = validateParameter(valid_579181, JString, required = false,
                                 default = newJString("1"))
  if valid_579181 != nil:
    section.add "$.xgafv", valid_579181
  var valid_579182 = query.getOrDefault("alt")
  valid_579182 = validateParameter(valid_579182, JString, required = false,
                                 default = newJString("json"))
  if valid_579182 != nil:
    section.add "alt", valid_579182
  var valid_579183 = query.getOrDefault("uploadType")
  valid_579183 = validateParameter(valid_579183, JString, required = false,
                                 default = nil)
  if valid_579183 != nil:
    section.add "uploadType", valid_579183
  var valid_579184 = query.getOrDefault("quotaUser")
  valid_579184 = validateParameter(valid_579184, JString, required = false,
                                 default = nil)
  if valid_579184 != nil:
    section.add "quotaUser", valid_579184
  var valid_579185 = query.getOrDefault("callback")
  valid_579185 = validateParameter(valid_579185, JString, required = false,
                                 default = nil)
  if valid_579185 != nil:
    section.add "callback", valid_579185
  var valid_579186 = query.getOrDefault("fields")
  valid_579186 = validateParameter(valid_579186, JString, required = false,
                                 default = nil)
  if valid_579186 != nil:
    section.add "fields", valid_579186
  var valid_579187 = query.getOrDefault("access_token")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "access_token", valid_579187
  var valid_579188 = query.getOrDefault("upload_protocol")
  valid_579188 = validateParameter(valid_579188, JString, required = false,
                                 default = nil)
  if valid_579188 != nil:
    section.add "upload_protocol", valid_579188
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

proc call*(call_579190: Call_SpannerProjectsInstancesCreate_579174; path: JsonNode;
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
  let valid = call_579190.validator(path, query, header, formData, body)
  let scheme = call_579190.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579190.url(scheme.get, call_579190.host, call_579190.base,
                         call_579190.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579190, url, valid)

proc call*(call_579191: Call_SpannerProjectsInstancesCreate_579174; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project in which to create the instance. Values
  ## are of the form `projects/<project>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579192 = newJObject()
  var query_579193 = newJObject()
  var body_579194 = newJObject()
  add(query_579193, "key", newJString(key))
  add(query_579193, "prettyPrint", newJBool(prettyPrint))
  add(query_579193, "oauth_token", newJString(oauthToken))
  add(query_579193, "$.xgafv", newJString(Xgafv))
  add(query_579193, "alt", newJString(alt))
  add(query_579193, "uploadType", newJString(uploadType))
  add(query_579193, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579194 = body
  add(query_579193, "callback", newJString(callback))
  add(path_579192, "parent", newJString(parent))
  add(query_579193, "fields", newJString(fields))
  add(query_579193, "access_token", newJString(accessToken))
  add(query_579193, "upload_protocol", newJString(uploadProtocol))
  result = call_579191.call(path_579192, query_579193, nil, nil, body_579194)

var spannerProjectsInstancesCreate* = Call_SpannerProjectsInstancesCreate_579174(
    name: "spannerProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesCreate_579175, base: "/",
    url: url_SpannerProjectsInstancesCreate_579176, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesList_579152 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesList_579154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesList_579153(path: JsonNode; query: JsonNode;
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
  var valid_579155 = path.getOrDefault("parent")
  valid_579155 = validateParameter(valid_579155, JString, required = true,
                                 default = nil)
  if valid_579155 != nil:
    section.add "parent", valid_579155
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   pageSize: JInt
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: JString
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579156 = query.getOrDefault("key")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "key", valid_579156
  var valid_579157 = query.getOrDefault("prettyPrint")
  valid_579157 = validateParameter(valid_579157, JBool, required = false,
                                 default = newJBool(true))
  if valid_579157 != nil:
    section.add "prettyPrint", valid_579157
  var valid_579158 = query.getOrDefault("oauth_token")
  valid_579158 = validateParameter(valid_579158, JString, required = false,
                                 default = nil)
  if valid_579158 != nil:
    section.add "oauth_token", valid_579158
  var valid_579159 = query.getOrDefault("$.xgafv")
  valid_579159 = validateParameter(valid_579159, JString, required = false,
                                 default = newJString("1"))
  if valid_579159 != nil:
    section.add "$.xgafv", valid_579159
  var valid_579160 = query.getOrDefault("pageSize")
  valid_579160 = validateParameter(valid_579160, JInt, required = false, default = nil)
  if valid_579160 != nil:
    section.add "pageSize", valid_579160
  var valid_579161 = query.getOrDefault("alt")
  valid_579161 = validateParameter(valid_579161, JString, required = false,
                                 default = newJString("json"))
  if valid_579161 != nil:
    section.add "alt", valid_579161
  var valid_579162 = query.getOrDefault("uploadType")
  valid_579162 = validateParameter(valid_579162, JString, required = false,
                                 default = nil)
  if valid_579162 != nil:
    section.add "uploadType", valid_579162
  var valid_579163 = query.getOrDefault("quotaUser")
  valid_579163 = validateParameter(valid_579163, JString, required = false,
                                 default = nil)
  if valid_579163 != nil:
    section.add "quotaUser", valid_579163
  var valid_579164 = query.getOrDefault("filter")
  valid_579164 = validateParameter(valid_579164, JString, required = false,
                                 default = nil)
  if valid_579164 != nil:
    section.add "filter", valid_579164
  var valid_579165 = query.getOrDefault("pageToken")
  valid_579165 = validateParameter(valid_579165, JString, required = false,
                                 default = nil)
  if valid_579165 != nil:
    section.add "pageToken", valid_579165
  var valid_579166 = query.getOrDefault("callback")
  valid_579166 = validateParameter(valid_579166, JString, required = false,
                                 default = nil)
  if valid_579166 != nil:
    section.add "callback", valid_579166
  var valid_579167 = query.getOrDefault("fields")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "fields", valid_579167
  var valid_579168 = query.getOrDefault("access_token")
  valid_579168 = validateParameter(valid_579168, JString, required = false,
                                 default = nil)
  if valid_579168 != nil:
    section.add "access_token", valid_579168
  var valid_579169 = query.getOrDefault("upload_protocol")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "upload_protocol", valid_579169
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579170: Call_SpannerProjectsInstancesList_579152; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists all instances in the given project.
  ## 
  let valid = call_579170.validator(path, query, header, formData, body)
  let scheme = call_579170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579170.url(scheme.get, call_579170.host, call_579170.base,
                         call_579170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579170, url, valid)

proc call*(call_579171: Call_SpannerProjectsInstancesList_579152; parent: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; pageSize: int = 0; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; filter: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesList
  ## Lists all instances in the given project.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Number of instances to be returned in the response. If 0 or less, defaults
  ## to the server's maximum allowed page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
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
  ##   pageToken: string
  ##            : If non-empty, `page_token` should contain a
  ## next_page_token from a
  ## previous ListInstancesResponse.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : Required. The name of the project for which a list of instances is
  ## requested. Values are of the form `projects/<project>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579172 = newJObject()
  var query_579173 = newJObject()
  add(query_579173, "key", newJString(key))
  add(query_579173, "prettyPrint", newJBool(prettyPrint))
  add(query_579173, "oauth_token", newJString(oauthToken))
  add(query_579173, "$.xgafv", newJString(Xgafv))
  add(query_579173, "pageSize", newJInt(pageSize))
  add(query_579173, "alt", newJString(alt))
  add(query_579173, "uploadType", newJString(uploadType))
  add(query_579173, "quotaUser", newJString(quotaUser))
  add(query_579173, "filter", newJString(filter))
  add(query_579173, "pageToken", newJString(pageToken))
  add(query_579173, "callback", newJString(callback))
  add(path_579172, "parent", newJString(parent))
  add(query_579173, "fields", newJString(fields))
  add(query_579173, "access_token", newJString(accessToken))
  add(query_579173, "upload_protocol", newJString(uploadProtocol))
  result = call_579171.call(path_579172, query_579173, nil, nil, nil)

var spannerProjectsInstancesList* = Call_SpannerProjectsInstancesList_579152(
    name: "spannerProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "spanner.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_SpannerProjectsInstancesList_579153, base: "/",
    url: url_SpannerProjectsInstancesList_579154, schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesGetIamPolicy_579195 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesGetIamPolicy_579197(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesGetIamPolicy_579196(
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
  var valid_579198 = path.getOrDefault("resource")
  valid_579198 = validateParameter(valid_579198, JString, required = true,
                                 default = nil)
  if valid_579198 != nil:
    section.add "resource", valid_579198
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579199 = query.getOrDefault("key")
  valid_579199 = validateParameter(valid_579199, JString, required = false,
                                 default = nil)
  if valid_579199 != nil:
    section.add "key", valid_579199
  var valid_579200 = query.getOrDefault("prettyPrint")
  valid_579200 = validateParameter(valid_579200, JBool, required = false,
                                 default = newJBool(true))
  if valid_579200 != nil:
    section.add "prettyPrint", valid_579200
  var valid_579201 = query.getOrDefault("oauth_token")
  valid_579201 = validateParameter(valid_579201, JString, required = false,
                                 default = nil)
  if valid_579201 != nil:
    section.add "oauth_token", valid_579201
  var valid_579202 = query.getOrDefault("$.xgafv")
  valid_579202 = validateParameter(valid_579202, JString, required = false,
                                 default = newJString("1"))
  if valid_579202 != nil:
    section.add "$.xgafv", valid_579202
  var valid_579203 = query.getOrDefault("alt")
  valid_579203 = validateParameter(valid_579203, JString, required = false,
                                 default = newJString("json"))
  if valid_579203 != nil:
    section.add "alt", valid_579203
  var valid_579204 = query.getOrDefault("uploadType")
  valid_579204 = validateParameter(valid_579204, JString, required = false,
                                 default = nil)
  if valid_579204 != nil:
    section.add "uploadType", valid_579204
  var valid_579205 = query.getOrDefault("quotaUser")
  valid_579205 = validateParameter(valid_579205, JString, required = false,
                                 default = nil)
  if valid_579205 != nil:
    section.add "quotaUser", valid_579205
  var valid_579206 = query.getOrDefault("callback")
  valid_579206 = validateParameter(valid_579206, JString, required = false,
                                 default = nil)
  if valid_579206 != nil:
    section.add "callback", valid_579206
  var valid_579207 = query.getOrDefault("fields")
  valid_579207 = validateParameter(valid_579207, JString, required = false,
                                 default = nil)
  if valid_579207 != nil:
    section.add "fields", valid_579207
  var valid_579208 = query.getOrDefault("access_token")
  valid_579208 = validateParameter(valid_579208, JString, required = false,
                                 default = nil)
  if valid_579208 != nil:
    section.add "access_token", valid_579208
  var valid_579209 = query.getOrDefault("upload_protocol")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "upload_protocol", valid_579209
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

proc call*(call_579211: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_579195;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ## 
  let valid = call_579211.validator(path, query, header, formData, body)
  let scheme = call_579211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579211.url(scheme.get, call_579211.host, call_579211.base,
                         call_579211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579211, url, valid)

proc call*(call_579212: Call_SpannerProjectsInstancesDatabasesGetIamPolicy_579195;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesGetIamPolicy
  ## Gets the access control policy for a database resource.
  ## Returns an empty policy if a database exists but does
  ## not have a policy set.
  ## 
  ## Authorization requires `spanner.databases.getIamPolicy` permission on
  ## resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being retrieved. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579213 = newJObject()
  var query_579214 = newJObject()
  var body_579215 = newJObject()
  add(query_579214, "key", newJString(key))
  add(query_579214, "prettyPrint", newJBool(prettyPrint))
  add(query_579214, "oauth_token", newJString(oauthToken))
  add(query_579214, "$.xgafv", newJString(Xgafv))
  add(query_579214, "alt", newJString(alt))
  add(query_579214, "uploadType", newJString(uploadType))
  add(query_579214, "quotaUser", newJString(quotaUser))
  add(path_579213, "resource", newJString(resource))
  if body != nil:
    body_579215 = body
  add(query_579214, "callback", newJString(callback))
  add(query_579214, "fields", newJString(fields))
  add(query_579214, "access_token", newJString(accessToken))
  add(query_579214, "upload_protocol", newJString(uploadProtocol))
  result = call_579212.call(path_579213, query_579214, nil, nil, body_579215)

var spannerProjectsInstancesDatabasesGetIamPolicy* = Call_SpannerProjectsInstancesDatabasesGetIamPolicy_579195(
    name: "spannerProjectsInstancesDatabasesGetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:getIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesGetIamPolicy_579196,
    base: "/", url: url_SpannerProjectsInstancesDatabasesGetIamPolicy_579197,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSetIamPolicy_579216 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSetIamPolicy_579218(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSetIamPolicy_579217(
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
  var valid_579219 = path.getOrDefault("resource")
  valid_579219 = validateParameter(valid_579219, JString, required = true,
                                 default = nil)
  if valid_579219 != nil:
    section.add "resource", valid_579219
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579220 = query.getOrDefault("key")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "key", valid_579220
  var valid_579221 = query.getOrDefault("prettyPrint")
  valid_579221 = validateParameter(valid_579221, JBool, required = false,
                                 default = newJBool(true))
  if valid_579221 != nil:
    section.add "prettyPrint", valid_579221
  var valid_579222 = query.getOrDefault("oauth_token")
  valid_579222 = validateParameter(valid_579222, JString, required = false,
                                 default = nil)
  if valid_579222 != nil:
    section.add "oauth_token", valid_579222
  var valid_579223 = query.getOrDefault("$.xgafv")
  valid_579223 = validateParameter(valid_579223, JString, required = false,
                                 default = newJString("1"))
  if valid_579223 != nil:
    section.add "$.xgafv", valid_579223
  var valid_579224 = query.getOrDefault("alt")
  valid_579224 = validateParameter(valid_579224, JString, required = false,
                                 default = newJString("json"))
  if valid_579224 != nil:
    section.add "alt", valid_579224
  var valid_579225 = query.getOrDefault("uploadType")
  valid_579225 = validateParameter(valid_579225, JString, required = false,
                                 default = nil)
  if valid_579225 != nil:
    section.add "uploadType", valid_579225
  var valid_579226 = query.getOrDefault("quotaUser")
  valid_579226 = validateParameter(valid_579226, JString, required = false,
                                 default = nil)
  if valid_579226 != nil:
    section.add "quotaUser", valid_579226
  var valid_579227 = query.getOrDefault("callback")
  valid_579227 = validateParameter(valid_579227, JString, required = false,
                                 default = nil)
  if valid_579227 != nil:
    section.add "callback", valid_579227
  var valid_579228 = query.getOrDefault("fields")
  valid_579228 = validateParameter(valid_579228, JString, required = false,
                                 default = nil)
  if valid_579228 != nil:
    section.add "fields", valid_579228
  var valid_579229 = query.getOrDefault("access_token")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "access_token", valid_579229
  var valid_579230 = query.getOrDefault("upload_protocol")
  valid_579230 = validateParameter(valid_579230, JString, required = false,
                                 default = nil)
  if valid_579230 != nil:
    section.add "upload_protocol", valid_579230
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

proc call*(call_579232: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_579216;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ## 
  let valid = call_579232.validator(path, query, header, formData, body)
  let scheme = call_579232.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579232.url(scheme.get, call_579232.host, call_579232.base,
                         call_579232.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579232, url, valid)

proc call*(call_579233: Call_SpannerProjectsInstancesDatabasesSetIamPolicy_579216;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSetIamPolicy
  ## Sets the access control policy on a database resource.
  ## Replaces any existing policy.
  ## 
  ## Authorization requires `spanner.databases.setIamPolicy`
  ## permission on resource.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which the policy is being set. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for databases resources.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579234 = newJObject()
  var query_579235 = newJObject()
  var body_579236 = newJObject()
  add(query_579235, "key", newJString(key))
  add(query_579235, "prettyPrint", newJBool(prettyPrint))
  add(query_579235, "oauth_token", newJString(oauthToken))
  add(query_579235, "$.xgafv", newJString(Xgafv))
  add(query_579235, "alt", newJString(alt))
  add(query_579235, "uploadType", newJString(uploadType))
  add(query_579235, "quotaUser", newJString(quotaUser))
  add(path_579234, "resource", newJString(resource))
  if body != nil:
    body_579236 = body
  add(query_579235, "callback", newJString(callback))
  add(query_579235, "fields", newJString(fields))
  add(query_579235, "access_token", newJString(accessToken))
  add(query_579235, "upload_protocol", newJString(uploadProtocol))
  result = call_579233.call(path_579234, query_579235, nil, nil, body_579236)

var spannerProjectsInstancesDatabasesSetIamPolicy* = Call_SpannerProjectsInstancesDatabasesSetIamPolicy_579216(
    name: "spannerProjectsInstancesDatabasesSetIamPolicy",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:setIamPolicy",
    validator: validate_SpannerProjectsInstancesDatabasesSetIamPolicy_579217,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSetIamPolicy_579218,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesTestIamPermissions_579237 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesTestIamPermissions_579239(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesTestIamPermissions_579238(
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
  var valid_579240 = path.getOrDefault("resource")
  valid_579240 = validateParameter(valid_579240, JString, required = true,
                                 default = nil)
  if valid_579240 != nil:
    section.add "resource", valid_579240
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579241 = query.getOrDefault("key")
  valid_579241 = validateParameter(valid_579241, JString, required = false,
                                 default = nil)
  if valid_579241 != nil:
    section.add "key", valid_579241
  var valid_579242 = query.getOrDefault("prettyPrint")
  valid_579242 = validateParameter(valid_579242, JBool, required = false,
                                 default = newJBool(true))
  if valid_579242 != nil:
    section.add "prettyPrint", valid_579242
  var valid_579243 = query.getOrDefault("oauth_token")
  valid_579243 = validateParameter(valid_579243, JString, required = false,
                                 default = nil)
  if valid_579243 != nil:
    section.add "oauth_token", valid_579243
  var valid_579244 = query.getOrDefault("$.xgafv")
  valid_579244 = validateParameter(valid_579244, JString, required = false,
                                 default = newJString("1"))
  if valid_579244 != nil:
    section.add "$.xgafv", valid_579244
  var valid_579245 = query.getOrDefault("alt")
  valid_579245 = validateParameter(valid_579245, JString, required = false,
                                 default = newJString("json"))
  if valid_579245 != nil:
    section.add "alt", valid_579245
  var valid_579246 = query.getOrDefault("uploadType")
  valid_579246 = validateParameter(valid_579246, JString, required = false,
                                 default = nil)
  if valid_579246 != nil:
    section.add "uploadType", valid_579246
  var valid_579247 = query.getOrDefault("quotaUser")
  valid_579247 = validateParameter(valid_579247, JString, required = false,
                                 default = nil)
  if valid_579247 != nil:
    section.add "quotaUser", valid_579247
  var valid_579248 = query.getOrDefault("callback")
  valid_579248 = validateParameter(valid_579248, JString, required = false,
                                 default = nil)
  if valid_579248 != nil:
    section.add "callback", valid_579248
  var valid_579249 = query.getOrDefault("fields")
  valid_579249 = validateParameter(valid_579249, JString, required = false,
                                 default = nil)
  if valid_579249 != nil:
    section.add "fields", valid_579249
  var valid_579250 = query.getOrDefault("access_token")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "access_token", valid_579250
  var valid_579251 = query.getOrDefault("upload_protocol")
  valid_579251 = validateParameter(valid_579251, JString, required = false,
                                 default = nil)
  if valid_579251 != nil:
    section.add "upload_protocol", valid_579251
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

proc call*(call_579253: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_579237;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ## 
  let valid = call_579253.validator(path, query, header, formData, body)
  let scheme = call_579253.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579253.url(scheme.get, call_579253.host, call_579253.base,
                         call_579253.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579253, url, valid)

proc call*(call_579254: Call_SpannerProjectsInstancesDatabasesTestIamPermissions_579237;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesTestIamPermissions
  ## Returns permissions that the caller has on the specified database resource.
  ## 
  ## Attempting this RPC on a non-existent Cloud Spanner database will
  ## result in a NOT_FOUND error if the user has
  ## `spanner.databases.list` permission on the containing Cloud
  ## Spanner instance. Otherwise returns an empty set of permissions.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   resource: string (required)
  ##           : REQUIRED: The Cloud Spanner resource for which permissions are being tested. The format is `projects/<project ID>/instances/<instance ID>` for instance resources and `projects/<project ID>/instances/<instance ID>/databases/<database ID>` for database resources.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579255 = newJObject()
  var query_579256 = newJObject()
  var body_579257 = newJObject()
  add(query_579256, "key", newJString(key))
  add(query_579256, "prettyPrint", newJBool(prettyPrint))
  add(query_579256, "oauth_token", newJString(oauthToken))
  add(query_579256, "$.xgafv", newJString(Xgafv))
  add(query_579256, "alt", newJString(alt))
  add(query_579256, "uploadType", newJString(uploadType))
  add(query_579256, "quotaUser", newJString(quotaUser))
  add(path_579255, "resource", newJString(resource))
  if body != nil:
    body_579257 = body
  add(query_579256, "callback", newJString(callback))
  add(query_579256, "fields", newJString(fields))
  add(query_579256, "access_token", newJString(accessToken))
  add(query_579256, "upload_protocol", newJString(uploadProtocol))
  result = call_579254.call(path_579255, query_579256, nil, nil, body_579257)

var spannerProjectsInstancesDatabasesTestIamPermissions* = Call_SpannerProjectsInstancesDatabasesTestIamPermissions_579237(
    name: "spannerProjectsInstancesDatabasesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{resource}:testIamPermissions",
    validator: validate_SpannerProjectsInstancesDatabasesTestIamPermissions_579238,
    base: "/", url: url_SpannerProjectsInstancesDatabasesTestIamPermissions_579239,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579258 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579260(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579259(
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
  var valid_579261 = path.getOrDefault("session")
  valid_579261 = validateParameter(valid_579261, JString, required = true,
                                 default = nil)
  if valid_579261 != nil:
    section.add "session", valid_579261
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579262 = query.getOrDefault("key")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "key", valid_579262
  var valid_579263 = query.getOrDefault("prettyPrint")
  valid_579263 = validateParameter(valid_579263, JBool, required = false,
                                 default = newJBool(true))
  if valid_579263 != nil:
    section.add "prettyPrint", valid_579263
  var valid_579264 = query.getOrDefault("oauth_token")
  valid_579264 = validateParameter(valid_579264, JString, required = false,
                                 default = nil)
  if valid_579264 != nil:
    section.add "oauth_token", valid_579264
  var valid_579265 = query.getOrDefault("$.xgafv")
  valid_579265 = validateParameter(valid_579265, JString, required = false,
                                 default = newJString("1"))
  if valid_579265 != nil:
    section.add "$.xgafv", valid_579265
  var valid_579266 = query.getOrDefault("alt")
  valid_579266 = validateParameter(valid_579266, JString, required = false,
                                 default = newJString("json"))
  if valid_579266 != nil:
    section.add "alt", valid_579266
  var valid_579267 = query.getOrDefault("uploadType")
  valid_579267 = validateParameter(valid_579267, JString, required = false,
                                 default = nil)
  if valid_579267 != nil:
    section.add "uploadType", valid_579267
  var valid_579268 = query.getOrDefault("quotaUser")
  valid_579268 = validateParameter(valid_579268, JString, required = false,
                                 default = nil)
  if valid_579268 != nil:
    section.add "quotaUser", valid_579268
  var valid_579269 = query.getOrDefault("callback")
  valid_579269 = validateParameter(valid_579269, JString, required = false,
                                 default = nil)
  if valid_579269 != nil:
    section.add "callback", valid_579269
  var valid_579270 = query.getOrDefault("fields")
  valid_579270 = validateParameter(valid_579270, JString, required = false,
                                 default = nil)
  if valid_579270 != nil:
    section.add "fields", valid_579270
  var valid_579271 = query.getOrDefault("access_token")
  valid_579271 = validateParameter(valid_579271, JString, required = false,
                                 default = nil)
  if valid_579271 != nil:
    section.add "access_token", valid_579271
  var valid_579272 = query.getOrDefault("upload_protocol")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "upload_protocol", valid_579272
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

proc call*(call_579274: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ## 
  let valid = call_579274.validator(path, query, header, formData, body)
  let scheme = call_579274.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579274.url(scheme.get, call_579274.host, call_579274.base,
                         call_579274.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579274, url, valid)

proc call*(call_579275: Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579258;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsBeginTransaction
  ## Begins a new transaction. This step can often be skipped:
  ## Read, ExecuteSql and
  ## Commit can begin a new transaction as a
  ## side-effect.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the transaction runs.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579276 = newJObject()
  var query_579277 = newJObject()
  var body_579278 = newJObject()
  add(query_579277, "key", newJString(key))
  add(query_579277, "prettyPrint", newJBool(prettyPrint))
  add(query_579277, "oauth_token", newJString(oauthToken))
  add(query_579277, "$.xgafv", newJString(Xgafv))
  add(query_579277, "alt", newJString(alt))
  add(query_579277, "uploadType", newJString(uploadType))
  add(query_579277, "quotaUser", newJString(quotaUser))
  add(path_579276, "session", newJString(session))
  if body != nil:
    body_579278 = body
  add(query_579277, "callback", newJString(callback))
  add(query_579277, "fields", newJString(fields))
  add(query_579277, "access_token", newJString(accessToken))
  add(query_579277, "upload_protocol", newJString(uploadProtocol))
  result = call_579275.call(path_579276, query_579277, nil, nil, body_579278)

var spannerProjectsInstancesDatabasesSessionsBeginTransaction* = Call_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579258(
    name: "spannerProjectsInstancesDatabasesSessionsBeginTransaction",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:beginTransaction", validator: validate_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579259,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsBeginTransaction_579260,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsCommit_579279 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsCommit_579281(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsCommit_579280(
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
  var valid_579282 = path.getOrDefault("session")
  valid_579282 = validateParameter(valid_579282, JString, required = true,
                                 default = nil)
  if valid_579282 != nil:
    section.add "session", valid_579282
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579283 = query.getOrDefault("key")
  valid_579283 = validateParameter(valid_579283, JString, required = false,
                                 default = nil)
  if valid_579283 != nil:
    section.add "key", valid_579283
  var valid_579284 = query.getOrDefault("prettyPrint")
  valid_579284 = validateParameter(valid_579284, JBool, required = false,
                                 default = newJBool(true))
  if valid_579284 != nil:
    section.add "prettyPrint", valid_579284
  var valid_579285 = query.getOrDefault("oauth_token")
  valid_579285 = validateParameter(valid_579285, JString, required = false,
                                 default = nil)
  if valid_579285 != nil:
    section.add "oauth_token", valid_579285
  var valid_579286 = query.getOrDefault("$.xgafv")
  valid_579286 = validateParameter(valid_579286, JString, required = false,
                                 default = newJString("1"))
  if valid_579286 != nil:
    section.add "$.xgafv", valid_579286
  var valid_579287 = query.getOrDefault("alt")
  valid_579287 = validateParameter(valid_579287, JString, required = false,
                                 default = newJString("json"))
  if valid_579287 != nil:
    section.add "alt", valid_579287
  var valid_579288 = query.getOrDefault("uploadType")
  valid_579288 = validateParameter(valid_579288, JString, required = false,
                                 default = nil)
  if valid_579288 != nil:
    section.add "uploadType", valid_579288
  var valid_579289 = query.getOrDefault("quotaUser")
  valid_579289 = validateParameter(valid_579289, JString, required = false,
                                 default = nil)
  if valid_579289 != nil:
    section.add "quotaUser", valid_579289
  var valid_579290 = query.getOrDefault("callback")
  valid_579290 = validateParameter(valid_579290, JString, required = false,
                                 default = nil)
  if valid_579290 != nil:
    section.add "callback", valid_579290
  var valid_579291 = query.getOrDefault("fields")
  valid_579291 = validateParameter(valid_579291, JString, required = false,
                                 default = nil)
  if valid_579291 != nil:
    section.add "fields", valid_579291
  var valid_579292 = query.getOrDefault("access_token")
  valid_579292 = validateParameter(valid_579292, JString, required = false,
                                 default = nil)
  if valid_579292 != nil:
    section.add "access_token", valid_579292
  var valid_579293 = query.getOrDefault("upload_protocol")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "upload_protocol", valid_579293
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

proc call*(call_579295: Call_SpannerProjectsInstancesDatabasesSessionsCommit_579279;
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
  let valid = call_579295.validator(path, query, header, formData, body)
  let scheme = call_579295.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579295.url(scheme.get, call_579295.host, call_579295.base,
                         call_579295.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579295, url, valid)

proc call*(call_579296: Call_SpannerProjectsInstancesDatabasesSessionsCommit_579279;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsCommit
  ## Commits a transaction. The request includes the mutations to be
  ## applied to rows in the database.
  ## 
  ## `Commit` might return an `ABORTED` error. This can occur at any time;
  ## commonly, the cause is conflicts with concurrent
  ## transactions. However, it can also happen for a variety of other
  ## reasons. If `Commit` returns `ABORTED`, the caller should re-attempt
  ## the transaction from the beginning, re-using the same session.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the transaction to be committed is running.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579297 = newJObject()
  var query_579298 = newJObject()
  var body_579299 = newJObject()
  add(query_579298, "key", newJString(key))
  add(query_579298, "prettyPrint", newJBool(prettyPrint))
  add(query_579298, "oauth_token", newJString(oauthToken))
  add(query_579298, "$.xgafv", newJString(Xgafv))
  add(query_579298, "alt", newJString(alt))
  add(query_579298, "uploadType", newJString(uploadType))
  add(query_579298, "quotaUser", newJString(quotaUser))
  add(path_579297, "session", newJString(session))
  if body != nil:
    body_579299 = body
  add(query_579298, "callback", newJString(callback))
  add(query_579298, "fields", newJString(fields))
  add(query_579298, "access_token", newJString(accessToken))
  add(query_579298, "upload_protocol", newJString(uploadProtocol))
  result = call_579296.call(path_579297, query_579298, nil, nil, body_579299)

var spannerProjectsInstancesDatabasesSessionsCommit* = Call_SpannerProjectsInstancesDatabasesSessionsCommit_579279(
    name: "spannerProjectsInstancesDatabasesSessionsCommit",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:commit",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsCommit_579280,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsCommit_579281,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579300 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579302(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579301(
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
  var valid_579303 = path.getOrDefault("session")
  valid_579303 = validateParameter(valid_579303, JString, required = true,
                                 default = nil)
  if valid_579303 != nil:
    section.add "session", valid_579303
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579304 = query.getOrDefault("key")
  valid_579304 = validateParameter(valid_579304, JString, required = false,
                                 default = nil)
  if valid_579304 != nil:
    section.add "key", valid_579304
  var valid_579305 = query.getOrDefault("prettyPrint")
  valid_579305 = validateParameter(valid_579305, JBool, required = false,
                                 default = newJBool(true))
  if valid_579305 != nil:
    section.add "prettyPrint", valid_579305
  var valid_579306 = query.getOrDefault("oauth_token")
  valid_579306 = validateParameter(valid_579306, JString, required = false,
                                 default = nil)
  if valid_579306 != nil:
    section.add "oauth_token", valid_579306
  var valid_579307 = query.getOrDefault("$.xgafv")
  valid_579307 = validateParameter(valid_579307, JString, required = false,
                                 default = newJString("1"))
  if valid_579307 != nil:
    section.add "$.xgafv", valid_579307
  var valid_579308 = query.getOrDefault("alt")
  valid_579308 = validateParameter(valid_579308, JString, required = false,
                                 default = newJString("json"))
  if valid_579308 != nil:
    section.add "alt", valid_579308
  var valid_579309 = query.getOrDefault("uploadType")
  valid_579309 = validateParameter(valid_579309, JString, required = false,
                                 default = nil)
  if valid_579309 != nil:
    section.add "uploadType", valid_579309
  var valid_579310 = query.getOrDefault("quotaUser")
  valid_579310 = validateParameter(valid_579310, JString, required = false,
                                 default = nil)
  if valid_579310 != nil:
    section.add "quotaUser", valid_579310
  var valid_579311 = query.getOrDefault("callback")
  valid_579311 = validateParameter(valid_579311, JString, required = false,
                                 default = nil)
  if valid_579311 != nil:
    section.add "callback", valid_579311
  var valid_579312 = query.getOrDefault("fields")
  valid_579312 = validateParameter(valid_579312, JString, required = false,
                                 default = nil)
  if valid_579312 != nil:
    section.add "fields", valid_579312
  var valid_579313 = query.getOrDefault("access_token")
  valid_579313 = validateParameter(valid_579313, JString, required = false,
                                 default = nil)
  if valid_579313 != nil:
    section.add "access_token", valid_579313
  var valid_579314 = query.getOrDefault("upload_protocol")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "upload_protocol", valid_579314
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

proc call*(call_579316: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579300;
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
  let valid = call_579316.validator(path, query, header, formData, body)
  let scheme = call_579316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579316.url(scheme.get, call_579316.host, call_579316.base,
                         call_579316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579316, url, valid)

proc call*(call_579317: Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579300;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the DML statements should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579318 = newJObject()
  var query_579319 = newJObject()
  var body_579320 = newJObject()
  add(query_579319, "key", newJString(key))
  add(query_579319, "prettyPrint", newJBool(prettyPrint))
  add(query_579319, "oauth_token", newJString(oauthToken))
  add(query_579319, "$.xgafv", newJString(Xgafv))
  add(query_579319, "alt", newJString(alt))
  add(query_579319, "uploadType", newJString(uploadType))
  add(query_579319, "quotaUser", newJString(quotaUser))
  add(path_579318, "session", newJString(session))
  if body != nil:
    body_579320 = body
  add(query_579319, "callback", newJString(callback))
  add(query_579319, "fields", newJString(fields))
  add(query_579319, "access_token", newJString(accessToken))
  add(query_579319, "upload_protocol", newJString(uploadProtocol))
  result = call_579317.call(path_579318, query_579319, nil, nil, body_579320)

var spannerProjectsInstancesDatabasesSessionsExecuteBatchDml* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579300(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteBatchDml",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeBatchDml", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579301,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteBatchDml_579302,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579321 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579323(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579322(
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
  var valid_579324 = path.getOrDefault("session")
  valid_579324 = validateParameter(valid_579324, JString, required = true,
                                 default = nil)
  if valid_579324 != nil:
    section.add "session", valid_579324
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579325 = query.getOrDefault("key")
  valid_579325 = validateParameter(valid_579325, JString, required = false,
                                 default = nil)
  if valid_579325 != nil:
    section.add "key", valid_579325
  var valid_579326 = query.getOrDefault("prettyPrint")
  valid_579326 = validateParameter(valid_579326, JBool, required = false,
                                 default = newJBool(true))
  if valid_579326 != nil:
    section.add "prettyPrint", valid_579326
  var valid_579327 = query.getOrDefault("oauth_token")
  valid_579327 = validateParameter(valid_579327, JString, required = false,
                                 default = nil)
  if valid_579327 != nil:
    section.add "oauth_token", valid_579327
  var valid_579328 = query.getOrDefault("$.xgafv")
  valid_579328 = validateParameter(valid_579328, JString, required = false,
                                 default = newJString("1"))
  if valid_579328 != nil:
    section.add "$.xgafv", valid_579328
  var valid_579329 = query.getOrDefault("alt")
  valid_579329 = validateParameter(valid_579329, JString, required = false,
                                 default = newJString("json"))
  if valid_579329 != nil:
    section.add "alt", valid_579329
  var valid_579330 = query.getOrDefault("uploadType")
  valid_579330 = validateParameter(valid_579330, JString, required = false,
                                 default = nil)
  if valid_579330 != nil:
    section.add "uploadType", valid_579330
  var valid_579331 = query.getOrDefault("quotaUser")
  valid_579331 = validateParameter(valid_579331, JString, required = false,
                                 default = nil)
  if valid_579331 != nil:
    section.add "quotaUser", valid_579331
  var valid_579332 = query.getOrDefault("callback")
  valid_579332 = validateParameter(valid_579332, JString, required = false,
                                 default = nil)
  if valid_579332 != nil:
    section.add "callback", valid_579332
  var valid_579333 = query.getOrDefault("fields")
  valid_579333 = validateParameter(valid_579333, JString, required = false,
                                 default = nil)
  if valid_579333 != nil:
    section.add "fields", valid_579333
  var valid_579334 = query.getOrDefault("access_token")
  valid_579334 = validateParameter(valid_579334, JString, required = false,
                                 default = nil)
  if valid_579334 != nil:
    section.add "access_token", valid_579334
  var valid_579335 = query.getOrDefault("upload_protocol")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "upload_protocol", valid_579335
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

proc call*(call_579337: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579321;
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
  let valid = call_579337.validator(path, query, header, formData, body)
  let scheme = call_579337.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579337.url(scheme.get, call_579337.host, call_579337.base,
                         call_579337.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579337, url, valid)

proc call*(call_579338: Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579321;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579339 = newJObject()
  var query_579340 = newJObject()
  var body_579341 = newJObject()
  add(query_579340, "key", newJString(key))
  add(query_579340, "prettyPrint", newJBool(prettyPrint))
  add(query_579340, "oauth_token", newJString(oauthToken))
  add(query_579340, "$.xgafv", newJString(Xgafv))
  add(query_579340, "alt", newJString(alt))
  add(query_579340, "uploadType", newJString(uploadType))
  add(query_579340, "quotaUser", newJString(quotaUser))
  add(path_579339, "session", newJString(session))
  if body != nil:
    body_579341 = body
  add(query_579340, "callback", newJString(callback))
  add(query_579340, "fields", newJString(fields))
  add(query_579340, "access_token", newJString(accessToken))
  add(query_579340, "upload_protocol", newJString(uploadProtocol))
  result = call_579338.call(path_579339, query_579340, nil, nil, body_579341)

var spannerProjectsInstancesDatabasesSessionsExecuteSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579321(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeSql",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579322,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsExecuteSql_579323,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579342 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579344(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579343(
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
  var valid_579345 = path.getOrDefault("session")
  valid_579345 = validateParameter(valid_579345, JString, required = true,
                                 default = nil)
  if valid_579345 != nil:
    section.add "session", valid_579345
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579346 = query.getOrDefault("key")
  valid_579346 = validateParameter(valid_579346, JString, required = false,
                                 default = nil)
  if valid_579346 != nil:
    section.add "key", valid_579346
  var valid_579347 = query.getOrDefault("prettyPrint")
  valid_579347 = validateParameter(valid_579347, JBool, required = false,
                                 default = newJBool(true))
  if valid_579347 != nil:
    section.add "prettyPrint", valid_579347
  var valid_579348 = query.getOrDefault("oauth_token")
  valid_579348 = validateParameter(valid_579348, JString, required = false,
                                 default = nil)
  if valid_579348 != nil:
    section.add "oauth_token", valid_579348
  var valid_579349 = query.getOrDefault("$.xgafv")
  valid_579349 = validateParameter(valid_579349, JString, required = false,
                                 default = newJString("1"))
  if valid_579349 != nil:
    section.add "$.xgafv", valid_579349
  var valid_579350 = query.getOrDefault("alt")
  valid_579350 = validateParameter(valid_579350, JString, required = false,
                                 default = newJString("json"))
  if valid_579350 != nil:
    section.add "alt", valid_579350
  var valid_579351 = query.getOrDefault("uploadType")
  valid_579351 = validateParameter(valid_579351, JString, required = false,
                                 default = nil)
  if valid_579351 != nil:
    section.add "uploadType", valid_579351
  var valid_579352 = query.getOrDefault("quotaUser")
  valid_579352 = validateParameter(valid_579352, JString, required = false,
                                 default = nil)
  if valid_579352 != nil:
    section.add "quotaUser", valid_579352
  var valid_579353 = query.getOrDefault("callback")
  valid_579353 = validateParameter(valid_579353, JString, required = false,
                                 default = nil)
  if valid_579353 != nil:
    section.add "callback", valid_579353
  var valid_579354 = query.getOrDefault("fields")
  valid_579354 = validateParameter(valid_579354, JString, required = false,
                                 default = nil)
  if valid_579354 != nil:
    section.add "fields", valid_579354
  var valid_579355 = query.getOrDefault("access_token")
  valid_579355 = validateParameter(valid_579355, JString, required = false,
                                 default = nil)
  if valid_579355 != nil:
    section.add "access_token", valid_579355
  var valid_579356 = query.getOrDefault("upload_protocol")
  valid_579356 = validateParameter(valid_579356, JString, required = false,
                                 default = nil)
  if valid_579356 != nil:
    section.add "upload_protocol", valid_579356
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

proc call*(call_579358: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579342;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ## 
  let valid = call_579358.validator(path, query, header, formData, body)
  let scheme = call_579358.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579358.url(scheme.get, call_579358.host, call_579358.base,
                         call_579358.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579358, url, valid)

proc call*(call_579359: Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579342;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql
  ## Like ExecuteSql, except returns the result
  ## set as a stream. Unlike ExecuteSql, there
  ## is no limit on the size of the returned result set. However, no
  ## individual row in the result set can exceed 100 MiB, and no
  ## column value can exceed 10 MiB.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the SQL query should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579360 = newJObject()
  var query_579361 = newJObject()
  var body_579362 = newJObject()
  add(query_579361, "key", newJString(key))
  add(query_579361, "prettyPrint", newJBool(prettyPrint))
  add(query_579361, "oauth_token", newJString(oauthToken))
  add(query_579361, "$.xgafv", newJString(Xgafv))
  add(query_579361, "alt", newJString(alt))
  add(query_579361, "uploadType", newJString(uploadType))
  add(query_579361, "quotaUser", newJString(quotaUser))
  add(path_579360, "session", newJString(session))
  if body != nil:
    body_579362 = body
  add(query_579361, "callback", newJString(callback))
  add(query_579361, "fields", newJString(fields))
  add(query_579361, "access_token", newJString(accessToken))
  add(query_579361, "upload_protocol", newJString(uploadProtocol))
  result = call_579359.call(path_579360, query_579361, nil, nil, body_579362)

var spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql* = Call_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579342(
    name: "spannerProjectsInstancesDatabasesSessionsExecuteStreamingSql",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:executeStreamingSql", validator: validate_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579343,
    base: "/",
    url: url_SpannerProjectsInstancesDatabasesSessionsExecuteStreamingSql_579344,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579363 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579365(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579364(
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
  var valid_579366 = path.getOrDefault("session")
  valid_579366 = validateParameter(valid_579366, JString, required = true,
                                 default = nil)
  if valid_579366 != nil:
    section.add "session", valid_579366
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579367 = query.getOrDefault("key")
  valid_579367 = validateParameter(valid_579367, JString, required = false,
                                 default = nil)
  if valid_579367 != nil:
    section.add "key", valid_579367
  var valid_579368 = query.getOrDefault("prettyPrint")
  valid_579368 = validateParameter(valid_579368, JBool, required = false,
                                 default = newJBool(true))
  if valid_579368 != nil:
    section.add "prettyPrint", valid_579368
  var valid_579369 = query.getOrDefault("oauth_token")
  valid_579369 = validateParameter(valid_579369, JString, required = false,
                                 default = nil)
  if valid_579369 != nil:
    section.add "oauth_token", valid_579369
  var valid_579370 = query.getOrDefault("$.xgafv")
  valid_579370 = validateParameter(valid_579370, JString, required = false,
                                 default = newJString("1"))
  if valid_579370 != nil:
    section.add "$.xgafv", valid_579370
  var valid_579371 = query.getOrDefault("alt")
  valid_579371 = validateParameter(valid_579371, JString, required = false,
                                 default = newJString("json"))
  if valid_579371 != nil:
    section.add "alt", valid_579371
  var valid_579372 = query.getOrDefault("uploadType")
  valid_579372 = validateParameter(valid_579372, JString, required = false,
                                 default = nil)
  if valid_579372 != nil:
    section.add "uploadType", valid_579372
  var valid_579373 = query.getOrDefault("quotaUser")
  valid_579373 = validateParameter(valid_579373, JString, required = false,
                                 default = nil)
  if valid_579373 != nil:
    section.add "quotaUser", valid_579373
  var valid_579374 = query.getOrDefault("callback")
  valid_579374 = validateParameter(valid_579374, JString, required = false,
                                 default = nil)
  if valid_579374 != nil:
    section.add "callback", valid_579374
  var valid_579375 = query.getOrDefault("fields")
  valid_579375 = validateParameter(valid_579375, JString, required = false,
                                 default = nil)
  if valid_579375 != nil:
    section.add "fields", valid_579375
  var valid_579376 = query.getOrDefault("access_token")
  valid_579376 = validateParameter(valid_579376, JString, required = false,
                                 default = nil)
  if valid_579376 != nil:
    section.add "access_token", valid_579376
  var valid_579377 = query.getOrDefault("upload_protocol")
  valid_579377 = validateParameter(valid_579377, JString, required = false,
                                 default = nil)
  if valid_579377 != nil:
    section.add "upload_protocol", valid_579377
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

proc call*(call_579379: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579363;
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
  let valid = call_579379.validator(path, query, header, formData, body)
  let scheme = call_579379.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579379.url(scheme.get, call_579379.host, call_579379.base,
                         call_579379.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579379, url, valid)

proc call*(call_579380: Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579363;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579381 = newJObject()
  var query_579382 = newJObject()
  var body_579383 = newJObject()
  add(query_579382, "key", newJString(key))
  add(query_579382, "prettyPrint", newJBool(prettyPrint))
  add(query_579382, "oauth_token", newJString(oauthToken))
  add(query_579382, "$.xgafv", newJString(Xgafv))
  add(query_579382, "alt", newJString(alt))
  add(query_579382, "uploadType", newJString(uploadType))
  add(query_579382, "quotaUser", newJString(quotaUser))
  add(path_579381, "session", newJString(session))
  if body != nil:
    body_579383 = body
  add(query_579382, "callback", newJString(callback))
  add(query_579382, "fields", newJString(fields))
  add(query_579382, "access_token", newJString(accessToken))
  add(query_579382, "upload_protocol", newJString(uploadProtocol))
  result = call_579380.call(path_579381, query_579382, nil, nil, body_579383)

var spannerProjectsInstancesDatabasesSessionsPartitionQuery* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579363(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionQuery",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionQuery", validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579364,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionQuery_579365,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579384 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579386(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579385(
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
  var valid_579387 = path.getOrDefault("session")
  valid_579387 = validateParameter(valid_579387, JString, required = true,
                                 default = nil)
  if valid_579387 != nil:
    section.add "session", valid_579387
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579388 = query.getOrDefault("key")
  valid_579388 = validateParameter(valid_579388, JString, required = false,
                                 default = nil)
  if valid_579388 != nil:
    section.add "key", valid_579388
  var valid_579389 = query.getOrDefault("prettyPrint")
  valid_579389 = validateParameter(valid_579389, JBool, required = false,
                                 default = newJBool(true))
  if valid_579389 != nil:
    section.add "prettyPrint", valid_579389
  var valid_579390 = query.getOrDefault("oauth_token")
  valid_579390 = validateParameter(valid_579390, JString, required = false,
                                 default = nil)
  if valid_579390 != nil:
    section.add "oauth_token", valid_579390
  var valid_579391 = query.getOrDefault("$.xgafv")
  valid_579391 = validateParameter(valid_579391, JString, required = false,
                                 default = newJString("1"))
  if valid_579391 != nil:
    section.add "$.xgafv", valid_579391
  var valid_579392 = query.getOrDefault("alt")
  valid_579392 = validateParameter(valid_579392, JString, required = false,
                                 default = newJString("json"))
  if valid_579392 != nil:
    section.add "alt", valid_579392
  var valid_579393 = query.getOrDefault("uploadType")
  valid_579393 = validateParameter(valid_579393, JString, required = false,
                                 default = nil)
  if valid_579393 != nil:
    section.add "uploadType", valid_579393
  var valid_579394 = query.getOrDefault("quotaUser")
  valid_579394 = validateParameter(valid_579394, JString, required = false,
                                 default = nil)
  if valid_579394 != nil:
    section.add "quotaUser", valid_579394
  var valid_579395 = query.getOrDefault("callback")
  valid_579395 = validateParameter(valid_579395, JString, required = false,
                                 default = nil)
  if valid_579395 != nil:
    section.add "callback", valid_579395
  var valid_579396 = query.getOrDefault("fields")
  valid_579396 = validateParameter(valid_579396, JString, required = false,
                                 default = nil)
  if valid_579396 != nil:
    section.add "fields", valid_579396
  var valid_579397 = query.getOrDefault("access_token")
  valid_579397 = validateParameter(valid_579397, JString, required = false,
                                 default = nil)
  if valid_579397 != nil:
    section.add "access_token", valid_579397
  var valid_579398 = query.getOrDefault("upload_protocol")
  valid_579398 = validateParameter(valid_579398, JString, required = false,
                                 default = nil)
  if valid_579398 != nil:
    section.add "upload_protocol", valid_579398
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

proc call*(call_579400: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579384;
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
  let valid = call_579400.validator(path, query, header, formData, body)
  let scheme = call_579400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579400.url(scheme.get, call_579400.host, call_579400.base,
                         call_579400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579400, url, valid)

proc call*(call_579401: Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579384;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session used to create the partitions.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579402 = newJObject()
  var query_579403 = newJObject()
  var body_579404 = newJObject()
  add(query_579403, "key", newJString(key))
  add(query_579403, "prettyPrint", newJBool(prettyPrint))
  add(query_579403, "oauth_token", newJString(oauthToken))
  add(query_579403, "$.xgafv", newJString(Xgafv))
  add(query_579403, "alt", newJString(alt))
  add(query_579403, "uploadType", newJString(uploadType))
  add(query_579403, "quotaUser", newJString(quotaUser))
  add(path_579402, "session", newJString(session))
  if body != nil:
    body_579404 = body
  add(query_579403, "callback", newJString(callback))
  add(query_579403, "fields", newJString(fields))
  add(query_579403, "access_token", newJString(accessToken))
  add(query_579403, "upload_protocol", newJString(uploadProtocol))
  result = call_579401.call(path_579402, query_579403, nil, nil, body_579404)

var spannerProjectsInstancesDatabasesSessionsPartitionRead* = Call_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579384(
    name: "spannerProjectsInstancesDatabasesSessionsPartitionRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:partitionRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579385,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsPartitionRead_579386,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRead_579405 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsRead_579407(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsRead_579406(
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
  var valid_579408 = path.getOrDefault("session")
  valid_579408 = validateParameter(valid_579408, JString, required = true,
                                 default = nil)
  if valid_579408 != nil:
    section.add "session", valid_579408
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579409 = query.getOrDefault("key")
  valid_579409 = validateParameter(valid_579409, JString, required = false,
                                 default = nil)
  if valid_579409 != nil:
    section.add "key", valid_579409
  var valid_579410 = query.getOrDefault("prettyPrint")
  valid_579410 = validateParameter(valid_579410, JBool, required = false,
                                 default = newJBool(true))
  if valid_579410 != nil:
    section.add "prettyPrint", valid_579410
  var valid_579411 = query.getOrDefault("oauth_token")
  valid_579411 = validateParameter(valid_579411, JString, required = false,
                                 default = nil)
  if valid_579411 != nil:
    section.add "oauth_token", valid_579411
  var valid_579412 = query.getOrDefault("$.xgafv")
  valid_579412 = validateParameter(valid_579412, JString, required = false,
                                 default = newJString("1"))
  if valid_579412 != nil:
    section.add "$.xgafv", valid_579412
  var valid_579413 = query.getOrDefault("alt")
  valid_579413 = validateParameter(valid_579413, JString, required = false,
                                 default = newJString("json"))
  if valid_579413 != nil:
    section.add "alt", valid_579413
  var valid_579414 = query.getOrDefault("uploadType")
  valid_579414 = validateParameter(valid_579414, JString, required = false,
                                 default = nil)
  if valid_579414 != nil:
    section.add "uploadType", valid_579414
  var valid_579415 = query.getOrDefault("quotaUser")
  valid_579415 = validateParameter(valid_579415, JString, required = false,
                                 default = nil)
  if valid_579415 != nil:
    section.add "quotaUser", valid_579415
  var valid_579416 = query.getOrDefault("callback")
  valid_579416 = validateParameter(valid_579416, JString, required = false,
                                 default = nil)
  if valid_579416 != nil:
    section.add "callback", valid_579416
  var valid_579417 = query.getOrDefault("fields")
  valid_579417 = validateParameter(valid_579417, JString, required = false,
                                 default = nil)
  if valid_579417 != nil:
    section.add "fields", valid_579417
  var valid_579418 = query.getOrDefault("access_token")
  valid_579418 = validateParameter(valid_579418, JString, required = false,
                                 default = nil)
  if valid_579418 != nil:
    section.add "access_token", valid_579418
  var valid_579419 = query.getOrDefault("upload_protocol")
  valid_579419 = validateParameter(valid_579419, JString, required = false,
                                 default = nil)
  if valid_579419 != nil:
    section.add "upload_protocol", valid_579419
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

proc call*(call_579421: Call_SpannerProjectsInstancesDatabasesSessionsRead_579405;
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
  let valid = call_579421.validator(path, query, header, formData, body)
  let scheme = call_579421.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579421.url(scheme.get, call_579421.host, call_579421.base,
                         call_579421.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579421, url, valid)

proc call*(call_579422: Call_SpannerProjectsInstancesDatabasesSessionsRead_579405;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
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
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579423 = newJObject()
  var query_579424 = newJObject()
  var body_579425 = newJObject()
  add(query_579424, "key", newJString(key))
  add(query_579424, "prettyPrint", newJBool(prettyPrint))
  add(query_579424, "oauth_token", newJString(oauthToken))
  add(query_579424, "$.xgafv", newJString(Xgafv))
  add(query_579424, "alt", newJString(alt))
  add(query_579424, "uploadType", newJString(uploadType))
  add(query_579424, "quotaUser", newJString(quotaUser))
  add(path_579423, "session", newJString(session))
  if body != nil:
    body_579425 = body
  add(query_579424, "callback", newJString(callback))
  add(query_579424, "fields", newJString(fields))
  add(query_579424, "access_token", newJString(accessToken))
  add(query_579424, "upload_protocol", newJString(uploadProtocol))
  result = call_579422.call(path_579423, query_579424, nil, nil, body_579425)

var spannerProjectsInstancesDatabasesSessionsRead* = Call_SpannerProjectsInstancesDatabasesSessionsRead_579405(
    name: "spannerProjectsInstancesDatabasesSessionsRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:read",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRead_579406,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRead_579407,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsRollback_579426 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsRollback_579428(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsRollback_579427(
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
  var valid_579429 = path.getOrDefault("session")
  valid_579429 = validateParameter(valid_579429, JString, required = true,
                                 default = nil)
  if valid_579429 != nil:
    section.add "session", valid_579429
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579430 = query.getOrDefault("key")
  valid_579430 = validateParameter(valid_579430, JString, required = false,
                                 default = nil)
  if valid_579430 != nil:
    section.add "key", valid_579430
  var valid_579431 = query.getOrDefault("prettyPrint")
  valid_579431 = validateParameter(valid_579431, JBool, required = false,
                                 default = newJBool(true))
  if valid_579431 != nil:
    section.add "prettyPrint", valid_579431
  var valid_579432 = query.getOrDefault("oauth_token")
  valid_579432 = validateParameter(valid_579432, JString, required = false,
                                 default = nil)
  if valid_579432 != nil:
    section.add "oauth_token", valid_579432
  var valid_579433 = query.getOrDefault("$.xgafv")
  valid_579433 = validateParameter(valid_579433, JString, required = false,
                                 default = newJString("1"))
  if valid_579433 != nil:
    section.add "$.xgafv", valid_579433
  var valid_579434 = query.getOrDefault("alt")
  valid_579434 = validateParameter(valid_579434, JString, required = false,
                                 default = newJString("json"))
  if valid_579434 != nil:
    section.add "alt", valid_579434
  var valid_579435 = query.getOrDefault("uploadType")
  valid_579435 = validateParameter(valid_579435, JString, required = false,
                                 default = nil)
  if valid_579435 != nil:
    section.add "uploadType", valid_579435
  var valid_579436 = query.getOrDefault("quotaUser")
  valid_579436 = validateParameter(valid_579436, JString, required = false,
                                 default = nil)
  if valid_579436 != nil:
    section.add "quotaUser", valid_579436
  var valid_579437 = query.getOrDefault("callback")
  valid_579437 = validateParameter(valid_579437, JString, required = false,
                                 default = nil)
  if valid_579437 != nil:
    section.add "callback", valid_579437
  var valid_579438 = query.getOrDefault("fields")
  valid_579438 = validateParameter(valid_579438, JString, required = false,
                                 default = nil)
  if valid_579438 != nil:
    section.add "fields", valid_579438
  var valid_579439 = query.getOrDefault("access_token")
  valid_579439 = validateParameter(valid_579439, JString, required = false,
                                 default = nil)
  if valid_579439 != nil:
    section.add "access_token", valid_579439
  var valid_579440 = query.getOrDefault("upload_protocol")
  valid_579440 = validateParameter(valid_579440, JString, required = false,
                                 default = nil)
  if valid_579440 != nil:
    section.add "upload_protocol", valid_579440
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

proc call*(call_579442: Call_SpannerProjectsInstancesDatabasesSessionsRollback_579426;
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
  let valid = call_579442.validator(path, query, header, formData, body)
  let scheme = call_579442.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579442.url(scheme.get, call_579442.host, call_579442.base,
                         call_579442.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579442, url, valid)

proc call*(call_579443: Call_SpannerProjectsInstancesDatabasesSessionsRollback_579426;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsRollback
  ## Rolls back a transaction, releasing any locks it holds. It is a good
  ## idea to call this for any transaction that includes one or more
  ## Read or ExecuteSql requests and
  ## ultimately decides not to commit.
  ## 
  ## `Rollback` returns `OK` if it successfully aborts the transaction, the
  ## transaction was already aborted, or the transaction is not
  ## found. `Rollback` never returns `ABORTED`.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the transaction to roll back is running.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579444 = newJObject()
  var query_579445 = newJObject()
  var body_579446 = newJObject()
  add(query_579445, "key", newJString(key))
  add(query_579445, "prettyPrint", newJBool(prettyPrint))
  add(query_579445, "oauth_token", newJString(oauthToken))
  add(query_579445, "$.xgafv", newJString(Xgafv))
  add(query_579445, "alt", newJString(alt))
  add(query_579445, "uploadType", newJString(uploadType))
  add(query_579445, "quotaUser", newJString(quotaUser))
  add(path_579444, "session", newJString(session))
  if body != nil:
    body_579446 = body
  add(query_579445, "callback", newJString(callback))
  add(query_579445, "fields", newJString(fields))
  add(query_579445, "access_token", newJString(accessToken))
  add(query_579445, "upload_protocol", newJString(uploadProtocol))
  result = call_579443.call(path_579444, query_579445, nil, nil, body_579446)

var spannerProjectsInstancesDatabasesSessionsRollback* = Call_SpannerProjectsInstancesDatabasesSessionsRollback_579426(
    name: "spannerProjectsInstancesDatabasesSessionsRollback",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:rollback",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsRollback_579427,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsRollback_579428,
    schemes: {Scheme.Https})
type
  Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579447 = ref object of OpenApiRestCall_578348
proc url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579449(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579448(
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
  var valid_579450 = path.getOrDefault("session")
  valid_579450 = validateParameter(valid_579450, JString, required = true,
                                 default = nil)
  if valid_579450 != nil:
    section.add "session", valid_579450
  result.add "path", section
  ## parameters in `query` object:
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   $.xgafv: JString
  ##          : V1 error format.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579451 = query.getOrDefault("key")
  valid_579451 = validateParameter(valid_579451, JString, required = false,
                                 default = nil)
  if valid_579451 != nil:
    section.add "key", valid_579451
  var valid_579452 = query.getOrDefault("prettyPrint")
  valid_579452 = validateParameter(valid_579452, JBool, required = false,
                                 default = newJBool(true))
  if valid_579452 != nil:
    section.add "prettyPrint", valid_579452
  var valid_579453 = query.getOrDefault("oauth_token")
  valid_579453 = validateParameter(valid_579453, JString, required = false,
                                 default = nil)
  if valid_579453 != nil:
    section.add "oauth_token", valid_579453
  var valid_579454 = query.getOrDefault("$.xgafv")
  valid_579454 = validateParameter(valid_579454, JString, required = false,
                                 default = newJString("1"))
  if valid_579454 != nil:
    section.add "$.xgafv", valid_579454
  var valid_579455 = query.getOrDefault("alt")
  valid_579455 = validateParameter(valid_579455, JString, required = false,
                                 default = newJString("json"))
  if valid_579455 != nil:
    section.add "alt", valid_579455
  var valid_579456 = query.getOrDefault("uploadType")
  valid_579456 = validateParameter(valid_579456, JString, required = false,
                                 default = nil)
  if valid_579456 != nil:
    section.add "uploadType", valid_579456
  var valid_579457 = query.getOrDefault("quotaUser")
  valid_579457 = validateParameter(valid_579457, JString, required = false,
                                 default = nil)
  if valid_579457 != nil:
    section.add "quotaUser", valid_579457
  var valid_579458 = query.getOrDefault("callback")
  valid_579458 = validateParameter(valid_579458, JString, required = false,
                                 default = nil)
  if valid_579458 != nil:
    section.add "callback", valid_579458
  var valid_579459 = query.getOrDefault("fields")
  valid_579459 = validateParameter(valid_579459, JString, required = false,
                                 default = nil)
  if valid_579459 != nil:
    section.add "fields", valid_579459
  var valid_579460 = query.getOrDefault("access_token")
  valid_579460 = validateParameter(valid_579460, JString, required = false,
                                 default = nil)
  if valid_579460 != nil:
    section.add "access_token", valid_579460
  var valid_579461 = query.getOrDefault("upload_protocol")
  valid_579461 = validateParameter(valid_579461, JString, required = false,
                                 default = nil)
  if valid_579461 != nil:
    section.add "upload_protocol", valid_579461
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

proc call*(call_579463: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ## 
  let valid = call_579463.validator(path, query, header, formData, body)
  let scheme = call_579463.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579463.url(scheme.get, call_579463.host, call_579463.base,
                         call_579463.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579463, url, valid)

proc call*(call_579464: Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579447;
          session: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## spannerProjectsInstancesDatabasesSessionsStreamingRead
  ## Like Read, except returns the result set as a
  ## stream. Unlike Read, there is no limit on the
  ## size of the returned result set. However, no individual row in
  ## the result set can exceed 100 MiB, and no column value can exceed
  ## 10 MiB.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   session: string (required)
  ##          : Required. The session in which the read should be performed.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579465 = newJObject()
  var query_579466 = newJObject()
  var body_579467 = newJObject()
  add(query_579466, "key", newJString(key))
  add(query_579466, "prettyPrint", newJBool(prettyPrint))
  add(query_579466, "oauth_token", newJString(oauthToken))
  add(query_579466, "$.xgafv", newJString(Xgafv))
  add(query_579466, "alt", newJString(alt))
  add(query_579466, "uploadType", newJString(uploadType))
  add(query_579466, "quotaUser", newJString(quotaUser))
  add(path_579465, "session", newJString(session))
  if body != nil:
    body_579467 = body
  add(query_579466, "callback", newJString(callback))
  add(query_579466, "fields", newJString(fields))
  add(query_579466, "access_token", newJString(accessToken))
  add(query_579466, "upload_protocol", newJString(uploadProtocol))
  result = call_579464.call(path_579465, query_579466, nil, nil, body_579467)

var spannerProjectsInstancesDatabasesSessionsStreamingRead* = Call_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579447(
    name: "spannerProjectsInstancesDatabasesSessionsStreamingRead",
    meth: HttpMethod.HttpPost, host: "spanner.googleapis.com",
    route: "/v1/{session}:streamingRead",
    validator: validate_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579448,
    base: "/", url: url_SpannerProjectsInstancesDatabasesSessionsStreamingRead_579449,
    schemes: {Scheme.Https})
export
  rest

type
  GoogleAuth = ref object
    endpoint*: Uri
    token: string
    expiry*: float64
    issued*: float64
    email: string
    key: string
    scope*: seq[string]
    form: string
    digest: Hash

const
  endpoint = "https://www.googleapis.com/oauth2/v4/token".parseUri
var auth = GoogleAuth(endpoint: endpoint)
proc hash(auth: GoogleAuth): Hash =
  ## yield differing values for effectively different auth payloads
  result = hash($auth.endpoint)
  result = result !& hash(auth.email)
  result = result !& hash(auth.key)
  result = result !& hash(auth.scope.join(" "))
  result = !$result

proc newAuthenticator*(path: string): GoogleAuth =
  let
    input = readFile(path)
    js = parseJson(input)
  auth.email = js["client_email"].getStr
  auth.key = js["private_key"].getStr
  result = auth

proc store(auth: var GoogleAuth; token: string; expiry: int; form: string) =
  auth.token = token
  auth.issued = epochTime()
  auth.expiry = auth.issued + expiry.float64
  auth.form = form
  auth.digest = auth.hash

proc authenticate*(fresh: float64 = 3600.0; lifetime: int = 3600): Future[bool] {.async.} =
  ## get or refresh an authentication token; provide `fresh`
  ## to ensure that the token won't expire in the next N seconds.
  ## provide `lifetime` to indicate how long the token should last.
  let clock = epochTime()
  if auth.expiry > clock + fresh:
    if auth.hash == auth.digest:
      return true
  let
    expiry = clock.int + lifetime
    header = JOSEHeader(alg: RS256, typ: "JWT")
    claims = %*{"iss": auth.email, "scope": auth.scope.join(" "),
              "aud": "https://www.googleapis.com/oauth2/v4/token", "exp": expiry,
              "iat": clock.int}
  var tok = JWT(header: header, claims: toClaims(claims))
  tok.sign(auth.key)
  let post = encodeQuery({"grant_type": "urn:ietf:params:oauth:grant-type:jwt-bearer",
                       "assertion": $tok}, usePlus = false, omitEq = false)
  var client = newAsyncHttpClient()
  client.headers = newHttpHeaders({"Content-Type": "application/x-www-form-urlencoded",
                                 "Content-Length": $post.len})
  let response = await client.request($auth.endpoint, HttpPost, body = post)
  if not response.code.is2xx:
    return false
  let body = await response.body
  client.close
  try:
    let js = parseJson(body)
    auth.store(js["access_token"].getStr, js["expires_in"].getInt,
               js["token_type"].getStr)
  except KeyError:
    return false
  except JsonParsingError:
    return false
  return true

proc composeQueryString(query: JsonNode): string =
  var qs: seq[KeyVal]
  if query == nil:
    return ""
  for k, v in query.pairs:
    qs.add (key: k, val: v.getStr)
  result = encodeQuery(qs, usePlus = false, omitEq = false)

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  var headers = massageHeaders(input.getOrDefault("header"))
  let body = input.getOrDefault("body").getStr
  if auth.scope.len == 0:
    raise newException(ValueError, "specify authentication scopes")
  if not waitfor authenticate(fresh = 10.0):
    raise newException(IOError, "unable to refresh authentication token")
  headers.add ("Authorization", auth.form & " " & auth.token)
  headers.add ("Content-Type", "application/json")
  headers.add ("Content-Length", $body.len)
  result = newRecallable(call, url, headers, body = body)
