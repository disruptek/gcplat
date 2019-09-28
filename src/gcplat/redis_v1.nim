
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Google Cloud Memorystore for Redis
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Creates and manages Redis instances on the Google Cloud Platform.
## 
## https://cloud.google.com/memorystore/docs/redis/
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

  OpenApiRestCall_579408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579408): Option[Scheme] {.used.} =
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
  gcpServiceName = "redis"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RedisProjectsLocationsInstancesGet_579677 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesGet_579679(protocol: Scheme; host: string;
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

proc validate_RedisProjectsLocationsInstancesGet_579678(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Gets the details of a specific Redis instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579805 = path.getOrDefault("name")
  valid_579805 = validateParameter(valid_579805, JString, required = true,
                                 default = nil)
  if valid_579805 != nil:
    section.add "name", valid_579805
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
  var valid_579806 = query.getOrDefault("upload_protocol")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "upload_protocol", valid_579806
  var valid_579807 = query.getOrDefault("fields")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "fields", valid_579807
  var valid_579808 = query.getOrDefault("quotaUser")
  valid_579808 = validateParameter(valid_579808, JString, required = false,
                                 default = nil)
  if valid_579808 != nil:
    section.add "quotaUser", valid_579808
  var valid_579822 = query.getOrDefault("alt")
  valid_579822 = validateParameter(valid_579822, JString, required = false,
                                 default = newJString("json"))
  if valid_579822 != nil:
    section.add "alt", valid_579822
  var valid_579823 = query.getOrDefault("oauth_token")
  valid_579823 = validateParameter(valid_579823, JString, required = false,
                                 default = nil)
  if valid_579823 != nil:
    section.add "oauth_token", valid_579823
  var valid_579824 = query.getOrDefault("callback")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "callback", valid_579824
  var valid_579825 = query.getOrDefault("access_token")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "access_token", valid_579825
  var valid_579826 = query.getOrDefault("uploadType")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "uploadType", valid_579826
  var valid_579827 = query.getOrDefault("key")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = nil)
  if valid_579827 != nil:
    section.add "key", valid_579827
  var valid_579828 = query.getOrDefault("$.xgafv")
  valid_579828 = validateParameter(valid_579828, JString, required = false,
                                 default = newJString("1"))
  if valid_579828 != nil:
    section.add "$.xgafv", valid_579828
  var valid_579829 = query.getOrDefault("prettyPrint")
  valid_579829 = validateParameter(valid_579829, JBool, required = false,
                                 default = newJBool(true))
  if valid_579829 != nil:
    section.add "prettyPrint", valid_579829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579852: Call_RedisProjectsLocationsInstancesGet_579677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific Redis instance.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_RedisProjectsLocationsInstancesGet_579677;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsInstancesGet
  ## Gets the details of a specific Redis instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
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
  var path_579924 = newJObject()
  var query_579926 = newJObject()
  add(query_579926, "upload_protocol", newJString(uploadProtocol))
  add(query_579926, "fields", newJString(fields))
  add(query_579926, "quotaUser", newJString(quotaUser))
  add(path_579924, "name", newJString(name))
  add(query_579926, "alt", newJString(alt))
  add(query_579926, "oauth_token", newJString(oauthToken))
  add(query_579926, "callback", newJString(callback))
  add(query_579926, "access_token", newJString(accessToken))
  add(query_579926, "uploadType", newJString(uploadType))
  add(query_579926, "key", newJString(key))
  add(query_579926, "$.xgafv", newJString(Xgafv))
  add(query_579926, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(path_579924, query_579926, nil, nil, nil)

var redisProjectsLocationsInstancesGet* = Call_RedisProjectsLocationsInstancesGet_579677(
    name: "redisProjectsLocationsInstancesGet", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1/{name}",
    validator: validate_RedisProjectsLocationsInstancesGet_579678, base: "/",
    url: url_RedisProjectsLocationsInstancesGet_579679, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesPatch_579984 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesPatch_579986(protocol: Scheme;
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

proc validate_RedisProjectsLocationsInstancesPatch_579985(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the metadata and configuration of a specific Redis instance.
  ## 
  ## Completed longrunning.Operation will contain the new instance object
  ## in the response field. The returned operation is automatically deleted
  ## after a few hours, so there is no need to call DeleteOperation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Unique name of the resource in this scope including project and
  ## location using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## 
  ## Note: Redis instances are managed and addressed at regional level so
  ## location_id here refers to a GCP region; however, users may choose which
  ## specific zone (or collection of zones for cross-zone instances) an instance
  ## should be provisioned in. Refer to [location_id] and
  ## [alternative_location_id] fields for more details.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579987 = path.getOrDefault("name")
  valid_579987 = validateParameter(valid_579987, JString, required = true,
                                 default = nil)
  if valid_579987 != nil:
    section.add "name", valid_579987
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
  ##   updateMask: JString
  ##             : Required. Mask of fields to update. At least one path must be supplied in
  ## this field. The elements of the repeated paths field may only include these
  ## fields from Instance:
  ## 
  ##  *   `displayName`
  ##  *   `labels`
  ##  *   `memorySizeGb`
  ##  *   `redisConfig`
  section = newJObject()
  var valid_579988 = query.getOrDefault("upload_protocol")
  valid_579988 = validateParameter(valid_579988, JString, required = false,
                                 default = nil)
  if valid_579988 != nil:
    section.add "upload_protocol", valid_579988
  var valid_579989 = query.getOrDefault("fields")
  valid_579989 = validateParameter(valid_579989, JString, required = false,
                                 default = nil)
  if valid_579989 != nil:
    section.add "fields", valid_579989
  var valid_579990 = query.getOrDefault("quotaUser")
  valid_579990 = validateParameter(valid_579990, JString, required = false,
                                 default = nil)
  if valid_579990 != nil:
    section.add "quotaUser", valid_579990
  var valid_579991 = query.getOrDefault("alt")
  valid_579991 = validateParameter(valid_579991, JString, required = false,
                                 default = newJString("json"))
  if valid_579991 != nil:
    section.add "alt", valid_579991
  var valid_579992 = query.getOrDefault("oauth_token")
  valid_579992 = validateParameter(valid_579992, JString, required = false,
                                 default = nil)
  if valid_579992 != nil:
    section.add "oauth_token", valid_579992
  var valid_579993 = query.getOrDefault("callback")
  valid_579993 = validateParameter(valid_579993, JString, required = false,
                                 default = nil)
  if valid_579993 != nil:
    section.add "callback", valid_579993
  var valid_579994 = query.getOrDefault("access_token")
  valid_579994 = validateParameter(valid_579994, JString, required = false,
                                 default = nil)
  if valid_579994 != nil:
    section.add "access_token", valid_579994
  var valid_579995 = query.getOrDefault("uploadType")
  valid_579995 = validateParameter(valid_579995, JString, required = false,
                                 default = nil)
  if valid_579995 != nil:
    section.add "uploadType", valid_579995
  var valid_579996 = query.getOrDefault("key")
  valid_579996 = validateParameter(valid_579996, JString, required = false,
                                 default = nil)
  if valid_579996 != nil:
    section.add "key", valid_579996
  var valid_579997 = query.getOrDefault("$.xgafv")
  valid_579997 = validateParameter(valid_579997, JString, required = false,
                                 default = newJString("1"))
  if valid_579997 != nil:
    section.add "$.xgafv", valid_579997
  var valid_579998 = query.getOrDefault("prettyPrint")
  valid_579998 = validateParameter(valid_579998, JBool, required = false,
                                 default = newJBool(true))
  if valid_579998 != nil:
    section.add "prettyPrint", valid_579998
  var valid_579999 = query.getOrDefault("updateMask")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "updateMask", valid_579999
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

proc call*(call_580001: Call_RedisProjectsLocationsInstancesPatch_579984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the metadata and configuration of a specific Redis instance.
  ## 
  ## Completed longrunning.Operation will contain the new instance object
  ## in the response field. The returned operation is automatically deleted
  ## after a few hours, so there is no need to call DeleteOperation.
  ## 
  let valid = call_580001.validator(path, query, header, formData, body)
  let scheme = call_580001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580001.url(scheme.get, call_580001.host, call_580001.base,
                         call_580001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580001, url, valid)

proc call*(call_580002: Call_RedisProjectsLocationsInstancesPatch_579984;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true; updateMask: string = ""): Recallable =
  ## redisProjectsLocationsInstancesPatch
  ## Updates the metadata and configuration of a specific Redis instance.
  ## 
  ## Completed longrunning.Operation will contain the new instance object
  ## in the response field. The returned operation is automatically deleted
  ## after a few hours, so there is no need to call DeleteOperation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Unique name of the resource in this scope including project and
  ## location using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## 
  ## Note: Redis instances are managed and addressed at regional level so
  ## location_id here refers to a GCP region; however, users may choose which
  ## specific zone (or collection of zones for cross-zone instances) an instance
  ## should be provisioned in. Refer to [location_id] and
  ## [alternative_location_id] fields for more details.
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
  ##   updateMask: string
  ##             : Required. Mask of fields to update. At least one path must be supplied in
  ## this field. The elements of the repeated paths field may only include these
  ## fields from Instance:
  ## 
  ##  *   `displayName`
  ##  *   `labels`
  ##  *   `memorySizeGb`
  ##  *   `redisConfig`
  var path_580003 = newJObject()
  var query_580004 = newJObject()
  var body_580005 = newJObject()
  add(query_580004, "upload_protocol", newJString(uploadProtocol))
  add(query_580004, "fields", newJString(fields))
  add(query_580004, "quotaUser", newJString(quotaUser))
  add(path_580003, "name", newJString(name))
  add(query_580004, "alt", newJString(alt))
  add(query_580004, "oauth_token", newJString(oauthToken))
  add(query_580004, "callback", newJString(callback))
  add(query_580004, "access_token", newJString(accessToken))
  add(query_580004, "uploadType", newJString(uploadType))
  add(query_580004, "key", newJString(key))
  add(query_580004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580005 = body
  add(query_580004, "prettyPrint", newJBool(prettyPrint))
  add(query_580004, "updateMask", newJString(updateMask))
  result = call_580002.call(path_580003, query_580004, nil, nil, body_580005)

var redisProjectsLocationsInstancesPatch* = Call_RedisProjectsLocationsInstancesPatch_579984(
    name: "redisProjectsLocationsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "redis.googleapis.com", route: "/v1/{name}",
    validator: validate_RedisProjectsLocationsInstancesPatch_579985, base: "/",
    url: url_RedisProjectsLocationsInstancesPatch_579986, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesDelete_579965 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesDelete_579967(protocol: Scheme;
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

proc validate_RedisProjectsLocationsInstancesDelete_579966(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes a specific Redis instance.  Instance stops serving and data is
  ## deleted.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_579968 = path.getOrDefault("name")
  valid_579968 = validateParameter(valid_579968, JString, required = true,
                                 default = nil)
  if valid_579968 != nil:
    section.add "name", valid_579968
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
  var valid_579969 = query.getOrDefault("upload_protocol")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = nil)
  if valid_579969 != nil:
    section.add "upload_protocol", valid_579969
  var valid_579970 = query.getOrDefault("fields")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "fields", valid_579970
  var valid_579971 = query.getOrDefault("quotaUser")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "quotaUser", valid_579971
  var valid_579972 = query.getOrDefault("alt")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = newJString("json"))
  if valid_579972 != nil:
    section.add "alt", valid_579972
  var valid_579973 = query.getOrDefault("oauth_token")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = nil)
  if valid_579973 != nil:
    section.add "oauth_token", valid_579973
  var valid_579974 = query.getOrDefault("callback")
  valid_579974 = validateParameter(valid_579974, JString, required = false,
                                 default = nil)
  if valid_579974 != nil:
    section.add "callback", valid_579974
  var valid_579975 = query.getOrDefault("access_token")
  valid_579975 = validateParameter(valid_579975, JString, required = false,
                                 default = nil)
  if valid_579975 != nil:
    section.add "access_token", valid_579975
  var valid_579976 = query.getOrDefault("uploadType")
  valid_579976 = validateParameter(valid_579976, JString, required = false,
                                 default = nil)
  if valid_579976 != nil:
    section.add "uploadType", valid_579976
  var valid_579977 = query.getOrDefault("key")
  valid_579977 = validateParameter(valid_579977, JString, required = false,
                                 default = nil)
  if valid_579977 != nil:
    section.add "key", valid_579977
  var valid_579978 = query.getOrDefault("$.xgafv")
  valid_579978 = validateParameter(valid_579978, JString, required = false,
                                 default = newJString("1"))
  if valid_579978 != nil:
    section.add "$.xgafv", valid_579978
  var valid_579979 = query.getOrDefault("prettyPrint")
  valid_579979 = validateParameter(valid_579979, JBool, required = false,
                                 default = newJBool(true))
  if valid_579979 != nil:
    section.add "prettyPrint", valid_579979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_579980: Call_RedisProjectsLocationsInstancesDelete_579965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a specific Redis instance.  Instance stops serving and data is
  ## deleted.
  ## 
  let valid = call_579980.validator(path, query, header, formData, body)
  let scheme = call_579980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579980.url(scheme.get, call_579980.host, call_579980.base,
                         call_579980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579980, url, valid)

proc call*(call_579981: Call_RedisProjectsLocationsInstancesDelete_579965;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsInstancesDelete
  ## Deletes a specific Redis instance.  Instance stops serving and data is
  ## deleted.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
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
  var path_579982 = newJObject()
  var query_579983 = newJObject()
  add(query_579983, "upload_protocol", newJString(uploadProtocol))
  add(query_579983, "fields", newJString(fields))
  add(query_579983, "quotaUser", newJString(quotaUser))
  add(path_579982, "name", newJString(name))
  add(query_579983, "alt", newJString(alt))
  add(query_579983, "oauth_token", newJString(oauthToken))
  add(query_579983, "callback", newJString(callback))
  add(query_579983, "access_token", newJString(accessToken))
  add(query_579983, "uploadType", newJString(uploadType))
  add(query_579983, "key", newJString(key))
  add(query_579983, "$.xgafv", newJString(Xgafv))
  add(query_579983, "prettyPrint", newJBool(prettyPrint))
  result = call_579981.call(path_579982, query_579983, nil, nil, nil)

var redisProjectsLocationsInstancesDelete* = Call_RedisProjectsLocationsInstancesDelete_579965(
    name: "redisProjectsLocationsInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "redis.googleapis.com", route: "/v1/{name}",
    validator: validate_RedisProjectsLocationsInstancesDelete_579966, base: "/",
    url: url_RedisProjectsLocationsInstancesDelete_579967, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsList_580006 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsList_580008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsList_580007(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists information about the supported locations for this service.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : The resource that owns the locations collection, if applicable.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580009 = path.getOrDefault("name")
  valid_580009 = validateParameter(valid_580009, JString, required = true,
                                 default = nil)
  if valid_580009 != nil:
    section.add "name", valid_580009
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_580010 = query.getOrDefault("upload_protocol")
  valid_580010 = validateParameter(valid_580010, JString, required = false,
                                 default = nil)
  if valid_580010 != nil:
    section.add "upload_protocol", valid_580010
  var valid_580011 = query.getOrDefault("fields")
  valid_580011 = validateParameter(valid_580011, JString, required = false,
                                 default = nil)
  if valid_580011 != nil:
    section.add "fields", valid_580011
  var valid_580012 = query.getOrDefault("pageToken")
  valid_580012 = validateParameter(valid_580012, JString, required = false,
                                 default = nil)
  if valid_580012 != nil:
    section.add "pageToken", valid_580012
  var valid_580013 = query.getOrDefault("quotaUser")
  valid_580013 = validateParameter(valid_580013, JString, required = false,
                                 default = nil)
  if valid_580013 != nil:
    section.add "quotaUser", valid_580013
  var valid_580014 = query.getOrDefault("alt")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = newJString("json"))
  if valid_580014 != nil:
    section.add "alt", valid_580014
  var valid_580015 = query.getOrDefault("oauth_token")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "oauth_token", valid_580015
  var valid_580016 = query.getOrDefault("callback")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = nil)
  if valid_580016 != nil:
    section.add "callback", valid_580016
  var valid_580017 = query.getOrDefault("access_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "access_token", valid_580017
  var valid_580018 = query.getOrDefault("uploadType")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "uploadType", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("$.xgafv")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("1"))
  if valid_580020 != nil:
    section.add "$.xgafv", valid_580020
  var valid_580021 = query.getOrDefault("pageSize")
  valid_580021 = validateParameter(valid_580021, JInt, required = false, default = nil)
  if valid_580021 != nil:
    section.add "pageSize", valid_580021
  var valid_580022 = query.getOrDefault("prettyPrint")
  valid_580022 = validateParameter(valid_580022, JBool, required = false,
                                 default = newJBool(true))
  if valid_580022 != nil:
    section.add "prettyPrint", valid_580022
  var valid_580023 = query.getOrDefault("filter")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = nil)
  if valid_580023 != nil:
    section.add "filter", valid_580023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580024: Call_RedisProjectsLocationsList_580006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_580024.validator(path, query, header, formData, body)
  let scheme = call_580024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580024.url(scheme.get, call_580024.host, call_580024.base,
                         call_580024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580024, url, valid)

proc call*(call_580025: Call_RedisProjectsLocationsList_580006; name: string;
          uploadProtocol: string = ""; fields: string = ""; pageToken: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## redisProjectsLocationsList
  ## Lists information about the supported locations for this service.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The resource that owns the locations collection, if applicable.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_580026 = newJObject()
  var query_580027 = newJObject()
  add(query_580027, "upload_protocol", newJString(uploadProtocol))
  add(query_580027, "fields", newJString(fields))
  add(query_580027, "pageToken", newJString(pageToken))
  add(query_580027, "quotaUser", newJString(quotaUser))
  add(path_580026, "name", newJString(name))
  add(query_580027, "alt", newJString(alt))
  add(query_580027, "oauth_token", newJString(oauthToken))
  add(query_580027, "callback", newJString(callback))
  add(query_580027, "access_token", newJString(accessToken))
  add(query_580027, "uploadType", newJString(uploadType))
  add(query_580027, "key", newJString(key))
  add(query_580027, "$.xgafv", newJString(Xgafv))
  add(query_580027, "pageSize", newJInt(pageSize))
  add(query_580027, "prettyPrint", newJBool(prettyPrint))
  add(query_580027, "filter", newJString(filter))
  result = call_580025.call(path_580026, query_580027, nil, nil, nil)

var redisProjectsLocationsList* = Call_RedisProjectsLocationsList_580006(
    name: "redisProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1/{name}/locations",
    validator: validate_RedisProjectsLocationsList_580007, base: "/",
    url: url_RedisProjectsLocationsList_580008, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsOperationsList_580028 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsOperationsList_580030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsOperationsList_580029(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
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
  var valid_580031 = path.getOrDefault("name")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "name", valid_580031
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The standard list page token.
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
  ##           : The standard list page size.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   filter: JString
  ##         : The standard list filter.
  section = newJObject()
  var valid_580032 = query.getOrDefault("upload_protocol")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "upload_protocol", valid_580032
  var valid_580033 = query.getOrDefault("fields")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "fields", valid_580033
  var valid_580034 = query.getOrDefault("pageToken")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = nil)
  if valid_580034 != nil:
    section.add "pageToken", valid_580034
  var valid_580035 = query.getOrDefault("quotaUser")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "quotaUser", valid_580035
  var valid_580036 = query.getOrDefault("alt")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = newJString("json"))
  if valid_580036 != nil:
    section.add "alt", valid_580036
  var valid_580037 = query.getOrDefault("oauth_token")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "oauth_token", valid_580037
  var valid_580038 = query.getOrDefault("callback")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "callback", valid_580038
  var valid_580039 = query.getOrDefault("access_token")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = nil)
  if valid_580039 != nil:
    section.add "access_token", valid_580039
  var valid_580040 = query.getOrDefault("uploadType")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "uploadType", valid_580040
  var valid_580041 = query.getOrDefault("key")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "key", valid_580041
  var valid_580042 = query.getOrDefault("$.xgafv")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = newJString("1"))
  if valid_580042 != nil:
    section.add "$.xgafv", valid_580042
  var valid_580043 = query.getOrDefault("pageSize")
  valid_580043 = validateParameter(valid_580043, JInt, required = false, default = nil)
  if valid_580043 != nil:
    section.add "pageSize", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
  var valid_580045 = query.getOrDefault("filter")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "filter", valid_580045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580046: Call_RedisProjectsLocationsOperationsList_580028;
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
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_RedisProjectsLocationsOperationsList_580028;
          name: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true; filter: string = ""): Recallable =
  ## redisProjectsLocationsOperationsList
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
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The standard list page token.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : The name of the operation's parent resource.
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
  ##   pageSize: int
  ##           : The standard list page size.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   filter: string
  ##         : The standard list filter.
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  add(query_580049, "upload_protocol", newJString(uploadProtocol))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "pageToken", newJString(pageToken))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(path_580048, "name", newJString(name))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "callback", newJString(callback))
  add(query_580049, "access_token", newJString(accessToken))
  add(query_580049, "uploadType", newJString(uploadType))
  add(query_580049, "key", newJString(key))
  add(query_580049, "$.xgafv", newJString(Xgafv))
  add(query_580049, "pageSize", newJInt(pageSize))
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  add(query_580049, "filter", newJString(filter))
  result = call_580047.call(path_580048, query_580049, nil, nil, nil)

var redisProjectsLocationsOperationsList* = Call_RedisProjectsLocationsOperationsList_580028(
    name: "redisProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1/{name}/operations",
    validator: validate_RedisProjectsLocationsOperationsList_580029, base: "/",
    url: url_RedisProjectsLocationsOperationsList_580030, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsOperationsCancel_580050 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsOperationsCancel_580052(protocol: Scheme;
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

proc validate_RedisProjectsLocationsOperationsCancel_580051(path: JsonNode;
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
  var valid_580053 = path.getOrDefault("name")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "name", valid_580053
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
  var valid_580054 = query.getOrDefault("upload_protocol")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "upload_protocol", valid_580054
  var valid_580055 = query.getOrDefault("fields")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "fields", valid_580055
  var valid_580056 = query.getOrDefault("quotaUser")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = nil)
  if valid_580056 != nil:
    section.add "quotaUser", valid_580056
  var valid_580057 = query.getOrDefault("alt")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = newJString("json"))
  if valid_580057 != nil:
    section.add "alt", valid_580057
  var valid_580058 = query.getOrDefault("oauth_token")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "oauth_token", valid_580058
  var valid_580059 = query.getOrDefault("callback")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "callback", valid_580059
  var valid_580060 = query.getOrDefault("access_token")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = nil)
  if valid_580060 != nil:
    section.add "access_token", valid_580060
  var valid_580061 = query.getOrDefault("uploadType")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "uploadType", valid_580061
  var valid_580062 = query.getOrDefault("key")
  valid_580062 = validateParameter(valid_580062, JString, required = false,
                                 default = nil)
  if valid_580062 != nil:
    section.add "key", valid_580062
  var valid_580063 = query.getOrDefault("$.xgafv")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = newJString("1"))
  if valid_580063 != nil:
    section.add "$.xgafv", valid_580063
  var valid_580064 = query.getOrDefault("prettyPrint")
  valid_580064 = validateParameter(valid_580064, JBool, required = false,
                                 default = newJBool(true))
  if valid_580064 != nil:
    section.add "prettyPrint", valid_580064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580065: Call_RedisProjectsLocationsOperationsCancel_580050;
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
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_RedisProjectsLocationsOperationsCancel_580050;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsOperationsCancel
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
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  add(query_580068, "upload_protocol", newJString(uploadProtocol))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(path_580067, "name", newJString(name))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "callback", newJString(callback))
  add(query_580068, "access_token", newJString(accessToken))
  add(query_580068, "uploadType", newJString(uploadType))
  add(query_580068, "key", newJString(key))
  add(query_580068, "$.xgafv", newJString(Xgafv))
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  result = call_580066.call(path_580067, query_580068, nil, nil, nil)

var redisProjectsLocationsOperationsCancel* = Call_RedisProjectsLocationsOperationsCancel_580050(
    name: "redisProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1/{name}:cancel",
    validator: validate_RedisProjectsLocationsOperationsCancel_580051, base: "/",
    url: url_RedisProjectsLocationsOperationsCancel_580052,
    schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesExport_580069 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesExport_580071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesExport_580070(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Export Redis instance data into a Redis RDB format file in Cloud Storage.
  ## 
  ## Redis will continue serving during this operation.
  ## 
  ## The returned operation is automatically deleted after a few hours, so
  ## there is no need to call DeleteOperation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580072 = path.getOrDefault("name")
  valid_580072 = validateParameter(valid_580072, JString, required = true,
                                 default = nil)
  if valid_580072 != nil:
    section.add "name", valid_580072
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
  var valid_580073 = query.getOrDefault("upload_protocol")
  valid_580073 = validateParameter(valid_580073, JString, required = false,
                                 default = nil)
  if valid_580073 != nil:
    section.add "upload_protocol", valid_580073
  var valid_580074 = query.getOrDefault("fields")
  valid_580074 = validateParameter(valid_580074, JString, required = false,
                                 default = nil)
  if valid_580074 != nil:
    section.add "fields", valid_580074
  var valid_580075 = query.getOrDefault("quotaUser")
  valid_580075 = validateParameter(valid_580075, JString, required = false,
                                 default = nil)
  if valid_580075 != nil:
    section.add "quotaUser", valid_580075
  var valid_580076 = query.getOrDefault("alt")
  valid_580076 = validateParameter(valid_580076, JString, required = false,
                                 default = newJString("json"))
  if valid_580076 != nil:
    section.add "alt", valid_580076
  var valid_580077 = query.getOrDefault("oauth_token")
  valid_580077 = validateParameter(valid_580077, JString, required = false,
                                 default = nil)
  if valid_580077 != nil:
    section.add "oauth_token", valid_580077
  var valid_580078 = query.getOrDefault("callback")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "callback", valid_580078
  var valid_580079 = query.getOrDefault("access_token")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "access_token", valid_580079
  var valid_580080 = query.getOrDefault("uploadType")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "uploadType", valid_580080
  var valid_580081 = query.getOrDefault("key")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "key", valid_580081
  var valid_580082 = query.getOrDefault("$.xgafv")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("1"))
  if valid_580082 != nil:
    section.add "$.xgafv", valid_580082
  var valid_580083 = query.getOrDefault("prettyPrint")
  valid_580083 = validateParameter(valid_580083, JBool, required = false,
                                 default = newJBool(true))
  if valid_580083 != nil:
    section.add "prettyPrint", valid_580083
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

proc call*(call_580085: Call_RedisProjectsLocationsInstancesExport_580069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export Redis instance data into a Redis RDB format file in Cloud Storage.
  ## 
  ## Redis will continue serving during this operation.
  ## 
  ## The returned operation is automatically deleted after a few hours, so
  ## there is no need to call DeleteOperation.
  ## 
  let valid = call_580085.validator(path, query, header, formData, body)
  let scheme = call_580085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580085.url(scheme.get, call_580085.host, call_580085.base,
                         call_580085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580085, url, valid)

proc call*(call_580086: Call_RedisProjectsLocationsInstancesExport_580069;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsInstancesExport
  ## Export Redis instance data into a Redis RDB format file in Cloud Storage.
  ## 
  ## Redis will continue serving during this operation.
  ## 
  ## The returned operation is automatically deleted after a few hours, so
  ## there is no need to call DeleteOperation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
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
  var path_580087 = newJObject()
  var query_580088 = newJObject()
  var body_580089 = newJObject()
  add(query_580088, "upload_protocol", newJString(uploadProtocol))
  add(query_580088, "fields", newJString(fields))
  add(query_580088, "quotaUser", newJString(quotaUser))
  add(path_580087, "name", newJString(name))
  add(query_580088, "alt", newJString(alt))
  add(query_580088, "oauth_token", newJString(oauthToken))
  add(query_580088, "callback", newJString(callback))
  add(query_580088, "access_token", newJString(accessToken))
  add(query_580088, "uploadType", newJString(uploadType))
  add(query_580088, "key", newJString(key))
  add(query_580088, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580089 = body
  add(query_580088, "prettyPrint", newJBool(prettyPrint))
  result = call_580086.call(path_580087, query_580088, nil, nil, body_580089)

var redisProjectsLocationsInstancesExport* = Call_RedisProjectsLocationsInstancesExport_580069(
    name: "redisProjectsLocationsInstancesExport", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1/{name}:export",
    validator: validate_RedisProjectsLocationsInstancesExport_580070, base: "/",
    url: url_RedisProjectsLocationsInstancesExport_580071, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesFailover_580090 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesFailover_580092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesFailover_580091(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Initiates a failover of the master node to current replica node for a
  ## specific STANDARD tier Cloud Memorystore for Redis instance.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580093 = path.getOrDefault("name")
  valid_580093 = validateParameter(valid_580093, JString, required = true,
                                 default = nil)
  if valid_580093 != nil:
    section.add "name", valid_580093
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
  var valid_580094 = query.getOrDefault("upload_protocol")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "upload_protocol", valid_580094
  var valid_580095 = query.getOrDefault("fields")
  valid_580095 = validateParameter(valid_580095, JString, required = false,
                                 default = nil)
  if valid_580095 != nil:
    section.add "fields", valid_580095
  var valid_580096 = query.getOrDefault("quotaUser")
  valid_580096 = validateParameter(valid_580096, JString, required = false,
                                 default = nil)
  if valid_580096 != nil:
    section.add "quotaUser", valid_580096
  var valid_580097 = query.getOrDefault("alt")
  valid_580097 = validateParameter(valid_580097, JString, required = false,
                                 default = newJString("json"))
  if valid_580097 != nil:
    section.add "alt", valid_580097
  var valid_580098 = query.getOrDefault("oauth_token")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "oauth_token", valid_580098
  var valid_580099 = query.getOrDefault("callback")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "callback", valid_580099
  var valid_580100 = query.getOrDefault("access_token")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = nil)
  if valid_580100 != nil:
    section.add "access_token", valid_580100
  var valid_580101 = query.getOrDefault("uploadType")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "uploadType", valid_580101
  var valid_580102 = query.getOrDefault("key")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "key", valid_580102
  var valid_580103 = query.getOrDefault("$.xgafv")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = newJString("1"))
  if valid_580103 != nil:
    section.add "$.xgafv", valid_580103
  var valid_580104 = query.getOrDefault("prettyPrint")
  valid_580104 = validateParameter(valid_580104, JBool, required = false,
                                 default = newJBool(true))
  if valid_580104 != nil:
    section.add "prettyPrint", valid_580104
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

proc call*(call_580106: Call_RedisProjectsLocationsInstancesFailover_580090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiates a failover of the master node to current replica node for a
  ## specific STANDARD tier Cloud Memorystore for Redis instance.
  ## 
  let valid = call_580106.validator(path, query, header, formData, body)
  let scheme = call_580106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580106.url(scheme.get, call_580106.host, call_580106.base,
                         call_580106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580106, url, valid)

proc call*(call_580107: Call_RedisProjectsLocationsInstancesFailover_580090;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsInstancesFailover
  ## Initiates a failover of the master node to current replica node for a
  ## specific STANDARD tier Cloud Memorystore for Redis instance.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
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
  var path_580108 = newJObject()
  var query_580109 = newJObject()
  var body_580110 = newJObject()
  add(query_580109, "upload_protocol", newJString(uploadProtocol))
  add(query_580109, "fields", newJString(fields))
  add(query_580109, "quotaUser", newJString(quotaUser))
  add(path_580108, "name", newJString(name))
  add(query_580109, "alt", newJString(alt))
  add(query_580109, "oauth_token", newJString(oauthToken))
  add(query_580109, "callback", newJString(callback))
  add(query_580109, "access_token", newJString(accessToken))
  add(query_580109, "uploadType", newJString(uploadType))
  add(query_580109, "key", newJString(key))
  add(query_580109, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580110 = body
  add(query_580109, "prettyPrint", newJBool(prettyPrint))
  result = call_580107.call(path_580108, query_580109, nil, nil, body_580110)

var redisProjectsLocationsInstancesFailover* = Call_RedisProjectsLocationsInstancesFailover_580090(
    name: "redisProjectsLocationsInstancesFailover", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1/{name}:failover",
    validator: validate_RedisProjectsLocationsInstancesFailover_580091, base: "/",
    url: url_RedisProjectsLocationsInstancesFailover_580092,
    schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesImport_580111 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesImport_580113(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesImport_580112(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Import a Redis RDB snapshot file from Cloud Storage into a Redis instance.
  ## 
  ## Redis may stop serving during this operation. Instance state will be
  ## IMPORTING for entire operation. When complete, the instance will contain
  ## only data from the imported file.
  ## 
  ## The returned operation is automatically deleted after a few hours, so
  ## there is no need to call DeleteOperation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   name: JString (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `name` field"
  var valid_580114 = path.getOrDefault("name")
  valid_580114 = validateParameter(valid_580114, JString, required = true,
                                 default = nil)
  if valid_580114 != nil:
    section.add "name", valid_580114
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
  var valid_580115 = query.getOrDefault("upload_protocol")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "upload_protocol", valid_580115
  var valid_580116 = query.getOrDefault("fields")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = nil)
  if valid_580116 != nil:
    section.add "fields", valid_580116
  var valid_580117 = query.getOrDefault("quotaUser")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "quotaUser", valid_580117
  var valid_580118 = query.getOrDefault("alt")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = newJString("json"))
  if valid_580118 != nil:
    section.add "alt", valid_580118
  var valid_580119 = query.getOrDefault("oauth_token")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "oauth_token", valid_580119
  var valid_580120 = query.getOrDefault("callback")
  valid_580120 = validateParameter(valid_580120, JString, required = false,
                                 default = nil)
  if valid_580120 != nil:
    section.add "callback", valid_580120
  var valid_580121 = query.getOrDefault("access_token")
  valid_580121 = validateParameter(valid_580121, JString, required = false,
                                 default = nil)
  if valid_580121 != nil:
    section.add "access_token", valid_580121
  var valid_580122 = query.getOrDefault("uploadType")
  valid_580122 = validateParameter(valid_580122, JString, required = false,
                                 default = nil)
  if valid_580122 != nil:
    section.add "uploadType", valid_580122
  var valid_580123 = query.getOrDefault("key")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "key", valid_580123
  var valid_580124 = query.getOrDefault("$.xgafv")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = newJString("1"))
  if valid_580124 != nil:
    section.add "$.xgafv", valid_580124
  var valid_580125 = query.getOrDefault("prettyPrint")
  valid_580125 = validateParameter(valid_580125, JBool, required = false,
                                 default = newJBool(true))
  if valid_580125 != nil:
    section.add "prettyPrint", valid_580125
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

proc call*(call_580127: Call_RedisProjectsLocationsInstancesImport_580111;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Import a Redis RDB snapshot file from Cloud Storage into a Redis instance.
  ## 
  ## Redis may stop serving during this operation. Instance state will be
  ## IMPORTING for entire operation. When complete, the instance will contain
  ## only data from the imported file.
  ## 
  ## The returned operation is automatically deleted after a few hours, so
  ## there is no need to call DeleteOperation.
  ## 
  let valid = call_580127.validator(path, query, header, formData, body)
  let scheme = call_580127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580127.url(scheme.get, call_580127.host, call_580127.base,
                         call_580127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580127, url, valid)

proc call*(call_580128: Call_RedisProjectsLocationsInstancesImport_580111;
          name: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsInstancesImport
  ## Import a Redis RDB snapshot file from Cloud Storage into a Redis instance.
  ## 
  ## Redis may stop serving during this operation. Instance state will be
  ## IMPORTING for entire operation. When complete, the instance will contain
  ## only data from the imported file.
  ## 
  ## The returned operation is automatically deleted after a few hours, so
  ## there is no need to call DeleteOperation.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : Available to use for quota purposes for server-side applications. Can be any arbitrary string assigned to a user, but should not exceed 40 characters.
  ##   name: string (required)
  ##       : Required. Redis instance resource name using the form:
  ##     `projects/{project_id}/locations/{location_id}/instances/{instance_id}`
  ## where `location_id` refers to a GCP region.
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
  var path_580129 = newJObject()
  var query_580130 = newJObject()
  var body_580131 = newJObject()
  add(query_580130, "upload_protocol", newJString(uploadProtocol))
  add(query_580130, "fields", newJString(fields))
  add(query_580130, "quotaUser", newJString(quotaUser))
  add(path_580129, "name", newJString(name))
  add(query_580130, "alt", newJString(alt))
  add(query_580130, "oauth_token", newJString(oauthToken))
  add(query_580130, "callback", newJString(callback))
  add(query_580130, "access_token", newJString(accessToken))
  add(query_580130, "uploadType", newJString(uploadType))
  add(query_580130, "key", newJString(key))
  add(query_580130, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_580131 = body
  add(query_580130, "prettyPrint", newJBool(prettyPrint))
  result = call_580128.call(path_580129, query_580130, nil, nil, body_580131)

var redisProjectsLocationsInstancesImport* = Call_RedisProjectsLocationsInstancesImport_580111(
    name: "redisProjectsLocationsInstancesImport", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1/{name}:import",
    validator: validate_RedisProjectsLocationsInstancesImport_580112, base: "/",
    url: url_RedisProjectsLocationsInstancesImport_580113, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesCreate_580153 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesCreate_580155(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
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

proc validate_RedisProjectsLocationsInstancesCreate_580154(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a Redis instance based on the specified tier and memory size.
  ## 
  ## By default, the instance is accessible from the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## The creation is executed asynchronously and callers may check the returned
  ## operation to track its progress. Once the operation is completed the Redis
  ## instance will be fully functional. Completed longrunning.Operation will
  ## contain the new instance object in the response field.
  ## 
  ## The returned operation is automatically deleted after a few hours, so there
  ## is no need to call DeleteOperation.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the instance location using the form:
  ##     `projects/{project_id}/locations/{location_id}`
  ## where `location_id` refers to a GCP region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580156 = path.getOrDefault("parent")
  valid_580156 = validateParameter(valid_580156, JString, required = true,
                                 default = nil)
  if valid_580156 != nil:
    section.add "parent", valid_580156
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
  ##   instanceId: JString
  ##             : Required. The logical name of the Redis instance in the customer project
  ## with the following restrictions:
  ## 
  ## * Must contain only lowercase letters, numbers, and hyphens.
  ## * Must start with a letter.
  ## * Must be between 1-40 characters.
  ## * Must end with a number or a letter.
  ## * Must be unique within the customer project / location
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580157 = query.getOrDefault("upload_protocol")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "upload_protocol", valid_580157
  var valid_580158 = query.getOrDefault("fields")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "fields", valid_580158
  var valid_580159 = query.getOrDefault("quotaUser")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = nil)
  if valid_580159 != nil:
    section.add "quotaUser", valid_580159
  var valid_580160 = query.getOrDefault("alt")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = newJString("json"))
  if valid_580160 != nil:
    section.add "alt", valid_580160
  var valid_580161 = query.getOrDefault("oauth_token")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "oauth_token", valid_580161
  var valid_580162 = query.getOrDefault("callback")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "callback", valid_580162
  var valid_580163 = query.getOrDefault("access_token")
  valid_580163 = validateParameter(valid_580163, JString, required = false,
                                 default = nil)
  if valid_580163 != nil:
    section.add "access_token", valid_580163
  var valid_580164 = query.getOrDefault("uploadType")
  valid_580164 = validateParameter(valid_580164, JString, required = false,
                                 default = nil)
  if valid_580164 != nil:
    section.add "uploadType", valid_580164
  var valid_580165 = query.getOrDefault("key")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "key", valid_580165
  var valid_580166 = query.getOrDefault("$.xgafv")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = newJString("1"))
  if valid_580166 != nil:
    section.add "$.xgafv", valid_580166
  var valid_580167 = query.getOrDefault("instanceId")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "instanceId", valid_580167
  var valid_580168 = query.getOrDefault("prettyPrint")
  valid_580168 = validateParameter(valid_580168, JBool, required = false,
                                 default = newJBool(true))
  if valid_580168 != nil:
    section.add "prettyPrint", valid_580168
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

proc call*(call_580170: Call_RedisProjectsLocationsInstancesCreate_580153;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a Redis instance based on the specified tier and memory size.
  ## 
  ## By default, the instance is accessible from the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## The creation is executed asynchronously and callers may check the returned
  ## operation to track its progress. Once the operation is completed the Redis
  ## instance will be fully functional. Completed longrunning.Operation will
  ## contain the new instance object in the response field.
  ## 
  ## The returned operation is automatically deleted after a few hours, so there
  ## is no need to call DeleteOperation.
  ## 
  let valid = call_580170.validator(path, query, header, formData, body)
  let scheme = call_580170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580170.url(scheme.get, call_580170.host, call_580170.base,
                         call_580170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580170, url, valid)

proc call*(call_580171: Call_RedisProjectsLocationsInstancesCreate_580153;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          callback: string = ""; accessToken: string = ""; uploadType: string = "";
          key: string = ""; Xgafv: string = "1"; instanceId: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsInstancesCreate
  ## Creates a Redis instance based on the specified tier and memory size.
  ## 
  ## By default, the instance is accessible from the project's
  ## [default network](/compute/docs/networks-and-firewalls#networks).
  ## 
  ## The creation is executed asynchronously and callers may check the returned
  ## operation to track its progress. Once the operation is completed the Redis
  ## instance will be fully functional. Completed longrunning.Operation will
  ## contain the new instance object in the response field.
  ## 
  ## The returned operation is automatically deleted after a few hours, so there
  ## is no need to call DeleteOperation.
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
  ##         : Required. The resource name of the instance location using the form:
  ##     `projects/{project_id}/locations/{location_id}`
  ## where `location_id` refers to a GCP region.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   instanceId: string
  ##             : Required. The logical name of the Redis instance in the customer project
  ## with the following restrictions:
  ## 
  ## * Must contain only lowercase letters, numbers, and hyphens.
  ## * Must start with a letter.
  ## * Must be between 1-40 characters.
  ## * Must end with a number or a letter.
  ## * Must be unique within the customer project / location
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580172 = newJObject()
  var query_580173 = newJObject()
  var body_580174 = newJObject()
  add(query_580173, "upload_protocol", newJString(uploadProtocol))
  add(query_580173, "fields", newJString(fields))
  add(query_580173, "quotaUser", newJString(quotaUser))
  add(query_580173, "alt", newJString(alt))
  add(query_580173, "oauth_token", newJString(oauthToken))
  add(query_580173, "callback", newJString(callback))
  add(query_580173, "access_token", newJString(accessToken))
  add(query_580173, "uploadType", newJString(uploadType))
  add(path_580172, "parent", newJString(parent))
  add(query_580173, "key", newJString(key))
  add(query_580173, "$.xgafv", newJString(Xgafv))
  add(query_580173, "instanceId", newJString(instanceId))
  if body != nil:
    body_580174 = body
  add(query_580173, "prettyPrint", newJBool(prettyPrint))
  result = call_580171.call(path_580172, query_580173, nil, nil, body_580174)

var redisProjectsLocationsInstancesCreate* = Call_RedisProjectsLocationsInstancesCreate_580153(
    name: "redisProjectsLocationsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_RedisProjectsLocationsInstancesCreate_580154, base: "/",
    url: url_RedisProjectsLocationsInstancesCreate_580155, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesList_580132 = ref object of OpenApiRestCall_579408
proc url_RedisProjectsLocationsInstancesList_580134(protocol: Scheme; host: string;
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

proc validate_RedisProjectsLocationsInstancesList_580133(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Lists all Redis instances owned by a project in either the specified
  ## location (region) or all locations.
  ## 
  ## The location should have the following format:
  ## * `projects/{project_id}/locations/{location_id}`
  ## 
  ## If `location_id` is specified as `-` (wildcard), then all regions
  ## available to the project are queried, and the results are aggregated.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   parent: JString (required)
  ##         : Required. The resource name of the instance location using the form:
  ##     `projects/{project_id}/locations/{location_id}`
  ## where `location_id` refers to a GCP region.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `parent` field"
  var valid_580135 = path.getOrDefault("parent")
  valid_580135 = validateParameter(valid_580135, JString, required = true,
                                 default = nil)
  if valid_580135 != nil:
    section.add "parent", valid_580135
  result.add "path", section
  ## parameters in `query` object:
  ##   upload_protocol: JString
  ##                  : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : The next_page_token value returned from a previous List request,
  ## if any.
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
  ##           : The maximum number of items to return.
  ## 
  ## If not specified, a default value of 1000 will be used by the service.
  ## Regardless of the page_size value, the response may include a partial list
  ## and a caller should only rely on response's
  ## next_page_token
  ## to determine if there are more instances left to be queried.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580136 = query.getOrDefault("upload_protocol")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "upload_protocol", valid_580136
  var valid_580137 = query.getOrDefault("fields")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "fields", valid_580137
  var valid_580138 = query.getOrDefault("pageToken")
  valid_580138 = validateParameter(valid_580138, JString, required = false,
                                 default = nil)
  if valid_580138 != nil:
    section.add "pageToken", valid_580138
  var valid_580139 = query.getOrDefault("quotaUser")
  valid_580139 = validateParameter(valid_580139, JString, required = false,
                                 default = nil)
  if valid_580139 != nil:
    section.add "quotaUser", valid_580139
  var valid_580140 = query.getOrDefault("alt")
  valid_580140 = validateParameter(valid_580140, JString, required = false,
                                 default = newJString("json"))
  if valid_580140 != nil:
    section.add "alt", valid_580140
  var valid_580141 = query.getOrDefault("oauth_token")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "oauth_token", valid_580141
  var valid_580142 = query.getOrDefault("callback")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "callback", valid_580142
  var valid_580143 = query.getOrDefault("access_token")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = nil)
  if valid_580143 != nil:
    section.add "access_token", valid_580143
  var valid_580144 = query.getOrDefault("uploadType")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "uploadType", valid_580144
  var valid_580145 = query.getOrDefault("key")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "key", valid_580145
  var valid_580146 = query.getOrDefault("$.xgafv")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = newJString("1"))
  if valid_580146 != nil:
    section.add "$.xgafv", valid_580146
  var valid_580147 = query.getOrDefault("pageSize")
  valid_580147 = validateParameter(valid_580147, JInt, required = false, default = nil)
  if valid_580147 != nil:
    section.add "pageSize", valid_580147
  var valid_580148 = query.getOrDefault("prettyPrint")
  valid_580148 = validateParameter(valid_580148, JBool, required = false,
                                 default = newJBool(true))
  if valid_580148 != nil:
    section.add "prettyPrint", valid_580148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580149: Call_RedisProjectsLocationsInstancesList_580132;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Lists all Redis instances owned by a project in either the specified
  ## location (region) or all locations.
  ## 
  ## The location should have the following format:
  ## * `projects/{project_id}/locations/{location_id}`
  ## 
  ## If `location_id` is specified as `-` (wildcard), then all regions
  ## available to the project are queried, and the results are aggregated.
  ## 
  let valid = call_580149.validator(path, query, header, formData, body)
  let scheme = call_580149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580149.url(scheme.get, call_580149.host, call_580149.base,
                         call_580149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580149, url, valid)

proc call*(call_580150: Call_RedisProjectsLocationsInstancesList_580132;
          parent: string; uploadProtocol: string = ""; fields: string = "";
          pageToken: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; callback: string = ""; accessToken: string = "";
          uploadType: string = ""; key: string = ""; Xgafv: string = "1"; pageSize: int = 0;
          prettyPrint: bool = true): Recallable =
  ## redisProjectsLocationsInstancesList
  ## Lists all Redis instances owned by a project in either the specified
  ## location (region) or all locations.
  ## 
  ## The location should have the following format:
  ## * `projects/{project_id}/locations/{location_id}`
  ## 
  ## If `location_id` is specified as `-` (wildcard), then all regions
  ## available to the project are queried, and the results are aggregated.
  ##   uploadProtocol: string
  ##                 : Upload protocol for media (e.g. "raw", "multipart").
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : The next_page_token value returned from a previous List request,
  ## if any.
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
  ##         : Required. The resource name of the instance location using the form:
  ##     `projects/{project_id}/locations/{location_id}`
  ## where `location_id` refers to a GCP region.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   Xgafv: string
  ##        : V1 error format.
  ##   pageSize: int
  ##           : The maximum number of items to return.
  ## 
  ## If not specified, a default value of 1000 will be used by the service.
  ## Regardless of the page_size value, the response may include a partial list
  ## and a caller should only rely on response's
  ## next_page_token
  ## to determine if there are more instances left to be queried.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580151 = newJObject()
  var query_580152 = newJObject()
  add(query_580152, "upload_protocol", newJString(uploadProtocol))
  add(query_580152, "fields", newJString(fields))
  add(query_580152, "pageToken", newJString(pageToken))
  add(query_580152, "quotaUser", newJString(quotaUser))
  add(query_580152, "alt", newJString(alt))
  add(query_580152, "oauth_token", newJString(oauthToken))
  add(query_580152, "callback", newJString(callback))
  add(query_580152, "access_token", newJString(accessToken))
  add(query_580152, "uploadType", newJString(uploadType))
  add(path_580151, "parent", newJString(parent))
  add(query_580152, "key", newJString(key))
  add(query_580152, "$.xgafv", newJString(Xgafv))
  add(query_580152, "pageSize", newJInt(pageSize))
  add(query_580152, "prettyPrint", newJBool(prettyPrint))
  result = call_580150.call(path_580151, query_580152, nil, nil, nil)

var redisProjectsLocationsInstancesList* = Call_RedisProjectsLocationsInstancesList_580132(
    name: "redisProjectsLocationsInstancesList", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1/{parent}/instances",
    validator: validate_RedisProjectsLocationsInstancesList_580133, base: "/",
    url: url_RedisProjectsLocationsInstancesList_580134, schemes: {Scheme.Https})
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

proc authenticate*(fresh: float64 = -3600.0; lifetime: int = 3600): Future[bool] {.async.} =
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
