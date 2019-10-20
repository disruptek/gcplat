
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Bigtable Admin
## version: v2
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Administer your Cloud Bigtable tables and instances.
## 
## https://cloud.google.com/bigtable/
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
  gcpServiceName = "bigtableadmin"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_BigtableadminProjectsInstancesClustersUpdate_578908 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesClustersUpdate_578910(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersUpdate_578909(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a cluster within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : (`OutputOnly`)
  ## The unique name of the cluster. Values are of the form
  ## `projects/<project>/instances/<instance>/clusters/a-z*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578911 = path.getOrDefault("name")
  valid_578911 = validateParameter(valid_578911, JString, required = true,
                                 default = nil)
  if valid_578911 != nil:
    section.add "name", valid_578911
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
  var valid_578912 = query.getOrDefault("key")
  valid_578912 = validateParameter(valid_578912, JString, required = false,
                                 default = nil)
  if valid_578912 != nil:
    section.add "key", valid_578912
  var valid_578913 = query.getOrDefault("prettyPrint")
  valid_578913 = validateParameter(valid_578913, JBool, required = false,
                                 default = newJBool(true))
  if valid_578913 != nil:
    section.add "prettyPrint", valid_578913
  var valid_578914 = query.getOrDefault("oauth_token")
  valid_578914 = validateParameter(valid_578914, JString, required = false,
                                 default = nil)
  if valid_578914 != nil:
    section.add "oauth_token", valid_578914
  var valid_578915 = query.getOrDefault("$.xgafv")
  valid_578915 = validateParameter(valid_578915, JString, required = false,
                                 default = newJString("1"))
  if valid_578915 != nil:
    section.add "$.xgafv", valid_578915
  var valid_578916 = query.getOrDefault("alt")
  valid_578916 = validateParameter(valid_578916, JString, required = false,
                                 default = newJString("json"))
  if valid_578916 != nil:
    section.add "alt", valid_578916
  var valid_578917 = query.getOrDefault("uploadType")
  valid_578917 = validateParameter(valid_578917, JString, required = false,
                                 default = nil)
  if valid_578917 != nil:
    section.add "uploadType", valid_578917
  var valid_578918 = query.getOrDefault("quotaUser")
  valid_578918 = validateParameter(valid_578918, JString, required = false,
                                 default = nil)
  if valid_578918 != nil:
    section.add "quotaUser", valid_578918
  var valid_578919 = query.getOrDefault("callback")
  valid_578919 = validateParameter(valid_578919, JString, required = false,
                                 default = nil)
  if valid_578919 != nil:
    section.add "callback", valid_578919
  var valid_578920 = query.getOrDefault("fields")
  valid_578920 = validateParameter(valid_578920, JString, required = false,
                                 default = nil)
  if valid_578920 != nil:
    section.add "fields", valid_578920
  var valid_578921 = query.getOrDefault("access_token")
  valid_578921 = validateParameter(valid_578921, JString, required = false,
                                 default = nil)
  if valid_578921 != nil:
    section.add "access_token", valid_578921
  var valid_578922 = query.getOrDefault("upload_protocol")
  valid_578922 = validateParameter(valid_578922, JString, required = false,
                                 default = nil)
  if valid_578922 != nil:
    section.add "upload_protocol", valid_578922
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

proc call*(call_578924: Call_BigtableadminProjectsInstancesClustersUpdate_578908;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a cluster within an instance.
  ## 
  let valid = call_578924.validator(path, query, header, formData, body)
  let scheme = call_578924.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578924.url(scheme.get, call_578924.host, call_578924.base,
                         call_578924.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578924, url, valid)

proc call*(call_578925: Call_BigtableadminProjectsInstancesClustersUpdate_578908;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesClustersUpdate
  ## Updates a cluster within an instance.
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
  ##       : (`OutputOnly`)
  ## The unique name of the cluster. Values are of the form
  ## `projects/<project>/instances/<instance>/clusters/a-z*`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578926 = newJObject()
  var query_578927 = newJObject()
  var body_578928 = newJObject()
  add(query_578927, "key", newJString(key))
  add(query_578927, "prettyPrint", newJBool(prettyPrint))
  add(query_578927, "oauth_token", newJString(oauthToken))
  add(query_578927, "$.xgafv", newJString(Xgafv))
  add(query_578927, "alt", newJString(alt))
  add(query_578927, "uploadType", newJString(uploadType))
  add(query_578927, "quotaUser", newJString(quotaUser))
  add(path_578926, "name", newJString(name))
  if body != nil:
    body_578928 = body
  add(query_578927, "callback", newJString(callback))
  add(query_578927, "fields", newJString(fields))
  add(query_578927, "access_token", newJString(accessToken))
  add(query_578927, "upload_protocol", newJString(uploadProtocol))
  result = call_578925.call(path_578926, query_578927, nil, nil, body_578928)

var bigtableadminProjectsInstancesClustersUpdate* = Call_BigtableadminProjectsInstancesClustersUpdate_578908(
    name: "bigtableadminProjectsInstancesClustersUpdate",
    meth: HttpMethod.HttpPut, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesClustersUpdate_578909,
    base: "/", url: url_BigtableadminProjectsInstancesClustersUpdate_578910,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsGet_578619 = ref object of OpenApiRestCall_578348
proc url_BigtableadminOperationsGet_578621(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsGet_578620(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578747 = path.getOrDefault("name")
  valid_578747 = validateParameter(valid_578747, JString, required = true,
                                 default = nil)
  if valid_578747 != nil:
    section.add "name", valid_578747
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
  ##   view: JString
  ##       : The view to be applied to the returned table's fields.
  ## Defaults to `SCHEMA_VIEW` if unspecified.
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
  var valid_578772 = query.getOrDefault("view")
  valid_578772 = validateParameter(valid_578772, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_578772 != nil:
    section.add "view", valid_578772
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578795: Call_BigtableadminOperationsGet_578619; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
  ## 
  let valid = call_578795.validator(path, query, header, formData, body)
  let scheme = call_578795.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578795.url(scheme.get, call_578795.host, call_578795.base,
                         call_578795.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578795, url, valid)

proc call*(call_578866: Call_BigtableadminOperationsGet_578619; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "VIEW_UNSPECIFIED"): Recallable =
  ## bigtableadminOperationsGet
  ## Gets the latest state of a long-running operation.  Clients can use this
  ## method to poll the operation result at intervals as recommended by the API
  ## service.
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
  ##       : The name of the operation resource.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The view to be applied to the returned table's fields.
  ## Defaults to `SCHEMA_VIEW` if unspecified.
  var path_578867 = newJObject()
  var query_578869 = newJObject()
  add(query_578869, "key", newJString(key))
  add(query_578869, "prettyPrint", newJBool(prettyPrint))
  add(query_578869, "oauth_token", newJString(oauthToken))
  add(query_578869, "$.xgafv", newJString(Xgafv))
  add(query_578869, "alt", newJString(alt))
  add(query_578869, "uploadType", newJString(uploadType))
  add(query_578869, "quotaUser", newJString(quotaUser))
  add(path_578867, "name", newJString(name))
  add(query_578869, "callback", newJString(callback))
  add(query_578869, "fields", newJString(fields))
  add(query_578869, "access_token", newJString(accessToken))
  add(query_578869, "upload_protocol", newJString(uploadProtocol))
  add(query_578869, "view", newJString(view))
  result = call_578866.call(path_578867, query_578869, nil, nil, nil)

var bigtableadminOperationsGet* = Call_BigtableadminOperationsGet_578619(
    name: "bigtableadminOperationsGet", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsGet_578620, base: "/",
    url: url_BigtableadminOperationsGet_578621, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesPatch_578949 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesAppProfilesPatch_578951(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesPatch_578950(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Updates an app profile within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : (`OutputOnly`)
  ## The unique name of the app profile. Values are of the form
  ## `projects/<project>/instances/<instance>/appProfiles/_a-zA-Z0-9*`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578952 = path.getOrDefault("name")
  valid_578952 = validateParameter(valid_578952, JString, required = true,
                                 default = nil)
  if valid_578952 != nil:
    section.add "name", valid_578952
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
  ##   updateMask: JString
  ##             : The subset of app profile fields which should be replaced.
  ## If unset, all fields will be replaced.
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when updating the app profile.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578953 = query.getOrDefault("key")
  valid_578953 = validateParameter(valid_578953, JString, required = false,
                                 default = nil)
  if valid_578953 != nil:
    section.add "key", valid_578953
  var valid_578954 = query.getOrDefault("prettyPrint")
  valid_578954 = validateParameter(valid_578954, JBool, required = false,
                                 default = newJBool(true))
  if valid_578954 != nil:
    section.add "prettyPrint", valid_578954
  var valid_578955 = query.getOrDefault("oauth_token")
  valid_578955 = validateParameter(valid_578955, JString, required = false,
                                 default = nil)
  if valid_578955 != nil:
    section.add "oauth_token", valid_578955
  var valid_578956 = query.getOrDefault("$.xgafv")
  valid_578956 = validateParameter(valid_578956, JString, required = false,
                                 default = newJString("1"))
  if valid_578956 != nil:
    section.add "$.xgafv", valid_578956
  var valid_578957 = query.getOrDefault("alt")
  valid_578957 = validateParameter(valid_578957, JString, required = false,
                                 default = newJString("json"))
  if valid_578957 != nil:
    section.add "alt", valid_578957
  var valid_578958 = query.getOrDefault("uploadType")
  valid_578958 = validateParameter(valid_578958, JString, required = false,
                                 default = nil)
  if valid_578958 != nil:
    section.add "uploadType", valid_578958
  var valid_578959 = query.getOrDefault("quotaUser")
  valid_578959 = validateParameter(valid_578959, JString, required = false,
                                 default = nil)
  if valid_578959 != nil:
    section.add "quotaUser", valid_578959
  var valid_578960 = query.getOrDefault("updateMask")
  valid_578960 = validateParameter(valid_578960, JString, required = false,
                                 default = nil)
  if valid_578960 != nil:
    section.add "updateMask", valid_578960
  var valid_578961 = query.getOrDefault("ignoreWarnings")
  valid_578961 = validateParameter(valid_578961, JBool, required = false, default = nil)
  if valid_578961 != nil:
    section.add "ignoreWarnings", valid_578961
  var valid_578962 = query.getOrDefault("callback")
  valid_578962 = validateParameter(valid_578962, JString, required = false,
                                 default = nil)
  if valid_578962 != nil:
    section.add "callback", valid_578962
  var valid_578963 = query.getOrDefault("fields")
  valid_578963 = validateParameter(valid_578963, JString, required = false,
                                 default = nil)
  if valid_578963 != nil:
    section.add "fields", valid_578963
  var valid_578964 = query.getOrDefault("access_token")
  valid_578964 = validateParameter(valid_578964, JString, required = false,
                                 default = nil)
  if valid_578964 != nil:
    section.add "access_token", valid_578964
  var valid_578965 = query.getOrDefault("upload_protocol")
  valid_578965 = validateParameter(valid_578965, JString, required = false,
                                 default = nil)
  if valid_578965 != nil:
    section.add "upload_protocol", valid_578965
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

proc call*(call_578967: Call_BigtableadminProjectsInstancesAppProfilesPatch_578949;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an app profile within an instance.
  ## 
  let valid = call_578967.validator(path, query, header, formData, body)
  let scheme = call_578967.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578967.url(scheme.get, call_578967.host, call_578967.base,
                         call_578967.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578967, url, valid)

proc call*(call_578968: Call_BigtableadminProjectsInstancesAppProfilesPatch_578949;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; updateMask: string = "";
          ignoreWarnings: bool = false; body: JsonNode = nil; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesPatch
  ## Updates an app profile within an instance.
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
  ##       : (`OutputOnly`)
  ## The unique name of the app profile. Values are of the form
  ## `projects/<project>/instances/<instance>/appProfiles/_a-zA-Z0-9*`.
  ##   updateMask: string
  ##             : The subset of app profile fields which should be replaced.
  ## If unset, all fields will be replaced.
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when updating the app profile.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578969 = newJObject()
  var query_578970 = newJObject()
  var body_578971 = newJObject()
  add(query_578970, "key", newJString(key))
  add(query_578970, "prettyPrint", newJBool(prettyPrint))
  add(query_578970, "oauth_token", newJString(oauthToken))
  add(query_578970, "$.xgafv", newJString(Xgafv))
  add(query_578970, "alt", newJString(alt))
  add(query_578970, "uploadType", newJString(uploadType))
  add(query_578970, "quotaUser", newJString(quotaUser))
  add(path_578969, "name", newJString(name))
  add(query_578970, "updateMask", newJString(updateMask))
  add(query_578970, "ignoreWarnings", newJBool(ignoreWarnings))
  if body != nil:
    body_578971 = body
  add(query_578970, "callback", newJString(callback))
  add(query_578970, "fields", newJString(fields))
  add(query_578970, "access_token", newJString(accessToken))
  add(query_578970, "upload_protocol", newJString(uploadProtocol))
  result = call_578968.call(path_578969, query_578970, nil, nil, body_578971)

var bigtableadminProjectsInstancesAppProfilesPatch* = Call_BigtableadminProjectsInstancesAppProfilesPatch_578949(
    name: "bigtableadminProjectsInstancesAppProfilesPatch",
    meth: HttpMethod.HttpPatch, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}",
    validator: validate_BigtableadminProjectsInstancesAppProfilesPatch_578950,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesPatch_578951,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsDelete_578929 = ref object of OpenApiRestCall_578348
proc url_BigtableadminOperationsDelete_578931(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsDelete_578930(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_578932 = path.getOrDefault("name")
  valid_578932 = validateParameter(valid_578932, JString, required = true,
                                 default = nil)
  if valid_578932 != nil:
    section.add "name", valid_578932
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
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when deleting the app profile.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578933 = query.getOrDefault("key")
  valid_578933 = validateParameter(valid_578933, JString, required = false,
                                 default = nil)
  if valid_578933 != nil:
    section.add "key", valid_578933
  var valid_578934 = query.getOrDefault("prettyPrint")
  valid_578934 = validateParameter(valid_578934, JBool, required = false,
                                 default = newJBool(true))
  if valid_578934 != nil:
    section.add "prettyPrint", valid_578934
  var valid_578935 = query.getOrDefault("oauth_token")
  valid_578935 = validateParameter(valid_578935, JString, required = false,
                                 default = nil)
  if valid_578935 != nil:
    section.add "oauth_token", valid_578935
  var valid_578936 = query.getOrDefault("$.xgafv")
  valid_578936 = validateParameter(valid_578936, JString, required = false,
                                 default = newJString("1"))
  if valid_578936 != nil:
    section.add "$.xgafv", valid_578936
  var valid_578937 = query.getOrDefault("alt")
  valid_578937 = validateParameter(valid_578937, JString, required = false,
                                 default = newJString("json"))
  if valid_578937 != nil:
    section.add "alt", valid_578937
  var valid_578938 = query.getOrDefault("uploadType")
  valid_578938 = validateParameter(valid_578938, JString, required = false,
                                 default = nil)
  if valid_578938 != nil:
    section.add "uploadType", valid_578938
  var valid_578939 = query.getOrDefault("quotaUser")
  valid_578939 = validateParameter(valid_578939, JString, required = false,
                                 default = nil)
  if valid_578939 != nil:
    section.add "quotaUser", valid_578939
  var valid_578940 = query.getOrDefault("ignoreWarnings")
  valid_578940 = validateParameter(valid_578940, JBool, required = false, default = nil)
  if valid_578940 != nil:
    section.add "ignoreWarnings", valid_578940
  var valid_578941 = query.getOrDefault("callback")
  valid_578941 = validateParameter(valid_578941, JString, required = false,
                                 default = nil)
  if valid_578941 != nil:
    section.add "callback", valid_578941
  var valid_578942 = query.getOrDefault("fields")
  valid_578942 = validateParameter(valid_578942, JString, required = false,
                                 default = nil)
  if valid_578942 != nil:
    section.add "fields", valid_578942
  var valid_578943 = query.getOrDefault("access_token")
  valid_578943 = validateParameter(valid_578943, JString, required = false,
                                 default = nil)
  if valid_578943 != nil:
    section.add "access_token", valid_578943
  var valid_578944 = query.getOrDefault("upload_protocol")
  valid_578944 = validateParameter(valid_578944, JString, required = false,
                                 default = nil)
  if valid_578944 != nil:
    section.add "upload_protocol", valid_578944
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578945: Call_BigtableadminOperationsDelete_578929; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes a long-running operation. This method indicates that the client is
  ## no longer interested in the operation result. It does not cancel the
  ## operation. If the server doesn't support this method, it returns
  ## `google.rpc.Code.UNIMPLEMENTED`.
  ## 
  let valid = call_578945.validator(path, query, header, formData, body)
  let scheme = call_578945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578945.url(scheme.get, call_578945.host, call_578945.base,
                         call_578945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578945, url, valid)

proc call*(call_578946: Call_BigtableadminOperationsDelete_578929; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; ignoreWarnings: bool = false; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminOperationsDelete
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
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when deleting the app profile.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578947 = newJObject()
  var query_578948 = newJObject()
  add(query_578948, "key", newJString(key))
  add(query_578948, "prettyPrint", newJBool(prettyPrint))
  add(query_578948, "oauth_token", newJString(oauthToken))
  add(query_578948, "$.xgafv", newJString(Xgafv))
  add(query_578948, "alt", newJString(alt))
  add(query_578948, "uploadType", newJString(uploadType))
  add(query_578948, "quotaUser", newJString(quotaUser))
  add(path_578947, "name", newJString(name))
  add(query_578948, "ignoreWarnings", newJBool(ignoreWarnings))
  add(query_578948, "callback", newJString(callback))
  add(query_578948, "fields", newJString(fields))
  add(query_578948, "access_token", newJString(accessToken))
  add(query_578948, "upload_protocol", newJString(uploadProtocol))
  result = call_578946.call(path_578947, query_578948, nil, nil, nil)

var bigtableadminOperationsDelete* = Call_BigtableadminOperationsDelete_578929(
    name: "bigtableadminOperationsDelete", meth: HttpMethod.HttpDelete,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}",
    validator: validate_BigtableadminOperationsDelete_578930, base: "/",
    url: url_BigtableadminOperationsDelete_578931, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsLocationsList_578972 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsLocationsList_578974(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsLocationsList_578973(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578975 = path.getOrDefault("name")
  valid_578975 = validateParameter(valid_578975, JString, required = true,
                                 default = nil)
  if valid_578975 != nil:
    section.add "name", valid_578975
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578976 = query.getOrDefault("key")
  valid_578976 = validateParameter(valid_578976, JString, required = false,
                                 default = nil)
  if valid_578976 != nil:
    section.add "key", valid_578976
  var valid_578977 = query.getOrDefault("prettyPrint")
  valid_578977 = validateParameter(valid_578977, JBool, required = false,
                                 default = newJBool(true))
  if valid_578977 != nil:
    section.add "prettyPrint", valid_578977
  var valid_578978 = query.getOrDefault("oauth_token")
  valid_578978 = validateParameter(valid_578978, JString, required = false,
                                 default = nil)
  if valid_578978 != nil:
    section.add "oauth_token", valid_578978
  var valid_578979 = query.getOrDefault("$.xgafv")
  valid_578979 = validateParameter(valid_578979, JString, required = false,
                                 default = newJString("1"))
  if valid_578979 != nil:
    section.add "$.xgafv", valid_578979
  var valid_578980 = query.getOrDefault("pageSize")
  valid_578980 = validateParameter(valid_578980, JInt, required = false, default = nil)
  if valid_578980 != nil:
    section.add "pageSize", valid_578980
  var valid_578981 = query.getOrDefault("alt")
  valid_578981 = validateParameter(valid_578981, JString, required = false,
                                 default = newJString("json"))
  if valid_578981 != nil:
    section.add "alt", valid_578981
  var valid_578982 = query.getOrDefault("uploadType")
  valid_578982 = validateParameter(valid_578982, JString, required = false,
                                 default = nil)
  if valid_578982 != nil:
    section.add "uploadType", valid_578982
  var valid_578983 = query.getOrDefault("quotaUser")
  valid_578983 = validateParameter(valid_578983, JString, required = false,
                                 default = nil)
  if valid_578983 != nil:
    section.add "quotaUser", valid_578983
  var valid_578984 = query.getOrDefault("filter")
  valid_578984 = validateParameter(valid_578984, JString, required = false,
                                 default = nil)
  if valid_578984 != nil:
    section.add "filter", valid_578984
  var valid_578985 = query.getOrDefault("pageToken")
  valid_578985 = validateParameter(valid_578985, JString, required = false,
                                 default = nil)
  if valid_578985 != nil:
    section.add "pageToken", valid_578985
  var valid_578986 = query.getOrDefault("callback")
  valid_578986 = validateParameter(valid_578986, JString, required = false,
                                 default = nil)
  if valid_578986 != nil:
    section.add "callback", valid_578986
  var valid_578987 = query.getOrDefault("fields")
  valid_578987 = validateParameter(valid_578987, JString, required = false,
                                 default = nil)
  if valid_578987 != nil:
    section.add "fields", valid_578987
  var valid_578988 = query.getOrDefault("access_token")
  valid_578988 = validateParameter(valid_578988, JString, required = false,
                                 default = nil)
  if valid_578988 != nil:
    section.add "access_token", valid_578988
  var valid_578989 = query.getOrDefault("upload_protocol")
  valid_578989 = validateParameter(valid_578989, JString, required = false,
                                 default = nil)
  if valid_578989 != nil:
    section.add "upload_protocol", valid_578989
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_578990: Call_BigtableadminProjectsLocationsList_578972;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_578990.validator(path, query, header, formData, body)
  let scheme = call_578990.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_578990.url(scheme.get, call_578990.host, call_578990.base,
                         call_578990.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_578990, url, valid)

proc call*(call_578991: Call_BigtableadminProjectsLocationsList_578972;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_578992 = newJObject()
  var query_578993 = newJObject()
  add(query_578993, "key", newJString(key))
  add(query_578993, "prettyPrint", newJBool(prettyPrint))
  add(query_578993, "oauth_token", newJString(oauthToken))
  add(query_578993, "$.xgafv", newJString(Xgafv))
  add(query_578993, "pageSize", newJInt(pageSize))
  add(query_578993, "alt", newJString(alt))
  add(query_578993, "uploadType", newJString(uploadType))
  add(query_578993, "quotaUser", newJString(quotaUser))
  add(path_578992, "name", newJString(name))
  add(query_578993, "filter", newJString(filter))
  add(query_578993, "pageToken", newJString(pageToken))
  add(query_578993, "callback", newJString(callback))
  add(query_578993, "fields", newJString(fields))
  add(query_578993, "access_token", newJString(accessToken))
  add(query_578993, "upload_protocol", newJString(uploadProtocol))
  result = call_578991.call(path_578992, query_578993, nil, nil, nil)

var bigtableadminProjectsLocationsList* = Call_BigtableadminProjectsLocationsList_578972(
    name: "bigtableadminProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}/locations",
    validator: validate_BigtableadminProjectsLocationsList_578973, base: "/",
    url: url_BigtableadminProjectsLocationsList_578974, schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsProjectsOperationsList_578994 = ref object of OpenApiRestCall_578348
proc url_BigtableadminOperationsProjectsOperationsList_578996(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsProjectsOperationsList_578995(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The name of the operation's parent resource.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_578997 = path.getOrDefault("name")
  valid_578997 = validateParameter(valid_578997, JString, required = true,
                                 default = nil)
  if valid_578997 != nil:
    section.add "name", valid_578997
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
  ##           : The standard list page size.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   filter: JString
  ##         : The standard list filter.
  ##   pageToken: JString
  ##            : The standard list page token.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_578998 = query.getOrDefault("key")
  valid_578998 = validateParameter(valid_578998, JString, required = false,
                                 default = nil)
  if valid_578998 != nil:
    section.add "key", valid_578998
  var valid_578999 = query.getOrDefault("prettyPrint")
  valid_578999 = validateParameter(valid_578999, JBool, required = false,
                                 default = newJBool(true))
  if valid_578999 != nil:
    section.add "prettyPrint", valid_578999
  var valid_579000 = query.getOrDefault("oauth_token")
  valid_579000 = validateParameter(valid_579000, JString, required = false,
                                 default = nil)
  if valid_579000 != nil:
    section.add "oauth_token", valid_579000
  var valid_579001 = query.getOrDefault("$.xgafv")
  valid_579001 = validateParameter(valid_579001, JString, required = false,
                                 default = newJString("1"))
  if valid_579001 != nil:
    section.add "$.xgafv", valid_579001
  var valid_579002 = query.getOrDefault("pageSize")
  valid_579002 = validateParameter(valid_579002, JInt, required = false, default = nil)
  if valid_579002 != nil:
    section.add "pageSize", valid_579002
  var valid_579003 = query.getOrDefault("alt")
  valid_579003 = validateParameter(valid_579003, JString, required = false,
                                 default = newJString("json"))
  if valid_579003 != nil:
    section.add "alt", valid_579003
  var valid_579004 = query.getOrDefault("uploadType")
  valid_579004 = validateParameter(valid_579004, JString, required = false,
                                 default = nil)
  if valid_579004 != nil:
    section.add "uploadType", valid_579004
  var valid_579005 = query.getOrDefault("quotaUser")
  valid_579005 = validateParameter(valid_579005, JString, required = false,
                                 default = nil)
  if valid_579005 != nil:
    section.add "quotaUser", valid_579005
  var valid_579006 = query.getOrDefault("filter")
  valid_579006 = validateParameter(valid_579006, JString, required = false,
                                 default = nil)
  if valid_579006 != nil:
    section.add "filter", valid_579006
  var valid_579007 = query.getOrDefault("pageToken")
  valid_579007 = validateParameter(valid_579007, JString, required = false,
                                 default = nil)
  if valid_579007 != nil:
    section.add "pageToken", valid_579007
  var valid_579008 = query.getOrDefault("callback")
  valid_579008 = validateParameter(valid_579008, JString, required = false,
                                 default = nil)
  if valid_579008 != nil:
    section.add "callback", valid_579008
  var valid_579009 = query.getOrDefault("fields")
  valid_579009 = validateParameter(valid_579009, JString, required = false,
                                 default = nil)
  if valid_579009 != nil:
    section.add "fields", valid_579009
  var valid_579010 = query.getOrDefault("access_token")
  valid_579010 = validateParameter(valid_579010, JString, required = false,
                                 default = nil)
  if valid_579010 != nil:
    section.add "access_token", valid_579010
  var valid_579011 = query.getOrDefault("upload_protocol")
  valid_579011 = validateParameter(valid_579011, JString, required = false,
                                 default = nil)
  if valid_579011 != nil:
    section.add "upload_protocol", valid_579011
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579012: Call_BigtableadminOperationsProjectsOperationsList_578994;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ## 
  let valid = call_579012.validator(path, query, header, formData, body)
  let scheme = call_579012.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579012.url(scheme.get, call_579012.host, call_579012.base,
                         call_579012.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579012, url, valid)

proc call*(call_579013: Call_BigtableadminOperationsProjectsOperationsList_578994;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          filter: string = ""; pageToken: string = ""; callback: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminOperationsProjectsOperationsList
  ## Lists operations that match the specified filter in the request. If the
  ## server doesn't support this method, it returns `UNIMPLEMENTED`.
  ## 
  ## NOTE: the `name` binding allows API services to override the binding
  ## to use different resource name schemes, such as `users/*/operations`. To
  ## override the binding, API services can add a binding such as
  ## `"/v1/{name=users/*}/operations"` to their service configuration.
  ## For backwards compatibility, the default name includes the operations
  ## collection id, however overriding users must ensure the name binding
  ## is the parent resource, without the operations collection id.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The standard list page size.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
  ##   filter: string
  ##         : The standard list filter.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579014 = newJObject()
  var query_579015 = newJObject()
  add(query_579015, "key", newJString(key))
  add(query_579015, "prettyPrint", newJBool(prettyPrint))
  add(query_579015, "oauth_token", newJString(oauthToken))
  add(query_579015, "$.xgafv", newJString(Xgafv))
  add(query_579015, "pageSize", newJInt(pageSize))
  add(query_579015, "alt", newJString(alt))
  add(query_579015, "uploadType", newJString(uploadType))
  add(query_579015, "quotaUser", newJString(quotaUser))
  add(path_579014, "name", newJString(name))
  add(query_579015, "filter", newJString(filter))
  add(query_579015, "pageToken", newJString(pageToken))
  add(query_579015, "callback", newJString(callback))
  add(query_579015, "fields", newJString(fields))
  add(query_579015, "access_token", newJString(accessToken))
  add(query_579015, "upload_protocol", newJString(uploadProtocol))
  result = call_579013.call(path_579014, query_579015, nil, nil, nil)

var bigtableadminOperationsProjectsOperationsList* = Call_BigtableadminOperationsProjectsOperationsList_578994(
    name: "bigtableadminOperationsProjectsOperationsList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}/operations",
    validator: validate_BigtableadminOperationsProjectsOperationsList_578995,
    base: "/", url: url_BigtableadminOperationsProjectsOperationsList_578996,
    schemes: {Scheme.Https})
type
  Call_BigtableadminOperationsCancel_579016 = ref object of OpenApiRestCall_578348
proc url_BigtableadminOperationsCancel_579018(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminOperationsCancel_579017(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_579019 = path.getOrDefault("name")
  valid_579019 = validateParameter(valid_579019, JString, required = true,
                                 default = nil)
  if valid_579019 != nil:
    section.add "name", valid_579019
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
  var valid_579020 = query.getOrDefault("key")
  valid_579020 = validateParameter(valid_579020, JString, required = false,
                                 default = nil)
  if valid_579020 != nil:
    section.add "key", valid_579020
  var valid_579021 = query.getOrDefault("prettyPrint")
  valid_579021 = validateParameter(valid_579021, JBool, required = false,
                                 default = newJBool(true))
  if valid_579021 != nil:
    section.add "prettyPrint", valid_579021
  var valid_579022 = query.getOrDefault("oauth_token")
  valid_579022 = validateParameter(valid_579022, JString, required = false,
                                 default = nil)
  if valid_579022 != nil:
    section.add "oauth_token", valid_579022
  var valid_579023 = query.getOrDefault("$.xgafv")
  valid_579023 = validateParameter(valid_579023, JString, required = false,
                                 default = newJString("1"))
  if valid_579023 != nil:
    section.add "$.xgafv", valid_579023
  var valid_579024 = query.getOrDefault("alt")
  valid_579024 = validateParameter(valid_579024, JString, required = false,
                                 default = newJString("json"))
  if valid_579024 != nil:
    section.add "alt", valid_579024
  var valid_579025 = query.getOrDefault("uploadType")
  valid_579025 = validateParameter(valid_579025, JString, required = false,
                                 default = nil)
  if valid_579025 != nil:
    section.add "uploadType", valid_579025
  var valid_579026 = query.getOrDefault("quotaUser")
  valid_579026 = validateParameter(valid_579026, JString, required = false,
                                 default = nil)
  if valid_579026 != nil:
    section.add "quotaUser", valid_579026
  var valid_579027 = query.getOrDefault("callback")
  valid_579027 = validateParameter(valid_579027, JString, required = false,
                                 default = nil)
  if valid_579027 != nil:
    section.add "callback", valid_579027
  var valid_579028 = query.getOrDefault("fields")
  valid_579028 = validateParameter(valid_579028, JString, required = false,
                                 default = nil)
  if valid_579028 != nil:
    section.add "fields", valid_579028
  var valid_579029 = query.getOrDefault("access_token")
  valid_579029 = validateParameter(valid_579029, JString, required = false,
                                 default = nil)
  if valid_579029 != nil:
    section.add "access_token", valid_579029
  var valid_579030 = query.getOrDefault("upload_protocol")
  valid_579030 = validateParameter(valid_579030, JString, required = false,
                                 default = nil)
  if valid_579030 != nil:
    section.add "upload_protocol", valid_579030
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579031: Call_BigtableadminOperationsCancel_579016; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
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
  let valid = call_579031.validator(path, query, header, formData, body)
  let scheme = call_579031.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579031.url(scheme.get, call_579031.host, call_579031.base,
                         call_579031.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579031, url, valid)

proc call*(call_579032: Call_BigtableadminOperationsCancel_579016; name: string;
          key: string = ""; prettyPrint: bool = true; oauthToken: string = "";
          Xgafv: string = "1"; alt: string = "json"; uploadType: string = "";
          quotaUser: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminOperationsCancel
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
  var path_579033 = newJObject()
  var query_579034 = newJObject()
  add(query_579034, "key", newJString(key))
  add(query_579034, "prettyPrint", newJBool(prettyPrint))
  add(query_579034, "oauth_token", newJString(oauthToken))
  add(query_579034, "$.xgafv", newJString(Xgafv))
  add(query_579034, "alt", newJString(alt))
  add(query_579034, "uploadType", newJString(uploadType))
  add(query_579034, "quotaUser", newJString(quotaUser))
  add(path_579033, "name", newJString(name))
  add(query_579034, "callback", newJString(callback))
  add(query_579034, "fields", newJString(fields))
  add(query_579034, "access_token", newJString(accessToken))
  add(query_579034, "upload_protocol", newJString(uploadProtocol))
  result = call_579032.call(path_579033, query_579034, nil, nil, nil)

var bigtableadminOperationsCancel* = Call_BigtableadminOperationsCancel_579016(
    name: "bigtableadminOperationsCancel", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{name}:cancel",
    validator: validate_BigtableadminOperationsCancel_579017, base: "/",
    url: url_BigtableadminOperationsCancel_579018, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCheckConsistency_579035 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesTablesCheckConsistency_579037(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":checkConsistency")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesCheckConsistency_579036(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the Table for which to check replication consistency.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579038 = path.getOrDefault("name")
  valid_579038 = validateParameter(valid_579038, JString, required = true,
                                 default = nil)
  if valid_579038 != nil:
    section.add "name", valid_579038
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
  var valid_579039 = query.getOrDefault("key")
  valid_579039 = validateParameter(valid_579039, JString, required = false,
                                 default = nil)
  if valid_579039 != nil:
    section.add "key", valid_579039
  var valid_579040 = query.getOrDefault("prettyPrint")
  valid_579040 = validateParameter(valid_579040, JBool, required = false,
                                 default = newJBool(true))
  if valid_579040 != nil:
    section.add "prettyPrint", valid_579040
  var valid_579041 = query.getOrDefault("oauth_token")
  valid_579041 = validateParameter(valid_579041, JString, required = false,
                                 default = nil)
  if valid_579041 != nil:
    section.add "oauth_token", valid_579041
  var valid_579042 = query.getOrDefault("$.xgafv")
  valid_579042 = validateParameter(valid_579042, JString, required = false,
                                 default = newJString("1"))
  if valid_579042 != nil:
    section.add "$.xgafv", valid_579042
  var valid_579043 = query.getOrDefault("alt")
  valid_579043 = validateParameter(valid_579043, JString, required = false,
                                 default = newJString("json"))
  if valid_579043 != nil:
    section.add "alt", valid_579043
  var valid_579044 = query.getOrDefault("uploadType")
  valid_579044 = validateParameter(valid_579044, JString, required = false,
                                 default = nil)
  if valid_579044 != nil:
    section.add "uploadType", valid_579044
  var valid_579045 = query.getOrDefault("quotaUser")
  valid_579045 = validateParameter(valid_579045, JString, required = false,
                                 default = nil)
  if valid_579045 != nil:
    section.add "quotaUser", valid_579045
  var valid_579046 = query.getOrDefault("callback")
  valid_579046 = validateParameter(valid_579046, JString, required = false,
                                 default = nil)
  if valid_579046 != nil:
    section.add "callback", valid_579046
  var valid_579047 = query.getOrDefault("fields")
  valid_579047 = validateParameter(valid_579047, JString, required = false,
                                 default = nil)
  if valid_579047 != nil:
    section.add "fields", valid_579047
  var valid_579048 = query.getOrDefault("access_token")
  valid_579048 = validateParameter(valid_579048, JString, required = false,
                                 default = nil)
  if valid_579048 != nil:
    section.add "access_token", valid_579048
  var valid_579049 = query.getOrDefault("upload_protocol")
  valid_579049 = validateParameter(valid_579049, JString, required = false,
                                 default = nil)
  if valid_579049 != nil:
    section.add "upload_protocol", valid_579049
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

proc call*(call_579051: Call_BigtableadminProjectsInstancesTablesCheckConsistency_579035;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
  ## 
  let valid = call_579051.validator(path, query, header, formData, body)
  let scheme = call_579051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579051.url(scheme.get, call_579051.host, call_579051.base,
                         call_579051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579051, url, valid)

proc call*(call_579052: Call_BigtableadminProjectsInstancesTablesCheckConsistency_579035;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesTablesCheckConsistency
  ## Checks replication consistency based on a consistency token, that is, if
  ## replication has caught up based on the conditions specified in the token
  ## and the check request.
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
  ##       : The unique name of the Table for which to check replication consistency.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579053 = newJObject()
  var query_579054 = newJObject()
  var body_579055 = newJObject()
  add(query_579054, "key", newJString(key))
  add(query_579054, "prettyPrint", newJBool(prettyPrint))
  add(query_579054, "oauth_token", newJString(oauthToken))
  add(query_579054, "$.xgafv", newJString(Xgafv))
  add(query_579054, "alt", newJString(alt))
  add(query_579054, "uploadType", newJString(uploadType))
  add(query_579054, "quotaUser", newJString(quotaUser))
  add(path_579053, "name", newJString(name))
  if body != nil:
    body_579055 = body
  add(query_579054, "callback", newJString(callback))
  add(query_579054, "fields", newJString(fields))
  add(query_579054, "access_token", newJString(accessToken))
  add(query_579054, "upload_protocol", newJString(uploadProtocol))
  result = call_579052.call(path_579053, query_579054, nil, nil, body_579055)

var bigtableadminProjectsInstancesTablesCheckConsistency* = Call_BigtableadminProjectsInstancesTablesCheckConsistency_579035(
    name: "bigtableadminProjectsInstancesTablesCheckConsistency",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:checkConsistency",
    validator: validate_BigtableadminProjectsInstancesTablesCheckConsistency_579036,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCheckConsistency_579037,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesDropRowRange_579056 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesTablesDropRowRange_579058(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":dropRowRange")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesDropRowRange_579057(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the table on which to drop a range of rows.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579059 = path.getOrDefault("name")
  valid_579059 = validateParameter(valid_579059, JString, required = true,
                                 default = nil)
  if valid_579059 != nil:
    section.add "name", valid_579059
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
  var valid_579060 = query.getOrDefault("key")
  valid_579060 = validateParameter(valid_579060, JString, required = false,
                                 default = nil)
  if valid_579060 != nil:
    section.add "key", valid_579060
  var valid_579061 = query.getOrDefault("prettyPrint")
  valid_579061 = validateParameter(valid_579061, JBool, required = false,
                                 default = newJBool(true))
  if valid_579061 != nil:
    section.add "prettyPrint", valid_579061
  var valid_579062 = query.getOrDefault("oauth_token")
  valid_579062 = validateParameter(valid_579062, JString, required = false,
                                 default = nil)
  if valid_579062 != nil:
    section.add "oauth_token", valid_579062
  var valid_579063 = query.getOrDefault("$.xgafv")
  valid_579063 = validateParameter(valid_579063, JString, required = false,
                                 default = newJString("1"))
  if valid_579063 != nil:
    section.add "$.xgafv", valid_579063
  var valid_579064 = query.getOrDefault("alt")
  valid_579064 = validateParameter(valid_579064, JString, required = false,
                                 default = newJString("json"))
  if valid_579064 != nil:
    section.add "alt", valid_579064
  var valid_579065 = query.getOrDefault("uploadType")
  valid_579065 = validateParameter(valid_579065, JString, required = false,
                                 default = nil)
  if valid_579065 != nil:
    section.add "uploadType", valid_579065
  var valid_579066 = query.getOrDefault("quotaUser")
  valid_579066 = validateParameter(valid_579066, JString, required = false,
                                 default = nil)
  if valid_579066 != nil:
    section.add "quotaUser", valid_579066
  var valid_579067 = query.getOrDefault("callback")
  valid_579067 = validateParameter(valid_579067, JString, required = false,
                                 default = nil)
  if valid_579067 != nil:
    section.add "callback", valid_579067
  var valid_579068 = query.getOrDefault("fields")
  valid_579068 = validateParameter(valid_579068, JString, required = false,
                                 default = nil)
  if valid_579068 != nil:
    section.add "fields", valid_579068
  var valid_579069 = query.getOrDefault("access_token")
  valid_579069 = validateParameter(valid_579069, JString, required = false,
                                 default = nil)
  if valid_579069 != nil:
    section.add "access_token", valid_579069
  var valid_579070 = query.getOrDefault("upload_protocol")
  valid_579070 = validateParameter(valid_579070, JString, required = false,
                                 default = nil)
  if valid_579070 != nil:
    section.add "upload_protocol", valid_579070
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

proc call*(call_579072: Call_BigtableadminProjectsInstancesTablesDropRowRange_579056;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
  ## 
  let valid = call_579072.validator(path, query, header, formData, body)
  let scheme = call_579072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579072.url(scheme.get, call_579072.host, call_579072.base,
                         call_579072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579072, url, valid)

proc call*(call_579073: Call_BigtableadminProjectsInstancesTablesDropRowRange_579056;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesTablesDropRowRange
  ## Permanently drop/delete a row range from a specified table. The request can
  ## specify whether to delete all rows in a table, or only those that match a
  ## particular prefix.
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
  ##       : The unique name of the table on which to drop a range of rows.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579074 = newJObject()
  var query_579075 = newJObject()
  var body_579076 = newJObject()
  add(query_579075, "key", newJString(key))
  add(query_579075, "prettyPrint", newJBool(prettyPrint))
  add(query_579075, "oauth_token", newJString(oauthToken))
  add(query_579075, "$.xgafv", newJString(Xgafv))
  add(query_579075, "alt", newJString(alt))
  add(query_579075, "uploadType", newJString(uploadType))
  add(query_579075, "quotaUser", newJString(quotaUser))
  add(path_579074, "name", newJString(name))
  if body != nil:
    body_579076 = body
  add(query_579075, "callback", newJString(callback))
  add(query_579075, "fields", newJString(fields))
  add(query_579075, "access_token", newJString(accessToken))
  add(query_579075, "upload_protocol", newJString(uploadProtocol))
  result = call_579073.call(path_579074, query_579075, nil, nil, body_579076)

var bigtableadminProjectsInstancesTablesDropRowRange* = Call_BigtableadminProjectsInstancesTablesDropRowRange_579056(
    name: "bigtableadminProjectsInstancesTablesDropRowRange",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:dropRowRange",
    validator: validate_BigtableadminProjectsInstancesTablesDropRowRange_579057,
    base: "/", url: url_BigtableadminProjectsInstancesTablesDropRowRange_579058,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579077 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579079(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":generateConsistencyToken")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579078(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the Table for which to create a consistency token.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579080 = path.getOrDefault("name")
  valid_579080 = validateParameter(valid_579080, JString, required = true,
                                 default = nil)
  if valid_579080 != nil:
    section.add "name", valid_579080
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
  var valid_579081 = query.getOrDefault("key")
  valid_579081 = validateParameter(valid_579081, JString, required = false,
                                 default = nil)
  if valid_579081 != nil:
    section.add "key", valid_579081
  var valid_579082 = query.getOrDefault("prettyPrint")
  valid_579082 = validateParameter(valid_579082, JBool, required = false,
                                 default = newJBool(true))
  if valid_579082 != nil:
    section.add "prettyPrint", valid_579082
  var valid_579083 = query.getOrDefault("oauth_token")
  valid_579083 = validateParameter(valid_579083, JString, required = false,
                                 default = nil)
  if valid_579083 != nil:
    section.add "oauth_token", valid_579083
  var valid_579084 = query.getOrDefault("$.xgafv")
  valid_579084 = validateParameter(valid_579084, JString, required = false,
                                 default = newJString("1"))
  if valid_579084 != nil:
    section.add "$.xgafv", valid_579084
  var valid_579085 = query.getOrDefault("alt")
  valid_579085 = validateParameter(valid_579085, JString, required = false,
                                 default = newJString("json"))
  if valid_579085 != nil:
    section.add "alt", valid_579085
  var valid_579086 = query.getOrDefault("uploadType")
  valid_579086 = validateParameter(valid_579086, JString, required = false,
                                 default = nil)
  if valid_579086 != nil:
    section.add "uploadType", valid_579086
  var valid_579087 = query.getOrDefault("quotaUser")
  valid_579087 = validateParameter(valid_579087, JString, required = false,
                                 default = nil)
  if valid_579087 != nil:
    section.add "quotaUser", valid_579087
  var valid_579088 = query.getOrDefault("callback")
  valid_579088 = validateParameter(valid_579088, JString, required = false,
                                 default = nil)
  if valid_579088 != nil:
    section.add "callback", valid_579088
  var valid_579089 = query.getOrDefault("fields")
  valid_579089 = validateParameter(valid_579089, JString, required = false,
                                 default = nil)
  if valid_579089 != nil:
    section.add "fields", valid_579089
  var valid_579090 = query.getOrDefault("access_token")
  valid_579090 = validateParameter(valid_579090, JString, required = false,
                                 default = nil)
  if valid_579090 != nil:
    section.add "access_token", valid_579090
  var valid_579091 = query.getOrDefault("upload_protocol")
  valid_579091 = validateParameter(valid_579091, JString, required = false,
                                 default = nil)
  if valid_579091 != nil:
    section.add "upload_protocol", valid_579091
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

proc call*(call_579093: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579077;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
  ## 
  let valid = call_579093.validator(path, query, header, formData, body)
  let scheme = call_579093.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579093.url(scheme.get, call_579093.host, call_579093.base,
                         call_579093.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579093, url, valid)

proc call*(call_579094: Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579077;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesTablesGenerateConsistencyToken
  ## Generates a consistency token for a Table, which can be used in
  ## CheckConsistency to check whether mutations to the table that finished
  ## before this call started have been replicated. The tokens will be available
  ## for 90 days.
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
  ##       : The unique name of the Table for which to create a consistency token.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579095 = newJObject()
  var query_579096 = newJObject()
  var body_579097 = newJObject()
  add(query_579096, "key", newJString(key))
  add(query_579096, "prettyPrint", newJBool(prettyPrint))
  add(query_579096, "oauth_token", newJString(oauthToken))
  add(query_579096, "$.xgafv", newJString(Xgafv))
  add(query_579096, "alt", newJString(alt))
  add(query_579096, "uploadType", newJString(uploadType))
  add(query_579096, "quotaUser", newJString(quotaUser))
  add(path_579095, "name", newJString(name))
  if body != nil:
    body_579097 = body
  add(query_579096, "callback", newJString(callback))
  add(query_579096, "fields", newJString(fields))
  add(query_579096, "access_token", newJString(accessToken))
  add(query_579096, "upload_protocol", newJString(uploadProtocol))
  result = call_579094.call(path_579095, query_579096, nil, nil, body_579097)

var bigtableadminProjectsInstancesTablesGenerateConsistencyToken* = Call_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579077(
    name: "bigtableadminProjectsInstancesTablesGenerateConsistencyToken",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:generateConsistencyToken", validator: validate_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579078,
    base: "/",
    url: url_BigtableadminProjectsInstancesTablesGenerateConsistencyToken_579079,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579098 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579100(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":modifyColumnFamilies")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579099(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The unique name of the table whose families should be modified.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579101 = path.getOrDefault("name")
  valid_579101 = validateParameter(valid_579101, JString, required = true,
                                 default = nil)
  if valid_579101 != nil:
    section.add "name", valid_579101
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
  var valid_579102 = query.getOrDefault("key")
  valid_579102 = validateParameter(valid_579102, JString, required = false,
                                 default = nil)
  if valid_579102 != nil:
    section.add "key", valid_579102
  var valid_579103 = query.getOrDefault("prettyPrint")
  valid_579103 = validateParameter(valid_579103, JBool, required = false,
                                 default = newJBool(true))
  if valid_579103 != nil:
    section.add "prettyPrint", valid_579103
  var valid_579104 = query.getOrDefault("oauth_token")
  valid_579104 = validateParameter(valid_579104, JString, required = false,
                                 default = nil)
  if valid_579104 != nil:
    section.add "oauth_token", valid_579104
  var valid_579105 = query.getOrDefault("$.xgafv")
  valid_579105 = validateParameter(valid_579105, JString, required = false,
                                 default = newJString("1"))
  if valid_579105 != nil:
    section.add "$.xgafv", valid_579105
  var valid_579106 = query.getOrDefault("alt")
  valid_579106 = validateParameter(valid_579106, JString, required = false,
                                 default = newJString("json"))
  if valid_579106 != nil:
    section.add "alt", valid_579106
  var valid_579107 = query.getOrDefault("uploadType")
  valid_579107 = validateParameter(valid_579107, JString, required = false,
                                 default = nil)
  if valid_579107 != nil:
    section.add "uploadType", valid_579107
  var valid_579108 = query.getOrDefault("quotaUser")
  valid_579108 = validateParameter(valid_579108, JString, required = false,
                                 default = nil)
  if valid_579108 != nil:
    section.add "quotaUser", valid_579108
  var valid_579109 = query.getOrDefault("callback")
  valid_579109 = validateParameter(valid_579109, JString, required = false,
                                 default = nil)
  if valid_579109 != nil:
    section.add "callback", valid_579109
  var valid_579110 = query.getOrDefault("fields")
  valid_579110 = validateParameter(valid_579110, JString, required = false,
                                 default = nil)
  if valid_579110 != nil:
    section.add "fields", valid_579110
  var valid_579111 = query.getOrDefault("access_token")
  valid_579111 = validateParameter(valid_579111, JString, required = false,
                                 default = nil)
  if valid_579111 != nil:
    section.add "access_token", valid_579111
  var valid_579112 = query.getOrDefault("upload_protocol")
  valid_579112 = validateParameter(valid_579112, JString, required = false,
                                 default = nil)
  if valid_579112 != nil:
    section.add "upload_protocol", valid_579112
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

proc call*(call_579114: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579098;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
  ## 
  let valid = call_579114.validator(path, query, header, formData, body)
  let scheme = call_579114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579114.url(scheme.get, call_579114.host, call_579114.base,
                         call_579114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579114, url, valid)

proc call*(call_579115: Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579098;
          name: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesTablesModifyColumnFamilies
  ## Performs a series of column family modifications on the specified table.
  ## Either all or none of the modifications will occur before this method
  ## returns, but data requests received prior to that point may see a table
  ## where only some modifications have taken effect.
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
  ##       : The unique name of the table whose families should be modified.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>/tables/<table>`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579116 = newJObject()
  var query_579117 = newJObject()
  var body_579118 = newJObject()
  add(query_579117, "key", newJString(key))
  add(query_579117, "prettyPrint", newJBool(prettyPrint))
  add(query_579117, "oauth_token", newJString(oauthToken))
  add(query_579117, "$.xgafv", newJString(Xgafv))
  add(query_579117, "alt", newJString(alt))
  add(query_579117, "uploadType", newJString(uploadType))
  add(query_579117, "quotaUser", newJString(quotaUser))
  add(path_579116, "name", newJString(name))
  if body != nil:
    body_579118 = body
  add(query_579117, "callback", newJString(callback))
  add(query_579117, "fields", newJString(fields))
  add(query_579117, "access_token", newJString(accessToken))
  add(query_579117, "upload_protocol", newJString(uploadProtocol))
  result = call_579115.call(path_579116, query_579117, nil, nil, body_579118)

var bigtableadminProjectsInstancesTablesModifyColumnFamilies* = Call_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579098(
    name: "bigtableadminProjectsInstancesTablesModifyColumnFamilies",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{name}:modifyColumnFamilies", validator: validate_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579099,
    base: "/", url: url_BigtableadminProjectsInstancesTablesModifyColumnFamilies_579100,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesCreate_579140 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesAppProfilesCreate_579142(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/appProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesCreate_579141(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Creates an app profile within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the new app profile.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579143 = path.getOrDefault("parent")
  valid_579143 = validateParameter(valid_579143, JString, required = true,
                                 default = nil)
  if valid_579143 != nil:
    section.add "parent", valid_579143
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
  ##   ignoreWarnings: JBool
  ##                 : If true, ignore safety checks when creating the app profile.
  ##   callback: JString
  ##           : JSONP
  ##   appProfileId: JString
  ##               : The ID to be used when referring to the new app profile within its
  ## instance, e.g., just `myprofile` rather than
  ## `projects/myproject/instances/myinstance/appProfiles/myprofile`.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579144 = query.getOrDefault("key")
  valid_579144 = validateParameter(valid_579144, JString, required = false,
                                 default = nil)
  if valid_579144 != nil:
    section.add "key", valid_579144
  var valid_579145 = query.getOrDefault("prettyPrint")
  valid_579145 = validateParameter(valid_579145, JBool, required = false,
                                 default = newJBool(true))
  if valid_579145 != nil:
    section.add "prettyPrint", valid_579145
  var valid_579146 = query.getOrDefault("oauth_token")
  valid_579146 = validateParameter(valid_579146, JString, required = false,
                                 default = nil)
  if valid_579146 != nil:
    section.add "oauth_token", valid_579146
  var valid_579147 = query.getOrDefault("$.xgafv")
  valid_579147 = validateParameter(valid_579147, JString, required = false,
                                 default = newJString("1"))
  if valid_579147 != nil:
    section.add "$.xgafv", valid_579147
  var valid_579148 = query.getOrDefault("alt")
  valid_579148 = validateParameter(valid_579148, JString, required = false,
                                 default = newJString("json"))
  if valid_579148 != nil:
    section.add "alt", valid_579148
  var valid_579149 = query.getOrDefault("uploadType")
  valid_579149 = validateParameter(valid_579149, JString, required = false,
                                 default = nil)
  if valid_579149 != nil:
    section.add "uploadType", valid_579149
  var valid_579150 = query.getOrDefault("quotaUser")
  valid_579150 = validateParameter(valid_579150, JString, required = false,
                                 default = nil)
  if valid_579150 != nil:
    section.add "quotaUser", valid_579150
  var valid_579151 = query.getOrDefault("ignoreWarnings")
  valid_579151 = validateParameter(valid_579151, JBool, required = false, default = nil)
  if valid_579151 != nil:
    section.add "ignoreWarnings", valid_579151
  var valid_579152 = query.getOrDefault("callback")
  valid_579152 = validateParameter(valid_579152, JString, required = false,
                                 default = nil)
  if valid_579152 != nil:
    section.add "callback", valid_579152
  var valid_579153 = query.getOrDefault("appProfileId")
  valid_579153 = validateParameter(valid_579153, JString, required = false,
                                 default = nil)
  if valid_579153 != nil:
    section.add "appProfileId", valid_579153
  var valid_579154 = query.getOrDefault("fields")
  valid_579154 = validateParameter(valid_579154, JString, required = false,
                                 default = nil)
  if valid_579154 != nil:
    section.add "fields", valid_579154
  var valid_579155 = query.getOrDefault("access_token")
  valid_579155 = validateParameter(valid_579155, JString, required = false,
                                 default = nil)
  if valid_579155 != nil:
    section.add "access_token", valid_579155
  var valid_579156 = query.getOrDefault("upload_protocol")
  valid_579156 = validateParameter(valid_579156, JString, required = false,
                                 default = nil)
  if valid_579156 != nil:
    section.add "upload_protocol", valid_579156
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

proc call*(call_579158: Call_BigtableadminProjectsInstancesAppProfilesCreate_579140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates an app profile within an instance.
  ## 
  let valid = call_579158.validator(path, query, header, formData, body)
  let scheme = call_579158.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579158.url(scheme.get, call_579158.host, call_579158.base,
                         call_579158.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579158, url, valid)

proc call*(call_579159: Call_BigtableadminProjectsInstancesAppProfilesCreate_579140;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; ignoreWarnings: bool = false;
          body: JsonNode = nil; callback: string = ""; appProfileId: string = "";
          fields: string = ""; accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesCreate
  ## Creates an app profile within an instance.
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
  ##   ignoreWarnings: bool
  ##                 : If true, ignore safety checks when creating the app profile.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The unique name of the instance in which to create the new app profile.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ##   appProfileId: string
  ##               : The ID to be used when referring to the new app profile within its
  ## instance, e.g., just `myprofile` rather than
  ## `projects/myproject/instances/myinstance/appProfiles/myprofile`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579160 = newJObject()
  var query_579161 = newJObject()
  var body_579162 = newJObject()
  add(query_579161, "key", newJString(key))
  add(query_579161, "prettyPrint", newJBool(prettyPrint))
  add(query_579161, "oauth_token", newJString(oauthToken))
  add(query_579161, "$.xgafv", newJString(Xgafv))
  add(query_579161, "alt", newJString(alt))
  add(query_579161, "uploadType", newJString(uploadType))
  add(query_579161, "quotaUser", newJString(quotaUser))
  add(query_579161, "ignoreWarnings", newJBool(ignoreWarnings))
  if body != nil:
    body_579162 = body
  add(query_579161, "callback", newJString(callback))
  add(path_579160, "parent", newJString(parent))
  add(query_579161, "appProfileId", newJString(appProfileId))
  add(query_579161, "fields", newJString(fields))
  add(query_579161, "access_token", newJString(accessToken))
  add(query_579161, "upload_protocol", newJString(uploadProtocol))
  result = call_579159.call(path_579160, query_579161, nil, nil, body_579162)

var bigtableadminProjectsInstancesAppProfilesCreate* = Call_BigtableadminProjectsInstancesAppProfilesCreate_579140(
    name: "bigtableadminProjectsInstancesAppProfilesCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesCreate_579141,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesCreate_579142,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesAppProfilesList_579119 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesAppProfilesList_579121(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/appProfiles")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesAppProfilesList_579120(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Lists information about app profiles in an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which a list of app profiles is
  ## requested. Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list AppProfiles for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579122 = path.getOrDefault("parent")
  valid_579122 = validateParameter(valid_579122, JString, required = true,
                                 default = nil)
  if valid_579122 != nil:
    section.add "parent", valid_579122
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
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value of `next_page_token` returned by a previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579123 = query.getOrDefault("key")
  valid_579123 = validateParameter(valid_579123, JString, required = false,
                                 default = nil)
  if valid_579123 != nil:
    section.add "key", valid_579123
  var valid_579124 = query.getOrDefault("prettyPrint")
  valid_579124 = validateParameter(valid_579124, JBool, required = false,
                                 default = newJBool(true))
  if valid_579124 != nil:
    section.add "prettyPrint", valid_579124
  var valid_579125 = query.getOrDefault("oauth_token")
  valid_579125 = validateParameter(valid_579125, JString, required = false,
                                 default = nil)
  if valid_579125 != nil:
    section.add "oauth_token", valid_579125
  var valid_579126 = query.getOrDefault("$.xgafv")
  valid_579126 = validateParameter(valid_579126, JString, required = false,
                                 default = newJString("1"))
  if valid_579126 != nil:
    section.add "$.xgafv", valid_579126
  var valid_579127 = query.getOrDefault("pageSize")
  valid_579127 = validateParameter(valid_579127, JInt, required = false, default = nil)
  if valid_579127 != nil:
    section.add "pageSize", valid_579127
  var valid_579128 = query.getOrDefault("alt")
  valid_579128 = validateParameter(valid_579128, JString, required = false,
                                 default = newJString("json"))
  if valid_579128 != nil:
    section.add "alt", valid_579128
  var valid_579129 = query.getOrDefault("uploadType")
  valid_579129 = validateParameter(valid_579129, JString, required = false,
                                 default = nil)
  if valid_579129 != nil:
    section.add "uploadType", valid_579129
  var valid_579130 = query.getOrDefault("quotaUser")
  valid_579130 = validateParameter(valid_579130, JString, required = false,
                                 default = nil)
  if valid_579130 != nil:
    section.add "quotaUser", valid_579130
  var valid_579131 = query.getOrDefault("pageToken")
  valid_579131 = validateParameter(valid_579131, JString, required = false,
                                 default = nil)
  if valid_579131 != nil:
    section.add "pageToken", valid_579131
  var valid_579132 = query.getOrDefault("callback")
  valid_579132 = validateParameter(valid_579132, JString, required = false,
                                 default = nil)
  if valid_579132 != nil:
    section.add "callback", valid_579132
  var valid_579133 = query.getOrDefault("fields")
  valid_579133 = validateParameter(valid_579133, JString, required = false,
                                 default = nil)
  if valid_579133 != nil:
    section.add "fields", valid_579133
  var valid_579134 = query.getOrDefault("access_token")
  valid_579134 = validateParameter(valid_579134, JString, required = false,
                                 default = nil)
  if valid_579134 != nil:
    section.add "access_token", valid_579134
  var valid_579135 = query.getOrDefault("upload_protocol")
  valid_579135 = validateParameter(valid_579135, JString, required = false,
                                 default = nil)
  if valid_579135 != nil:
    section.add "upload_protocol", valid_579135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579136: Call_BigtableadminProjectsInstancesAppProfilesList_579119;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about app profiles in an instance.
  ## 
  let valid = call_579136.validator(path, query, header, formData, body)
  let scheme = call_579136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579136.url(scheme.get, call_579136.host, call_579136.base,
                         call_579136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579136, url, valid)

proc call*(call_579137: Call_BigtableadminProjectsInstancesAppProfilesList_579119;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesAppProfilesList
  ## Lists information about app profiles in an instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value of `next_page_token` returned by a previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The unique name of the instance for which a list of app profiles is
  ## requested. Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list AppProfiles for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579138 = newJObject()
  var query_579139 = newJObject()
  add(query_579139, "key", newJString(key))
  add(query_579139, "prettyPrint", newJBool(prettyPrint))
  add(query_579139, "oauth_token", newJString(oauthToken))
  add(query_579139, "$.xgafv", newJString(Xgafv))
  add(query_579139, "pageSize", newJInt(pageSize))
  add(query_579139, "alt", newJString(alt))
  add(query_579139, "uploadType", newJString(uploadType))
  add(query_579139, "quotaUser", newJString(quotaUser))
  add(query_579139, "pageToken", newJString(pageToken))
  add(query_579139, "callback", newJString(callback))
  add(path_579138, "parent", newJString(parent))
  add(query_579139, "fields", newJString(fields))
  add(query_579139, "access_token", newJString(accessToken))
  add(query_579139, "upload_protocol", newJString(uploadProtocol))
  result = call_579137.call(path_579138, query_579139, nil, nil, nil)

var bigtableadminProjectsInstancesAppProfilesList* = Call_BigtableadminProjectsInstancesAppProfilesList_579119(
    name: "bigtableadminProjectsInstancesAppProfilesList",
    meth: HttpMethod.HttpGet, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/appProfiles",
    validator: validate_BigtableadminProjectsInstancesAppProfilesList_579120,
    base: "/", url: url_BigtableadminProjectsInstancesAppProfilesList_579121,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersCreate_579183 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesClustersCreate_579185(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersCreate_579184(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a cluster within an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the new cluster.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579186 = path.getOrDefault("parent")
  valid_579186 = validateParameter(valid_579186, JString, required = true,
                                 default = nil)
  if valid_579186 != nil:
    section.add "parent", valid_579186
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
  ##   clusterId: JString
  ##            : The ID to be used when referring to the new cluster within its instance,
  ## e.g., just `mycluster` rather than
  ## `projects/myproject/instances/myinstance/clusters/mycluster`.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579187 = query.getOrDefault("key")
  valid_579187 = validateParameter(valid_579187, JString, required = false,
                                 default = nil)
  if valid_579187 != nil:
    section.add "key", valid_579187
  var valid_579188 = query.getOrDefault("prettyPrint")
  valid_579188 = validateParameter(valid_579188, JBool, required = false,
                                 default = newJBool(true))
  if valid_579188 != nil:
    section.add "prettyPrint", valid_579188
  var valid_579189 = query.getOrDefault("oauth_token")
  valid_579189 = validateParameter(valid_579189, JString, required = false,
                                 default = nil)
  if valid_579189 != nil:
    section.add "oauth_token", valid_579189
  var valid_579190 = query.getOrDefault("$.xgafv")
  valid_579190 = validateParameter(valid_579190, JString, required = false,
                                 default = newJString("1"))
  if valid_579190 != nil:
    section.add "$.xgafv", valid_579190
  var valid_579191 = query.getOrDefault("alt")
  valid_579191 = validateParameter(valid_579191, JString, required = false,
                                 default = newJString("json"))
  if valid_579191 != nil:
    section.add "alt", valid_579191
  var valid_579192 = query.getOrDefault("uploadType")
  valid_579192 = validateParameter(valid_579192, JString, required = false,
                                 default = nil)
  if valid_579192 != nil:
    section.add "uploadType", valid_579192
  var valid_579193 = query.getOrDefault("quotaUser")
  valid_579193 = validateParameter(valid_579193, JString, required = false,
                                 default = nil)
  if valid_579193 != nil:
    section.add "quotaUser", valid_579193
  var valid_579194 = query.getOrDefault("clusterId")
  valid_579194 = validateParameter(valid_579194, JString, required = false,
                                 default = nil)
  if valid_579194 != nil:
    section.add "clusterId", valid_579194
  var valid_579195 = query.getOrDefault("callback")
  valid_579195 = validateParameter(valid_579195, JString, required = false,
                                 default = nil)
  if valid_579195 != nil:
    section.add "callback", valid_579195
  var valid_579196 = query.getOrDefault("fields")
  valid_579196 = validateParameter(valid_579196, JString, required = false,
                                 default = nil)
  if valid_579196 != nil:
    section.add "fields", valid_579196
  var valid_579197 = query.getOrDefault("access_token")
  valid_579197 = validateParameter(valid_579197, JString, required = false,
                                 default = nil)
  if valid_579197 != nil:
    section.add "access_token", valid_579197
  var valid_579198 = query.getOrDefault("upload_protocol")
  valid_579198 = validateParameter(valid_579198, JString, required = false,
                                 default = nil)
  if valid_579198 != nil:
    section.add "upload_protocol", valid_579198
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

proc call*(call_579200: Call_BigtableadminProjectsInstancesClustersCreate_579183;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a cluster within an instance.
  ## 
  let valid = call_579200.validator(path, query, header, formData, body)
  let scheme = call_579200.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579200.url(scheme.get, call_579200.host, call_579200.base,
                         call_579200.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579200, url, valid)

proc call*(call_579201: Call_BigtableadminProjectsInstancesClustersCreate_579183;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; clusterId: string = "";
          body: JsonNode = nil; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesClustersCreate
  ## Creates a cluster within an instance.
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
  ##   clusterId: string
  ##            : The ID to be used when referring to the new cluster within its instance,
  ## e.g., just `mycluster` rather than
  ## `projects/myproject/instances/myinstance/clusters/mycluster`.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The unique name of the instance in which to create the new cluster.
  ## Values are of the form
  ## `projects/<project>/instances/<instance>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579202 = newJObject()
  var query_579203 = newJObject()
  var body_579204 = newJObject()
  add(query_579203, "key", newJString(key))
  add(query_579203, "prettyPrint", newJBool(prettyPrint))
  add(query_579203, "oauth_token", newJString(oauthToken))
  add(query_579203, "$.xgafv", newJString(Xgafv))
  add(query_579203, "alt", newJString(alt))
  add(query_579203, "uploadType", newJString(uploadType))
  add(query_579203, "quotaUser", newJString(quotaUser))
  add(query_579203, "clusterId", newJString(clusterId))
  if body != nil:
    body_579204 = body
  add(query_579203, "callback", newJString(callback))
  add(path_579202, "parent", newJString(parent))
  add(query_579203, "fields", newJString(fields))
  add(query_579203, "access_token", newJString(accessToken))
  add(query_579203, "upload_protocol", newJString(uploadProtocol))
  result = call_579201.call(path_579202, query_579203, nil, nil, body_579204)

var bigtableadminProjectsInstancesClustersCreate* = Call_BigtableadminProjectsInstancesClustersCreate_579183(
    name: "bigtableadminProjectsInstancesClustersCreate",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersCreate_579184,
    base: "/", url: url_BigtableadminProjectsInstancesClustersCreate_579185,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesClustersList_579163 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesClustersList_579165(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/clusters")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesClustersList_579164(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about clusters in an instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which a list of clusters is requested.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list Clusters for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579166 = path.getOrDefault("parent")
  valid_579166 = validateParameter(valid_579166, JString, required = true,
                                 default = nil)
  if valid_579166 != nil:
    section.add "parent", valid_579166
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
  ##   pageToken: JString
  ##            : DEPRECATED: This field is unused and ignored.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579167 = query.getOrDefault("key")
  valid_579167 = validateParameter(valid_579167, JString, required = false,
                                 default = nil)
  if valid_579167 != nil:
    section.add "key", valid_579167
  var valid_579168 = query.getOrDefault("prettyPrint")
  valid_579168 = validateParameter(valid_579168, JBool, required = false,
                                 default = newJBool(true))
  if valid_579168 != nil:
    section.add "prettyPrint", valid_579168
  var valid_579169 = query.getOrDefault("oauth_token")
  valid_579169 = validateParameter(valid_579169, JString, required = false,
                                 default = nil)
  if valid_579169 != nil:
    section.add "oauth_token", valid_579169
  var valid_579170 = query.getOrDefault("$.xgafv")
  valid_579170 = validateParameter(valid_579170, JString, required = false,
                                 default = newJString("1"))
  if valid_579170 != nil:
    section.add "$.xgafv", valid_579170
  var valid_579171 = query.getOrDefault("alt")
  valid_579171 = validateParameter(valid_579171, JString, required = false,
                                 default = newJString("json"))
  if valid_579171 != nil:
    section.add "alt", valid_579171
  var valid_579172 = query.getOrDefault("uploadType")
  valid_579172 = validateParameter(valid_579172, JString, required = false,
                                 default = nil)
  if valid_579172 != nil:
    section.add "uploadType", valid_579172
  var valid_579173 = query.getOrDefault("quotaUser")
  valid_579173 = validateParameter(valid_579173, JString, required = false,
                                 default = nil)
  if valid_579173 != nil:
    section.add "quotaUser", valid_579173
  var valid_579174 = query.getOrDefault("pageToken")
  valid_579174 = validateParameter(valid_579174, JString, required = false,
                                 default = nil)
  if valid_579174 != nil:
    section.add "pageToken", valid_579174
  var valid_579175 = query.getOrDefault("callback")
  valid_579175 = validateParameter(valid_579175, JString, required = false,
                                 default = nil)
  if valid_579175 != nil:
    section.add "callback", valid_579175
  var valid_579176 = query.getOrDefault("fields")
  valid_579176 = validateParameter(valid_579176, JString, required = false,
                                 default = nil)
  if valid_579176 != nil:
    section.add "fields", valid_579176
  var valid_579177 = query.getOrDefault("access_token")
  valid_579177 = validateParameter(valid_579177, JString, required = false,
                                 default = nil)
  if valid_579177 != nil:
    section.add "access_token", valid_579177
  var valid_579178 = query.getOrDefault("upload_protocol")
  valid_579178 = validateParameter(valid_579178, JString, required = false,
                                 default = nil)
  if valid_579178 != nil:
    section.add "upload_protocol", valid_579178
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579179: Call_BigtableadminProjectsInstancesClustersList_579163;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about clusters in an instance.
  ## 
  let valid = call_579179.validator(path, query, header, formData, body)
  let scheme = call_579179.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579179.url(scheme.get, call_579179.host, call_579179.base,
                         call_579179.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579179, url, valid)

proc call*(call_579180: Call_BigtableadminProjectsInstancesClustersList_579163;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesClustersList
  ## Lists information about clusters in an instance.
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
  ##   pageToken: string
  ##            : DEPRECATED: This field is unused and ignored.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The unique name of the instance for which a list of clusters is requested.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ## Use `<instance> = '-'` to list Clusters for all Instances in a project,
  ## e.g., `projects/myproject/instances/-`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579181 = newJObject()
  var query_579182 = newJObject()
  add(query_579182, "key", newJString(key))
  add(query_579182, "prettyPrint", newJBool(prettyPrint))
  add(query_579182, "oauth_token", newJString(oauthToken))
  add(query_579182, "$.xgafv", newJString(Xgafv))
  add(query_579182, "alt", newJString(alt))
  add(query_579182, "uploadType", newJString(uploadType))
  add(query_579182, "quotaUser", newJString(quotaUser))
  add(query_579182, "pageToken", newJString(pageToken))
  add(query_579182, "callback", newJString(callback))
  add(path_579181, "parent", newJString(parent))
  add(query_579182, "fields", newJString(fields))
  add(query_579182, "access_token", newJString(accessToken))
  add(query_579182, "upload_protocol", newJString(uploadProtocol))
  result = call_579180.call(path_579181, query_579182, nil, nil, nil)

var bigtableadminProjectsInstancesClustersList* = Call_BigtableadminProjectsInstancesClustersList_579163(
    name: "bigtableadminProjectsInstancesClustersList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/clusters",
    validator: validate_BigtableadminProjectsInstancesClustersList_579164,
    base: "/", url: url_BigtableadminProjectsInstancesClustersList_579165,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesCreate_579225 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesCreate_579227(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesCreate_579226(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Create an instance within a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the project in which to create the new instance.
  ## Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579228 = path.getOrDefault("parent")
  valid_579228 = validateParameter(valid_579228, JString, required = true,
                                 default = nil)
  if valid_579228 != nil:
    section.add "parent", valid_579228
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
  var valid_579229 = query.getOrDefault("key")
  valid_579229 = validateParameter(valid_579229, JString, required = false,
                                 default = nil)
  if valid_579229 != nil:
    section.add "key", valid_579229
  var valid_579230 = query.getOrDefault("prettyPrint")
  valid_579230 = validateParameter(valid_579230, JBool, required = false,
                                 default = newJBool(true))
  if valid_579230 != nil:
    section.add "prettyPrint", valid_579230
  var valid_579231 = query.getOrDefault("oauth_token")
  valid_579231 = validateParameter(valid_579231, JString, required = false,
                                 default = nil)
  if valid_579231 != nil:
    section.add "oauth_token", valid_579231
  var valid_579232 = query.getOrDefault("$.xgafv")
  valid_579232 = validateParameter(valid_579232, JString, required = false,
                                 default = newJString("1"))
  if valid_579232 != nil:
    section.add "$.xgafv", valid_579232
  var valid_579233 = query.getOrDefault("alt")
  valid_579233 = validateParameter(valid_579233, JString, required = false,
                                 default = newJString("json"))
  if valid_579233 != nil:
    section.add "alt", valid_579233
  var valid_579234 = query.getOrDefault("uploadType")
  valid_579234 = validateParameter(valid_579234, JString, required = false,
                                 default = nil)
  if valid_579234 != nil:
    section.add "uploadType", valid_579234
  var valid_579235 = query.getOrDefault("quotaUser")
  valid_579235 = validateParameter(valid_579235, JString, required = false,
                                 default = nil)
  if valid_579235 != nil:
    section.add "quotaUser", valid_579235
  var valid_579236 = query.getOrDefault("callback")
  valid_579236 = validateParameter(valid_579236, JString, required = false,
                                 default = nil)
  if valid_579236 != nil:
    section.add "callback", valid_579236
  var valid_579237 = query.getOrDefault("fields")
  valid_579237 = validateParameter(valid_579237, JString, required = false,
                                 default = nil)
  if valid_579237 != nil:
    section.add "fields", valid_579237
  var valid_579238 = query.getOrDefault("access_token")
  valid_579238 = validateParameter(valid_579238, JString, required = false,
                                 default = nil)
  if valid_579238 != nil:
    section.add "access_token", valid_579238
  var valid_579239 = query.getOrDefault("upload_protocol")
  valid_579239 = validateParameter(valid_579239, JString, required = false,
                                 default = nil)
  if valid_579239 != nil:
    section.add "upload_protocol", valid_579239
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

proc call*(call_579241: Call_BigtableadminProjectsInstancesCreate_579225;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Create an instance within a project.
  ## 
  let valid = call_579241.validator(path, query, header, formData, body)
  let scheme = call_579241.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579241.url(scheme.get, call_579241.host, call_579241.base,
                         call_579241.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579241, url, valid)

proc call*(call_579242: Call_BigtableadminProjectsInstancesCreate_579225;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesCreate
  ## Create an instance within a project.
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
  ##         : The unique name of the project in which to create the new instance.
  ## Values are of the form `projects/<project>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579243 = newJObject()
  var query_579244 = newJObject()
  var body_579245 = newJObject()
  add(query_579244, "key", newJString(key))
  add(query_579244, "prettyPrint", newJBool(prettyPrint))
  add(query_579244, "oauth_token", newJString(oauthToken))
  add(query_579244, "$.xgafv", newJString(Xgafv))
  add(query_579244, "alt", newJString(alt))
  add(query_579244, "uploadType", newJString(uploadType))
  add(query_579244, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579245 = body
  add(query_579244, "callback", newJString(callback))
  add(path_579243, "parent", newJString(parent))
  add(query_579244, "fields", newJString(fields))
  add(query_579244, "access_token", newJString(accessToken))
  add(query_579244, "upload_protocol", newJString(uploadProtocol))
  result = call_579242.call(path_579243, query_579244, nil, nil, body_579245)

var bigtableadminProjectsInstancesCreate* = Call_BigtableadminProjectsInstancesCreate_579225(
    name: "bigtableadminProjectsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesCreate_579226, base: "/",
    url: url_BigtableadminProjectsInstancesCreate_579227, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesList_579205 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesList_579207(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesList_579206(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about instances in a project.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the project for which a list of instances is requested.
  ## Values are of the form `projects/<project>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579208 = path.getOrDefault("parent")
  valid_579208 = validateParameter(valid_579208, JString, required = true,
                                 default = nil)
  if valid_579208 != nil:
    section.add "parent", valid_579208
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
  ##   pageToken: JString
  ##            : DEPRECATED: This field is unused and ignored.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  section = newJObject()
  var valid_579209 = query.getOrDefault("key")
  valid_579209 = validateParameter(valid_579209, JString, required = false,
                                 default = nil)
  if valid_579209 != nil:
    section.add "key", valid_579209
  var valid_579210 = query.getOrDefault("prettyPrint")
  valid_579210 = validateParameter(valid_579210, JBool, required = false,
                                 default = newJBool(true))
  if valid_579210 != nil:
    section.add "prettyPrint", valid_579210
  var valid_579211 = query.getOrDefault("oauth_token")
  valid_579211 = validateParameter(valid_579211, JString, required = false,
                                 default = nil)
  if valid_579211 != nil:
    section.add "oauth_token", valid_579211
  var valid_579212 = query.getOrDefault("$.xgafv")
  valid_579212 = validateParameter(valid_579212, JString, required = false,
                                 default = newJString("1"))
  if valid_579212 != nil:
    section.add "$.xgafv", valid_579212
  var valid_579213 = query.getOrDefault("alt")
  valid_579213 = validateParameter(valid_579213, JString, required = false,
                                 default = newJString("json"))
  if valid_579213 != nil:
    section.add "alt", valid_579213
  var valid_579214 = query.getOrDefault("uploadType")
  valid_579214 = validateParameter(valid_579214, JString, required = false,
                                 default = nil)
  if valid_579214 != nil:
    section.add "uploadType", valid_579214
  var valid_579215 = query.getOrDefault("quotaUser")
  valid_579215 = validateParameter(valid_579215, JString, required = false,
                                 default = nil)
  if valid_579215 != nil:
    section.add "quotaUser", valid_579215
  var valid_579216 = query.getOrDefault("pageToken")
  valid_579216 = validateParameter(valid_579216, JString, required = false,
                                 default = nil)
  if valid_579216 != nil:
    section.add "pageToken", valid_579216
  var valid_579217 = query.getOrDefault("callback")
  valid_579217 = validateParameter(valid_579217, JString, required = false,
                                 default = nil)
  if valid_579217 != nil:
    section.add "callback", valid_579217
  var valid_579218 = query.getOrDefault("fields")
  valid_579218 = validateParameter(valid_579218, JString, required = false,
                                 default = nil)
  if valid_579218 != nil:
    section.add "fields", valid_579218
  var valid_579219 = query.getOrDefault("access_token")
  valid_579219 = validateParameter(valid_579219, JString, required = false,
                                 default = nil)
  if valid_579219 != nil:
    section.add "access_token", valid_579219
  var valid_579220 = query.getOrDefault("upload_protocol")
  valid_579220 = validateParameter(valid_579220, JString, required = false,
                                 default = nil)
  if valid_579220 != nil:
    section.add "upload_protocol", valid_579220
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579221: Call_BigtableadminProjectsInstancesList_579205;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists information about instances in a project.
  ## 
  let valid = call_579221.validator(path, query, header, formData, body)
  let scheme = call_579221.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579221.url(scheme.get, call_579221.host, call_579221.base,
                         call_579221.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579221, url, valid)

proc call*(call_579222: Call_BigtableadminProjectsInstancesList_579205;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; pageToken: string = "";
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesList
  ## Lists information about instances in a project.
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
  ##   pageToken: string
  ##            : DEPRECATED: This field is unused and ignored.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The unique name of the project for which a list of instances is requested.
  ## Values are of the form `projects/<project>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579223 = newJObject()
  var query_579224 = newJObject()
  add(query_579224, "key", newJString(key))
  add(query_579224, "prettyPrint", newJBool(prettyPrint))
  add(query_579224, "oauth_token", newJString(oauthToken))
  add(query_579224, "$.xgafv", newJString(Xgafv))
  add(query_579224, "alt", newJString(alt))
  add(query_579224, "uploadType", newJString(uploadType))
  add(query_579224, "quotaUser", newJString(quotaUser))
  add(query_579224, "pageToken", newJString(pageToken))
  add(query_579224, "callback", newJString(callback))
  add(path_579223, "parent", newJString(parent))
  add(query_579224, "fields", newJString(fields))
  add(query_579224, "access_token", newJString(accessToken))
  add(query_579224, "upload_protocol", newJString(uploadProtocol))
  result = call_579222.call(path_579223, query_579224, nil, nil, nil)

var bigtableadminProjectsInstancesList* = Call_BigtableadminProjectsInstancesList_579205(
    name: "bigtableadminProjectsInstancesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/instances",
    validator: validate_BigtableadminProjectsInstancesList_579206, base: "/",
    url: url_BigtableadminProjectsInstancesList_579207, schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesCreate_579268 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesTablesCreate_579270(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesCreate_579269(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance in which to create the table.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579271 = path.getOrDefault("parent")
  valid_579271 = validateParameter(valid_579271, JString, required = true,
                                 default = nil)
  if valid_579271 != nil:
    section.add "parent", valid_579271
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
  var valid_579272 = query.getOrDefault("key")
  valid_579272 = validateParameter(valid_579272, JString, required = false,
                                 default = nil)
  if valid_579272 != nil:
    section.add "key", valid_579272
  var valid_579273 = query.getOrDefault("prettyPrint")
  valid_579273 = validateParameter(valid_579273, JBool, required = false,
                                 default = newJBool(true))
  if valid_579273 != nil:
    section.add "prettyPrint", valid_579273
  var valid_579274 = query.getOrDefault("oauth_token")
  valid_579274 = validateParameter(valid_579274, JString, required = false,
                                 default = nil)
  if valid_579274 != nil:
    section.add "oauth_token", valid_579274
  var valid_579275 = query.getOrDefault("$.xgafv")
  valid_579275 = validateParameter(valid_579275, JString, required = false,
                                 default = newJString("1"))
  if valid_579275 != nil:
    section.add "$.xgafv", valid_579275
  var valid_579276 = query.getOrDefault("alt")
  valid_579276 = validateParameter(valid_579276, JString, required = false,
                                 default = newJString("json"))
  if valid_579276 != nil:
    section.add "alt", valid_579276
  var valid_579277 = query.getOrDefault("uploadType")
  valid_579277 = validateParameter(valid_579277, JString, required = false,
                                 default = nil)
  if valid_579277 != nil:
    section.add "uploadType", valid_579277
  var valid_579278 = query.getOrDefault("quotaUser")
  valid_579278 = validateParameter(valid_579278, JString, required = false,
                                 default = nil)
  if valid_579278 != nil:
    section.add "quotaUser", valid_579278
  var valid_579279 = query.getOrDefault("callback")
  valid_579279 = validateParameter(valid_579279, JString, required = false,
                                 default = nil)
  if valid_579279 != nil:
    section.add "callback", valid_579279
  var valid_579280 = query.getOrDefault("fields")
  valid_579280 = validateParameter(valid_579280, JString, required = false,
                                 default = nil)
  if valid_579280 != nil:
    section.add "fields", valid_579280
  var valid_579281 = query.getOrDefault("access_token")
  valid_579281 = validateParameter(valid_579281, JString, required = false,
                                 default = nil)
  if valid_579281 != nil:
    section.add "access_token", valid_579281
  var valid_579282 = query.getOrDefault("upload_protocol")
  valid_579282 = validateParameter(valid_579282, JString, required = false,
                                 default = nil)
  if valid_579282 != nil:
    section.add "upload_protocol", valid_579282
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

proc call*(call_579284: Call_BigtableadminProjectsInstancesTablesCreate_579268;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
  ## 
  let valid = call_579284.validator(path, query, header, formData, body)
  let scheme = call_579284.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579284.url(scheme.get, call_579284.host, call_579284.base,
                         call_579284.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579284, url, valid)

proc call*(call_579285: Call_BigtableadminProjectsInstancesTablesCreate_579268;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesTablesCreate
  ## Creates a new table in the specified instance.
  ## The table can be created with a full set of initial column families,
  ## specified in the request.
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
  ##         : The unique name of the instance in which to create the table.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579286 = newJObject()
  var query_579287 = newJObject()
  var body_579288 = newJObject()
  add(query_579287, "key", newJString(key))
  add(query_579287, "prettyPrint", newJBool(prettyPrint))
  add(query_579287, "oauth_token", newJString(oauthToken))
  add(query_579287, "$.xgafv", newJString(Xgafv))
  add(query_579287, "alt", newJString(alt))
  add(query_579287, "uploadType", newJString(uploadType))
  add(query_579287, "quotaUser", newJString(quotaUser))
  if body != nil:
    body_579288 = body
  add(query_579287, "callback", newJString(callback))
  add(path_579286, "parent", newJString(parent))
  add(query_579287, "fields", newJString(fields))
  add(query_579287, "access_token", newJString(accessToken))
  add(query_579287, "upload_protocol", newJString(uploadProtocol))
  result = call_579285.call(path_579286, query_579287, nil, nil, body_579288)

var bigtableadminProjectsInstancesTablesCreate* = Call_BigtableadminProjectsInstancesTablesCreate_579268(
    name: "bigtableadminProjectsInstancesTablesCreate", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesCreate_579269,
    base: "/", url: url_BigtableadminProjectsInstancesTablesCreate_579270,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTablesList_579246 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesTablesList_579248(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/tables")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTablesList_579247(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all tables served from a specified instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : The unique name of the instance for which tables should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_579249 = path.getOrDefault("parent")
  valid_579249 = validateParameter(valid_579249, JString, required = true,
                                 default = nil)
  if valid_579249 != nil:
    section.add "parent", valid_579249
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
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   alt: JString
  ##      : Data format for response.
  ##   uploadType: JString
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: JString
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: JString
  ##            : The value of `next_page_token` returned by a previous call.
  ##   callback: JString
  ##           : JSONP
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   access_token: JString
  ##               : OAuth access token.
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: JString
  ##       : The view to be applied to the returned tables' fields.
  ## Defaults to `NAME_ONLY` if unspecified; no others are currently supported.
  section = newJObject()
  var valid_579250 = query.getOrDefault("key")
  valid_579250 = validateParameter(valid_579250, JString, required = false,
                                 default = nil)
  if valid_579250 != nil:
    section.add "key", valid_579250
  var valid_579251 = query.getOrDefault("prettyPrint")
  valid_579251 = validateParameter(valid_579251, JBool, required = false,
                                 default = newJBool(true))
  if valid_579251 != nil:
    section.add "prettyPrint", valid_579251
  var valid_579252 = query.getOrDefault("oauth_token")
  valid_579252 = validateParameter(valid_579252, JString, required = false,
                                 default = nil)
  if valid_579252 != nil:
    section.add "oauth_token", valid_579252
  var valid_579253 = query.getOrDefault("$.xgafv")
  valid_579253 = validateParameter(valid_579253, JString, required = false,
                                 default = newJString("1"))
  if valid_579253 != nil:
    section.add "$.xgafv", valid_579253
  var valid_579254 = query.getOrDefault("pageSize")
  valid_579254 = validateParameter(valid_579254, JInt, required = false, default = nil)
  if valid_579254 != nil:
    section.add "pageSize", valid_579254
  var valid_579255 = query.getOrDefault("alt")
  valid_579255 = validateParameter(valid_579255, JString, required = false,
                                 default = newJString("json"))
  if valid_579255 != nil:
    section.add "alt", valid_579255
  var valid_579256 = query.getOrDefault("uploadType")
  valid_579256 = validateParameter(valid_579256, JString, required = false,
                                 default = nil)
  if valid_579256 != nil:
    section.add "uploadType", valid_579256
  var valid_579257 = query.getOrDefault("quotaUser")
  valid_579257 = validateParameter(valid_579257, JString, required = false,
                                 default = nil)
  if valid_579257 != nil:
    section.add "quotaUser", valid_579257
  var valid_579258 = query.getOrDefault("pageToken")
  valid_579258 = validateParameter(valid_579258, JString, required = false,
                                 default = nil)
  if valid_579258 != nil:
    section.add "pageToken", valid_579258
  var valid_579259 = query.getOrDefault("callback")
  valid_579259 = validateParameter(valid_579259, JString, required = false,
                                 default = nil)
  if valid_579259 != nil:
    section.add "callback", valid_579259
  var valid_579260 = query.getOrDefault("fields")
  valid_579260 = validateParameter(valid_579260, JString, required = false,
                                 default = nil)
  if valid_579260 != nil:
    section.add "fields", valid_579260
  var valid_579261 = query.getOrDefault("access_token")
  valid_579261 = validateParameter(valid_579261, JString, required = false,
                                 default = nil)
  if valid_579261 != nil:
    section.add "access_token", valid_579261
  var valid_579262 = query.getOrDefault("upload_protocol")
  valid_579262 = validateParameter(valid_579262, JString, required = false,
                                 default = nil)
  if valid_579262 != nil:
    section.add "upload_protocol", valid_579262
  var valid_579263 = query.getOrDefault("view")
  valid_579263 = validateParameter(valid_579263, JString, required = false,
                                 default = newJString("VIEW_UNSPECIFIED"))
  if valid_579263 != nil:
    section.add "view", valid_579263
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579264: Call_BigtableadminProjectsInstancesTablesList_579246;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all tables served from a specified instance.
  ## 
  let valid = call_579264.validator(path, query, header, formData, body)
  let scheme = call_579264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579264.url(scheme.get, call_579264.host, call_579264.base,
                         call_579264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579264, url, valid)

proc call*(call_579265: Call_BigtableadminProjectsInstancesTablesList_579246;
          parent: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          alt: string = "json"; uploadType: string = ""; quotaUser: string = "";
          pageToken: string = ""; callback: string = ""; fields: string = "";
          accessToken: string = ""; uploadProtocol: string = "";
          view: string = "VIEW_UNSPECIFIED"): Recallable =
  ## bigtableadminProjectsInstancesTablesList
  ## Lists all tables served from a specified instance.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : Maximum number of results per page.
  ## 
  ## A page_size of zero lets the server choose the number of items to return.
  ## A page_size which is strictly positive will return at most that many items.
  ## A negative page_size will cause an error.
  ## 
  ## Following the first request, subsequent paginated calls are not required
  ## to pass a page_size. If a page_size is set in subsequent calls, it must
  ## match the page_size given in the first request.
  ##   alt: string
  ##      : Data format for response.
  ##   uploadType: string
  ##             : Legacy upload protocol for media (e.g. "media", "multipart").
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   pageToken: string
  ##            : The value of `next_page_token` returned by a previous call.
  ##   callback: string
  ##           : JSONP
  ##   parent: string (required)
  ##         : The unique name of the instance for which tables should be listed.
  ## Values are of the form `projects/<project>/instances/<instance>`.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   view: string
  ##       : The view to be applied to the returned tables' fields.
  ## Defaults to `NAME_ONLY` if unspecified; no others are currently supported.
  var path_579266 = newJObject()
  var query_579267 = newJObject()
  add(query_579267, "key", newJString(key))
  add(query_579267, "prettyPrint", newJBool(prettyPrint))
  add(query_579267, "oauth_token", newJString(oauthToken))
  add(query_579267, "$.xgafv", newJString(Xgafv))
  add(query_579267, "pageSize", newJInt(pageSize))
  add(query_579267, "alt", newJString(alt))
  add(query_579267, "uploadType", newJString(uploadType))
  add(query_579267, "quotaUser", newJString(quotaUser))
  add(query_579267, "pageToken", newJString(pageToken))
  add(query_579267, "callback", newJString(callback))
  add(path_579266, "parent", newJString(parent))
  add(query_579267, "fields", newJString(fields))
  add(query_579267, "access_token", newJString(accessToken))
  add(query_579267, "upload_protocol", newJString(uploadProtocol))
  add(query_579267, "view", newJString(view))
  result = call_579265.call(path_579266, query_579267, nil, nil, nil)

var bigtableadminProjectsInstancesTablesList* = Call_BigtableadminProjectsInstancesTablesList_579246(
    name: "bigtableadminProjectsInstancesTablesList", meth: HttpMethod.HttpGet,
    host: "bigtableadmin.googleapis.com", route: "/v2/{parent}/tables",
    validator: validate_BigtableadminProjectsInstancesTablesList_579247,
    base: "/", url: url_BigtableadminProjectsInstancesTablesList_579248,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesGetIamPolicy_579289 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesGetIamPolicy_579291(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":getIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesGetIamPolicy_579290(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579292 = path.getOrDefault("resource")
  valid_579292 = validateParameter(valid_579292, JString, required = true,
                                 default = nil)
  if valid_579292 != nil:
    section.add "resource", valid_579292
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
  var valid_579293 = query.getOrDefault("key")
  valid_579293 = validateParameter(valid_579293, JString, required = false,
                                 default = nil)
  if valid_579293 != nil:
    section.add "key", valid_579293
  var valid_579294 = query.getOrDefault("prettyPrint")
  valid_579294 = validateParameter(valid_579294, JBool, required = false,
                                 default = newJBool(true))
  if valid_579294 != nil:
    section.add "prettyPrint", valid_579294
  var valid_579295 = query.getOrDefault("oauth_token")
  valid_579295 = validateParameter(valid_579295, JString, required = false,
                                 default = nil)
  if valid_579295 != nil:
    section.add "oauth_token", valid_579295
  var valid_579296 = query.getOrDefault("$.xgafv")
  valid_579296 = validateParameter(valid_579296, JString, required = false,
                                 default = newJString("1"))
  if valid_579296 != nil:
    section.add "$.xgafv", valid_579296
  var valid_579297 = query.getOrDefault("alt")
  valid_579297 = validateParameter(valid_579297, JString, required = false,
                                 default = newJString("json"))
  if valid_579297 != nil:
    section.add "alt", valid_579297
  var valid_579298 = query.getOrDefault("uploadType")
  valid_579298 = validateParameter(valid_579298, JString, required = false,
                                 default = nil)
  if valid_579298 != nil:
    section.add "uploadType", valid_579298
  var valid_579299 = query.getOrDefault("quotaUser")
  valid_579299 = validateParameter(valid_579299, JString, required = false,
                                 default = nil)
  if valid_579299 != nil:
    section.add "quotaUser", valid_579299
  var valid_579300 = query.getOrDefault("callback")
  valid_579300 = validateParameter(valid_579300, JString, required = false,
                                 default = nil)
  if valid_579300 != nil:
    section.add "callback", valid_579300
  var valid_579301 = query.getOrDefault("fields")
  valid_579301 = validateParameter(valid_579301, JString, required = false,
                                 default = nil)
  if valid_579301 != nil:
    section.add "fields", valid_579301
  var valid_579302 = query.getOrDefault("access_token")
  valid_579302 = validateParameter(valid_579302, JString, required = false,
                                 default = nil)
  if valid_579302 != nil:
    section.add "access_token", valid_579302
  var valid_579303 = query.getOrDefault("upload_protocol")
  valid_579303 = validateParameter(valid_579303, JString, required = false,
                                 default = nil)
  if valid_579303 != nil:
    section.add "upload_protocol", valid_579303
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

proc call*(call_579305: Call_BigtableadminProjectsInstancesGetIamPolicy_579289;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
  ## 
  let valid = call_579305.validator(path, query, header, formData, body)
  let scheme = call_579305.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579305.url(scheme.get, call_579305.host, call_579305.base,
                         call_579305.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579305, url, valid)

proc call*(call_579306: Call_BigtableadminProjectsInstancesGetIamPolicy_579289;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesGetIamPolicy
  ## Gets the access control policy for an instance resource. Returns an empty
  ## policy if an instance exists but does not have a policy set.
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
  ##           : REQUIRED: The resource for which the policy is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579307 = newJObject()
  var query_579308 = newJObject()
  var body_579309 = newJObject()
  add(query_579308, "key", newJString(key))
  add(query_579308, "prettyPrint", newJBool(prettyPrint))
  add(query_579308, "oauth_token", newJString(oauthToken))
  add(query_579308, "$.xgafv", newJString(Xgafv))
  add(query_579308, "alt", newJString(alt))
  add(query_579308, "uploadType", newJString(uploadType))
  add(query_579308, "quotaUser", newJString(quotaUser))
  add(path_579307, "resource", newJString(resource))
  if body != nil:
    body_579309 = body
  add(query_579308, "callback", newJString(callback))
  add(query_579308, "fields", newJString(fields))
  add(query_579308, "access_token", newJString(accessToken))
  add(query_579308, "upload_protocol", newJString(uploadProtocol))
  result = call_579306.call(path_579307, query_579308, nil, nil, body_579309)

var bigtableadminProjectsInstancesGetIamPolicy* = Call_BigtableadminProjectsInstancesGetIamPolicy_579289(
    name: "bigtableadminProjectsInstancesGetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:getIamPolicy",
    validator: validate_BigtableadminProjectsInstancesGetIamPolicy_579290,
    base: "/", url: url_BigtableadminProjectsInstancesGetIamPolicy_579291,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesSetIamPolicy_579310 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesSetIamPolicy_579312(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":setIamPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesSetIamPolicy_579311(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579313 = path.getOrDefault("resource")
  valid_579313 = validateParameter(valid_579313, JString, required = true,
                                 default = nil)
  if valid_579313 != nil:
    section.add "resource", valid_579313
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
  var valid_579314 = query.getOrDefault("key")
  valid_579314 = validateParameter(valid_579314, JString, required = false,
                                 default = nil)
  if valid_579314 != nil:
    section.add "key", valid_579314
  var valid_579315 = query.getOrDefault("prettyPrint")
  valid_579315 = validateParameter(valid_579315, JBool, required = false,
                                 default = newJBool(true))
  if valid_579315 != nil:
    section.add "prettyPrint", valid_579315
  var valid_579316 = query.getOrDefault("oauth_token")
  valid_579316 = validateParameter(valid_579316, JString, required = false,
                                 default = nil)
  if valid_579316 != nil:
    section.add "oauth_token", valid_579316
  var valid_579317 = query.getOrDefault("$.xgafv")
  valid_579317 = validateParameter(valid_579317, JString, required = false,
                                 default = newJString("1"))
  if valid_579317 != nil:
    section.add "$.xgafv", valid_579317
  var valid_579318 = query.getOrDefault("alt")
  valid_579318 = validateParameter(valid_579318, JString, required = false,
                                 default = newJString("json"))
  if valid_579318 != nil:
    section.add "alt", valid_579318
  var valid_579319 = query.getOrDefault("uploadType")
  valid_579319 = validateParameter(valid_579319, JString, required = false,
                                 default = nil)
  if valid_579319 != nil:
    section.add "uploadType", valid_579319
  var valid_579320 = query.getOrDefault("quotaUser")
  valid_579320 = validateParameter(valid_579320, JString, required = false,
                                 default = nil)
  if valid_579320 != nil:
    section.add "quotaUser", valid_579320
  var valid_579321 = query.getOrDefault("callback")
  valid_579321 = validateParameter(valid_579321, JString, required = false,
                                 default = nil)
  if valid_579321 != nil:
    section.add "callback", valid_579321
  var valid_579322 = query.getOrDefault("fields")
  valid_579322 = validateParameter(valid_579322, JString, required = false,
                                 default = nil)
  if valid_579322 != nil:
    section.add "fields", valid_579322
  var valid_579323 = query.getOrDefault("access_token")
  valid_579323 = validateParameter(valid_579323, JString, required = false,
                                 default = nil)
  if valid_579323 != nil:
    section.add "access_token", valid_579323
  var valid_579324 = query.getOrDefault("upload_protocol")
  valid_579324 = validateParameter(valid_579324, JString, required = false,
                                 default = nil)
  if valid_579324 != nil:
    section.add "upload_protocol", valid_579324
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

proc call*(call_579326: Call_BigtableadminProjectsInstancesSetIamPolicy_579310;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
  ## 
  let valid = call_579326.validator(path, query, header, formData, body)
  let scheme = call_579326.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579326.url(scheme.get, call_579326.host, call_579326.base,
                         call_579326.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579326, url, valid)

proc call*(call_579327: Call_BigtableadminProjectsInstancesSetIamPolicy_579310;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesSetIamPolicy
  ## Sets the access control policy on an instance resource. Replaces any
  ## existing policy.
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
  ##           : REQUIRED: The resource for which the policy is being specified.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579328 = newJObject()
  var query_579329 = newJObject()
  var body_579330 = newJObject()
  add(query_579329, "key", newJString(key))
  add(query_579329, "prettyPrint", newJBool(prettyPrint))
  add(query_579329, "oauth_token", newJString(oauthToken))
  add(query_579329, "$.xgafv", newJString(Xgafv))
  add(query_579329, "alt", newJString(alt))
  add(query_579329, "uploadType", newJString(uploadType))
  add(query_579329, "quotaUser", newJString(quotaUser))
  add(path_579328, "resource", newJString(resource))
  if body != nil:
    body_579330 = body
  add(query_579329, "callback", newJString(callback))
  add(query_579329, "fields", newJString(fields))
  add(query_579329, "access_token", newJString(accessToken))
  add(query_579329, "upload_protocol", newJString(uploadProtocol))
  result = call_579327.call(path_579328, query_579329, nil, nil, body_579330)

var bigtableadminProjectsInstancesSetIamPolicy* = Call_BigtableadminProjectsInstancesSetIamPolicy_579310(
    name: "bigtableadminProjectsInstancesSetIamPolicy", meth: HttpMethod.HttpPost,
    host: "bigtableadmin.googleapis.com", route: "/v2/{resource}:setIamPolicy",
    validator: validate_BigtableadminProjectsInstancesSetIamPolicy_579311,
    base: "/", url: url_BigtableadminProjectsInstancesSetIamPolicy_579312,
    schemes: {Scheme.Https})
type
  Call_BigtableadminProjectsInstancesTestIamPermissions_579331 = ref object of OpenApiRestCall_578348
proc url_BigtableadminProjectsInstancesTestIamPermissions_579333(
    protocol: Scheme; host: string; base: string; route: string; path: JsonNode;
    query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "resource" in path, "`resource` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v2/"),
               (kind: VariableSegment, value: "resource"),
               (kind: ConstantSegment, value: ":testIamPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_BigtableadminProjectsInstancesTestIamPermissions_579332(
    path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
    body: JsonNode): JsonNode =
  ## Returns permissions that the caller has on the specified instance resource.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   resource: JString (required)
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `resource` field"
  var valid_579334 = path.getOrDefault("resource")
  valid_579334 = validateParameter(valid_579334, JString, required = true,
                                 default = nil)
  if valid_579334 != nil:
    section.add "resource", valid_579334
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
  var valid_579335 = query.getOrDefault("key")
  valid_579335 = validateParameter(valid_579335, JString, required = false,
                                 default = nil)
  if valid_579335 != nil:
    section.add "key", valid_579335
  var valid_579336 = query.getOrDefault("prettyPrint")
  valid_579336 = validateParameter(valid_579336, JBool, required = false,
                                 default = newJBool(true))
  if valid_579336 != nil:
    section.add "prettyPrint", valid_579336
  var valid_579337 = query.getOrDefault("oauth_token")
  valid_579337 = validateParameter(valid_579337, JString, required = false,
                                 default = nil)
  if valid_579337 != nil:
    section.add "oauth_token", valid_579337
  var valid_579338 = query.getOrDefault("$.xgafv")
  valid_579338 = validateParameter(valid_579338, JString, required = false,
                                 default = newJString("1"))
  if valid_579338 != nil:
    section.add "$.xgafv", valid_579338
  var valid_579339 = query.getOrDefault("alt")
  valid_579339 = validateParameter(valid_579339, JString, required = false,
                                 default = newJString("json"))
  if valid_579339 != nil:
    section.add "alt", valid_579339
  var valid_579340 = query.getOrDefault("uploadType")
  valid_579340 = validateParameter(valid_579340, JString, required = false,
                                 default = nil)
  if valid_579340 != nil:
    section.add "uploadType", valid_579340
  var valid_579341 = query.getOrDefault("quotaUser")
  valid_579341 = validateParameter(valid_579341, JString, required = false,
                                 default = nil)
  if valid_579341 != nil:
    section.add "quotaUser", valid_579341
  var valid_579342 = query.getOrDefault("callback")
  valid_579342 = validateParameter(valid_579342, JString, required = false,
                                 default = nil)
  if valid_579342 != nil:
    section.add "callback", valid_579342
  var valid_579343 = query.getOrDefault("fields")
  valid_579343 = validateParameter(valid_579343, JString, required = false,
                                 default = nil)
  if valid_579343 != nil:
    section.add "fields", valid_579343
  var valid_579344 = query.getOrDefault("access_token")
  valid_579344 = validateParameter(valid_579344, JString, required = false,
                                 default = nil)
  if valid_579344 != nil:
    section.add "access_token", valid_579344
  var valid_579345 = query.getOrDefault("upload_protocol")
  valid_579345 = validateParameter(valid_579345, JString, required = false,
                                 default = nil)
  if valid_579345 != nil:
    section.add "upload_protocol", valid_579345
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

proc call*(call_579347: Call_BigtableadminProjectsInstancesTestIamPermissions_579331;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns permissions that the caller has on the specified instance resource.
  ## 
  let valid = call_579347.validator(path, query, header, formData, body)
  let scheme = call_579347.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579347.url(scheme.get, call_579347.host, call_579347.base,
                         call_579347.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579347, url, valid)

proc call*(call_579348: Call_BigtableadminProjectsInstancesTestIamPermissions_579331;
          resource: string; key: string = ""; prettyPrint: bool = true;
          oauthToken: string = ""; Xgafv: string = "1"; alt: string = "json";
          uploadType: string = ""; quotaUser: string = ""; body: JsonNode = nil;
          callback: string = ""; fields: string = ""; accessToken: string = "";
          uploadProtocol: string = ""): Recallable =
  ## bigtableadminProjectsInstancesTestIamPermissions
  ## Returns permissions that the caller has on the specified instance resource.
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
  ##           : REQUIRED: The resource for which the policy detail is being requested.
  ## See the operation documentation for the appropriate value for this field.
  ##   body: JObject
  ##   callback: string
  ##           : JSONP
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   accessToken: string
  ##              : OAuth access token.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  var path_579349 = newJObject()
  var query_579350 = newJObject()
  var body_579351 = newJObject()
  add(query_579350, "key", newJString(key))
  add(query_579350, "prettyPrint", newJBool(prettyPrint))
  add(query_579350, "oauth_token", newJString(oauthToken))
  add(query_579350, "$.xgafv", newJString(Xgafv))
  add(query_579350, "alt", newJString(alt))
  add(query_579350, "uploadType", newJString(uploadType))
  add(query_579350, "quotaUser", newJString(quotaUser))
  add(path_579349, "resource", newJString(resource))
  if body != nil:
    body_579351 = body
  add(query_579350, "callback", newJString(callback))
  add(query_579350, "fields", newJString(fields))
  add(query_579350, "access_token", newJString(accessToken))
  add(query_579350, "upload_protocol", newJString(uploadProtocol))
  result = call_579348.call(path_579349, query_579350, nil, nil, body_579351)

var bigtableadminProjectsInstancesTestIamPermissions* = Call_BigtableadminProjectsInstancesTestIamPermissions_579331(
    name: "bigtableadminProjectsInstancesTestIamPermissions",
    meth: HttpMethod.HttpPost, host: "bigtableadmin.googleapis.com",
    route: "/v2/{resource}:testIamPermissions",
    validator: validate_BigtableadminProjectsInstancesTestIamPermissions_579332,
    base: "/", url: url_BigtableadminProjectsInstancesTestIamPermissions_579333,
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
