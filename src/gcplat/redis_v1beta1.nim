
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Google Cloud Memorystore for Redis
## version: v1beta1
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

  OpenApiRestCall_593408 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593408](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593408): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_RedisProjectsLocationsInstancesGet_593677 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesGet_593679(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesGet_593678(path: JsonNode;
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
  var valid_593805 = path.getOrDefault("name")
  valid_593805 = validateParameter(valid_593805, JString, required = true,
                                 default = nil)
  if valid_593805 != nil:
    section.add "name", valid_593805
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
  var valid_593806 = query.getOrDefault("upload_protocol")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "upload_protocol", valid_593806
  var valid_593807 = query.getOrDefault("fields")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "fields", valid_593807
  var valid_593808 = query.getOrDefault("quotaUser")
  valid_593808 = validateParameter(valid_593808, JString, required = false,
                                 default = nil)
  if valid_593808 != nil:
    section.add "quotaUser", valid_593808
  var valid_593822 = query.getOrDefault("alt")
  valid_593822 = validateParameter(valid_593822, JString, required = false,
                                 default = newJString("json"))
  if valid_593822 != nil:
    section.add "alt", valid_593822
  var valid_593823 = query.getOrDefault("oauth_token")
  valid_593823 = validateParameter(valid_593823, JString, required = false,
                                 default = nil)
  if valid_593823 != nil:
    section.add "oauth_token", valid_593823
  var valid_593824 = query.getOrDefault("callback")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "callback", valid_593824
  var valid_593825 = query.getOrDefault("access_token")
  valid_593825 = validateParameter(valid_593825, JString, required = false,
                                 default = nil)
  if valid_593825 != nil:
    section.add "access_token", valid_593825
  var valid_593826 = query.getOrDefault("uploadType")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "uploadType", valid_593826
  var valid_593827 = query.getOrDefault("key")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "key", valid_593827
  var valid_593828 = query.getOrDefault("$.xgafv")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = newJString("1"))
  if valid_593828 != nil:
    section.add "$.xgafv", valid_593828
  var valid_593829 = query.getOrDefault("prettyPrint")
  valid_593829 = validateParameter(valid_593829, JBool, required = false,
                                 default = newJBool(true))
  if valid_593829 != nil:
    section.add "prettyPrint", valid_593829
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593852: Call_RedisProjectsLocationsInstancesGet_593677;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Gets the details of a specific Redis instance.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_RedisProjectsLocationsInstancesGet_593677;
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
  var path_593924 = newJObject()
  var query_593926 = newJObject()
  add(query_593926, "upload_protocol", newJString(uploadProtocol))
  add(query_593926, "fields", newJString(fields))
  add(query_593926, "quotaUser", newJString(quotaUser))
  add(path_593924, "name", newJString(name))
  add(query_593926, "alt", newJString(alt))
  add(query_593926, "oauth_token", newJString(oauthToken))
  add(query_593926, "callback", newJString(callback))
  add(query_593926, "access_token", newJString(accessToken))
  add(query_593926, "uploadType", newJString(uploadType))
  add(query_593926, "key", newJString(key))
  add(query_593926, "$.xgafv", newJString(Xgafv))
  add(query_593926, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(path_593924, query_593926, nil, nil, nil)

var redisProjectsLocationsInstancesGet* = Call_RedisProjectsLocationsInstancesGet_593677(
    name: "redisProjectsLocationsInstancesGet", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RedisProjectsLocationsInstancesGet_593678, base: "/",
    url: url_RedisProjectsLocationsInstancesGet_593679, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesPatch_593984 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesPatch_593986(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesPatch_593985(path: JsonNode;
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
  var valid_593987 = path.getOrDefault("name")
  valid_593987 = validateParameter(valid_593987, JString, required = true,
                                 default = nil)
  if valid_593987 != nil:
    section.add "name", valid_593987
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
  var valid_593988 = query.getOrDefault("upload_protocol")
  valid_593988 = validateParameter(valid_593988, JString, required = false,
                                 default = nil)
  if valid_593988 != nil:
    section.add "upload_protocol", valid_593988
  var valid_593989 = query.getOrDefault("fields")
  valid_593989 = validateParameter(valid_593989, JString, required = false,
                                 default = nil)
  if valid_593989 != nil:
    section.add "fields", valid_593989
  var valid_593990 = query.getOrDefault("quotaUser")
  valid_593990 = validateParameter(valid_593990, JString, required = false,
                                 default = nil)
  if valid_593990 != nil:
    section.add "quotaUser", valid_593990
  var valid_593991 = query.getOrDefault("alt")
  valid_593991 = validateParameter(valid_593991, JString, required = false,
                                 default = newJString("json"))
  if valid_593991 != nil:
    section.add "alt", valid_593991
  var valid_593992 = query.getOrDefault("oauth_token")
  valid_593992 = validateParameter(valid_593992, JString, required = false,
                                 default = nil)
  if valid_593992 != nil:
    section.add "oauth_token", valid_593992
  var valid_593993 = query.getOrDefault("callback")
  valid_593993 = validateParameter(valid_593993, JString, required = false,
                                 default = nil)
  if valid_593993 != nil:
    section.add "callback", valid_593993
  var valid_593994 = query.getOrDefault("access_token")
  valid_593994 = validateParameter(valid_593994, JString, required = false,
                                 default = nil)
  if valid_593994 != nil:
    section.add "access_token", valid_593994
  var valid_593995 = query.getOrDefault("uploadType")
  valid_593995 = validateParameter(valid_593995, JString, required = false,
                                 default = nil)
  if valid_593995 != nil:
    section.add "uploadType", valid_593995
  var valid_593996 = query.getOrDefault("key")
  valid_593996 = validateParameter(valid_593996, JString, required = false,
                                 default = nil)
  if valid_593996 != nil:
    section.add "key", valid_593996
  var valid_593997 = query.getOrDefault("$.xgafv")
  valid_593997 = validateParameter(valid_593997, JString, required = false,
                                 default = newJString("1"))
  if valid_593997 != nil:
    section.add "$.xgafv", valid_593997
  var valid_593998 = query.getOrDefault("prettyPrint")
  valid_593998 = validateParameter(valid_593998, JBool, required = false,
                                 default = newJBool(true))
  if valid_593998 != nil:
    section.add "prettyPrint", valid_593998
  var valid_593999 = query.getOrDefault("updateMask")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "updateMask", valid_593999
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

proc call*(call_594001: Call_RedisProjectsLocationsInstancesPatch_593984;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates the metadata and configuration of a specific Redis instance.
  ## 
  ## Completed longrunning.Operation will contain the new instance object
  ## in the response field. The returned operation is automatically deleted
  ## after a few hours, so there is no need to call DeleteOperation.
  ## 
  let valid = call_594001.validator(path, query, header, formData, body)
  let scheme = call_594001.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594001.url(scheme.get, call_594001.host, call_594001.base,
                         call_594001.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594001, url, valid)

proc call*(call_594002: Call_RedisProjectsLocationsInstancesPatch_593984;
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
  var path_594003 = newJObject()
  var query_594004 = newJObject()
  var body_594005 = newJObject()
  add(query_594004, "upload_protocol", newJString(uploadProtocol))
  add(query_594004, "fields", newJString(fields))
  add(query_594004, "quotaUser", newJString(quotaUser))
  add(path_594003, "name", newJString(name))
  add(query_594004, "alt", newJString(alt))
  add(query_594004, "oauth_token", newJString(oauthToken))
  add(query_594004, "callback", newJString(callback))
  add(query_594004, "access_token", newJString(accessToken))
  add(query_594004, "uploadType", newJString(uploadType))
  add(query_594004, "key", newJString(key))
  add(query_594004, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594005 = body
  add(query_594004, "prettyPrint", newJBool(prettyPrint))
  add(query_594004, "updateMask", newJString(updateMask))
  result = call_594002.call(path_594003, query_594004, nil, nil, body_594005)

var redisProjectsLocationsInstancesPatch* = Call_RedisProjectsLocationsInstancesPatch_593984(
    name: "redisProjectsLocationsInstancesPatch", meth: HttpMethod.HttpPatch,
    host: "redis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RedisProjectsLocationsInstancesPatch_593985, base: "/",
    url: url_RedisProjectsLocationsInstancesPatch_593986, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesDelete_593965 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesDelete_593967(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesDelete_593966(path: JsonNode;
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
  var valid_593968 = path.getOrDefault("name")
  valid_593968 = validateParameter(valid_593968, JString, required = true,
                                 default = nil)
  if valid_593968 != nil:
    section.add "name", valid_593968
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
  var valid_593969 = query.getOrDefault("upload_protocol")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = nil)
  if valid_593969 != nil:
    section.add "upload_protocol", valid_593969
  var valid_593970 = query.getOrDefault("fields")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "fields", valid_593970
  var valid_593971 = query.getOrDefault("quotaUser")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "quotaUser", valid_593971
  var valid_593972 = query.getOrDefault("alt")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = newJString("json"))
  if valid_593972 != nil:
    section.add "alt", valid_593972
  var valid_593973 = query.getOrDefault("oauth_token")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = nil)
  if valid_593973 != nil:
    section.add "oauth_token", valid_593973
  var valid_593974 = query.getOrDefault("callback")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "callback", valid_593974
  var valid_593975 = query.getOrDefault("access_token")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "access_token", valid_593975
  var valid_593976 = query.getOrDefault("uploadType")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = nil)
  if valid_593976 != nil:
    section.add "uploadType", valid_593976
  var valid_593977 = query.getOrDefault("key")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "key", valid_593977
  var valid_593978 = query.getOrDefault("$.xgafv")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = newJString("1"))
  if valid_593978 != nil:
    section.add "$.xgafv", valid_593978
  var valid_593979 = query.getOrDefault("prettyPrint")
  valid_593979 = validateParameter(valid_593979, JBool, required = false,
                                 default = newJBool(true))
  if valid_593979 != nil:
    section.add "prettyPrint", valid_593979
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593980: Call_RedisProjectsLocationsInstancesDelete_593965;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes a specific Redis instance.  Instance stops serving and data is
  ## deleted.
  ## 
  let valid = call_593980.validator(path, query, header, formData, body)
  let scheme = call_593980.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593980.url(scheme.get, call_593980.host, call_593980.base,
                         call_593980.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593980, url, valid)

proc call*(call_593981: Call_RedisProjectsLocationsInstancesDelete_593965;
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
  var path_593982 = newJObject()
  var query_593983 = newJObject()
  add(query_593983, "upload_protocol", newJString(uploadProtocol))
  add(query_593983, "fields", newJString(fields))
  add(query_593983, "quotaUser", newJString(quotaUser))
  add(path_593982, "name", newJString(name))
  add(query_593983, "alt", newJString(alt))
  add(query_593983, "oauth_token", newJString(oauthToken))
  add(query_593983, "callback", newJString(callback))
  add(query_593983, "access_token", newJString(accessToken))
  add(query_593983, "uploadType", newJString(uploadType))
  add(query_593983, "key", newJString(key))
  add(query_593983, "$.xgafv", newJString(Xgafv))
  add(query_593983, "prettyPrint", newJBool(prettyPrint))
  result = call_593981.call(path_593982, query_593983, nil, nil, nil)

var redisProjectsLocationsInstancesDelete* = Call_RedisProjectsLocationsInstancesDelete_593965(
    name: "redisProjectsLocationsInstancesDelete", meth: HttpMethod.HttpDelete,
    host: "redis.googleapis.com", route: "/v1beta1/{name}",
    validator: validate_RedisProjectsLocationsInstancesDelete_593966, base: "/",
    url: url_RedisProjectsLocationsInstancesDelete_593967, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsList_594006 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsList_594008(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/locations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsList_594007(path: JsonNode; query: JsonNode;
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
  var valid_594009 = path.getOrDefault("name")
  valid_594009 = validateParameter(valid_594009, JString, required = true,
                                 default = nil)
  if valid_594009 != nil:
    section.add "name", valid_594009
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
  var valid_594010 = query.getOrDefault("upload_protocol")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "upload_protocol", valid_594010
  var valid_594011 = query.getOrDefault("fields")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "fields", valid_594011
  var valid_594012 = query.getOrDefault("pageToken")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "pageToken", valid_594012
  var valid_594013 = query.getOrDefault("quotaUser")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "quotaUser", valid_594013
  var valid_594014 = query.getOrDefault("alt")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("json"))
  if valid_594014 != nil:
    section.add "alt", valid_594014
  var valid_594015 = query.getOrDefault("oauth_token")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "oauth_token", valid_594015
  var valid_594016 = query.getOrDefault("callback")
  valid_594016 = validateParameter(valid_594016, JString, required = false,
                                 default = nil)
  if valid_594016 != nil:
    section.add "callback", valid_594016
  var valid_594017 = query.getOrDefault("access_token")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "access_token", valid_594017
  var valid_594018 = query.getOrDefault("uploadType")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "uploadType", valid_594018
  var valid_594019 = query.getOrDefault("key")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = nil)
  if valid_594019 != nil:
    section.add "key", valid_594019
  var valid_594020 = query.getOrDefault("$.xgafv")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = newJString("1"))
  if valid_594020 != nil:
    section.add "$.xgafv", valid_594020
  var valid_594021 = query.getOrDefault("pageSize")
  valid_594021 = validateParameter(valid_594021, JInt, required = false, default = nil)
  if valid_594021 != nil:
    section.add "pageSize", valid_594021
  var valid_594022 = query.getOrDefault("prettyPrint")
  valid_594022 = validateParameter(valid_594022, JBool, required = false,
                                 default = newJBool(true))
  if valid_594022 != nil:
    section.add "prettyPrint", valid_594022
  var valid_594023 = query.getOrDefault("filter")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = nil)
  if valid_594023 != nil:
    section.add "filter", valid_594023
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594024: Call_RedisProjectsLocationsList_594006; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Lists information about the supported locations for this service.
  ## 
  let valid = call_594024.validator(path, query, header, formData, body)
  let scheme = call_594024.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594024.url(scheme.get, call_594024.host, call_594024.base,
                         call_594024.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594024, url, valid)

proc call*(call_594025: Call_RedisProjectsLocationsList_594006; name: string;
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
  var path_594026 = newJObject()
  var query_594027 = newJObject()
  add(query_594027, "upload_protocol", newJString(uploadProtocol))
  add(query_594027, "fields", newJString(fields))
  add(query_594027, "pageToken", newJString(pageToken))
  add(query_594027, "quotaUser", newJString(quotaUser))
  add(path_594026, "name", newJString(name))
  add(query_594027, "alt", newJString(alt))
  add(query_594027, "oauth_token", newJString(oauthToken))
  add(query_594027, "callback", newJString(callback))
  add(query_594027, "access_token", newJString(accessToken))
  add(query_594027, "uploadType", newJString(uploadType))
  add(query_594027, "key", newJString(key))
  add(query_594027, "$.xgafv", newJString(Xgafv))
  add(query_594027, "pageSize", newJInt(pageSize))
  add(query_594027, "prettyPrint", newJBool(prettyPrint))
  add(query_594027, "filter", newJString(filter))
  result = call_594025.call(path_594026, query_594027, nil, nil, nil)

var redisProjectsLocationsList* = Call_RedisProjectsLocationsList_594006(
    name: "redisProjectsLocationsList", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1beta1/{name}/locations",
    validator: validate_RedisProjectsLocationsList_594007, base: "/",
    url: url_RedisProjectsLocationsList_594008, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsOperationsList_594028 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsOperationsList_594030(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: "/operations")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsOperationsList_594029(path: JsonNode;
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
  var valid_594031 = path.getOrDefault("name")
  valid_594031 = validateParameter(valid_594031, JString, required = true,
                                 default = nil)
  if valid_594031 != nil:
    section.add "name", valid_594031
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
  var valid_594032 = query.getOrDefault("upload_protocol")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = nil)
  if valid_594032 != nil:
    section.add "upload_protocol", valid_594032
  var valid_594033 = query.getOrDefault("fields")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "fields", valid_594033
  var valid_594034 = query.getOrDefault("pageToken")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "pageToken", valid_594034
  var valid_594035 = query.getOrDefault("quotaUser")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = nil)
  if valid_594035 != nil:
    section.add "quotaUser", valid_594035
  var valid_594036 = query.getOrDefault("alt")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = newJString("json"))
  if valid_594036 != nil:
    section.add "alt", valid_594036
  var valid_594037 = query.getOrDefault("oauth_token")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "oauth_token", valid_594037
  var valid_594038 = query.getOrDefault("callback")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "callback", valid_594038
  var valid_594039 = query.getOrDefault("access_token")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = nil)
  if valid_594039 != nil:
    section.add "access_token", valid_594039
  var valid_594040 = query.getOrDefault("uploadType")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "uploadType", valid_594040
  var valid_594041 = query.getOrDefault("key")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "key", valid_594041
  var valid_594042 = query.getOrDefault("$.xgafv")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = newJString("1"))
  if valid_594042 != nil:
    section.add "$.xgafv", valid_594042
  var valid_594043 = query.getOrDefault("pageSize")
  valid_594043 = validateParameter(valid_594043, JInt, required = false, default = nil)
  if valid_594043 != nil:
    section.add "pageSize", valid_594043
  var valid_594044 = query.getOrDefault("prettyPrint")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "prettyPrint", valid_594044
  var valid_594045 = query.getOrDefault("filter")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "filter", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_RedisProjectsLocationsOperationsList_594028;
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
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_RedisProjectsLocationsOperationsList_594028;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(query_594049, "upload_protocol", newJString(uploadProtocol))
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "pageToken", newJString(pageToken))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(path_594048, "name", newJString(name))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(query_594049, "callback", newJString(callback))
  add(query_594049, "access_token", newJString(accessToken))
  add(query_594049, "uploadType", newJString(uploadType))
  add(query_594049, "key", newJString(key))
  add(query_594049, "$.xgafv", newJString(Xgafv))
  add(query_594049, "pageSize", newJInt(pageSize))
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  add(query_594049, "filter", newJString(filter))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var redisProjectsLocationsOperationsList* = Call_RedisProjectsLocationsOperationsList_594028(
    name: "redisProjectsLocationsOperationsList", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1beta1/{name}/operations",
    validator: validate_RedisProjectsLocationsOperationsList_594029, base: "/",
    url: url_RedisProjectsLocationsOperationsList_594030, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsOperationsCancel_594050 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsOperationsCancel_594052(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":cancel")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsOperationsCancel_594051(path: JsonNode;
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
  var valid_594053 = path.getOrDefault("name")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "name", valid_594053
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
  var valid_594054 = query.getOrDefault("upload_protocol")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "upload_protocol", valid_594054
  var valid_594055 = query.getOrDefault("fields")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "fields", valid_594055
  var valid_594056 = query.getOrDefault("quotaUser")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "quotaUser", valid_594056
  var valid_594057 = query.getOrDefault("alt")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = newJString("json"))
  if valid_594057 != nil:
    section.add "alt", valid_594057
  var valid_594058 = query.getOrDefault("oauth_token")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "oauth_token", valid_594058
  var valid_594059 = query.getOrDefault("callback")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "callback", valid_594059
  var valid_594060 = query.getOrDefault("access_token")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "access_token", valid_594060
  var valid_594061 = query.getOrDefault("uploadType")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "uploadType", valid_594061
  var valid_594062 = query.getOrDefault("key")
  valid_594062 = validateParameter(valid_594062, JString, required = false,
                                 default = nil)
  if valid_594062 != nil:
    section.add "key", valid_594062
  var valid_594063 = query.getOrDefault("$.xgafv")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = newJString("1"))
  if valid_594063 != nil:
    section.add "$.xgafv", valid_594063
  var valid_594064 = query.getOrDefault("prettyPrint")
  valid_594064 = validateParameter(valid_594064, JBool, required = false,
                                 default = newJBool(true))
  if valid_594064 != nil:
    section.add "prettyPrint", valid_594064
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594065: Call_RedisProjectsLocationsOperationsCancel_594050;
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
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_RedisProjectsLocationsOperationsCancel_594050;
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
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  add(query_594068, "upload_protocol", newJString(uploadProtocol))
  add(query_594068, "fields", newJString(fields))
  add(query_594068, "quotaUser", newJString(quotaUser))
  add(path_594067, "name", newJString(name))
  add(query_594068, "alt", newJString(alt))
  add(query_594068, "oauth_token", newJString(oauthToken))
  add(query_594068, "callback", newJString(callback))
  add(query_594068, "access_token", newJString(accessToken))
  add(query_594068, "uploadType", newJString(uploadType))
  add(query_594068, "key", newJString(key))
  add(query_594068, "$.xgafv", newJString(Xgafv))
  add(query_594068, "prettyPrint", newJBool(prettyPrint))
  result = call_594066.call(path_594067, query_594068, nil, nil, nil)

var redisProjectsLocationsOperationsCancel* = Call_RedisProjectsLocationsOperationsCancel_594050(
    name: "redisProjectsLocationsOperationsCancel", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1beta1/{name}:cancel",
    validator: validate_RedisProjectsLocationsOperationsCancel_594051, base: "/",
    url: url_RedisProjectsLocationsOperationsCancel_594052,
    schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesExport_594069 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesExport_594071(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":export")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesExport_594070(path: JsonNode;
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
  var valid_594072 = path.getOrDefault("name")
  valid_594072 = validateParameter(valid_594072, JString, required = true,
                                 default = nil)
  if valid_594072 != nil:
    section.add "name", valid_594072
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
  var valid_594073 = query.getOrDefault("upload_protocol")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "upload_protocol", valid_594073
  var valid_594074 = query.getOrDefault("fields")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "fields", valid_594074
  var valid_594075 = query.getOrDefault("quotaUser")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = nil)
  if valid_594075 != nil:
    section.add "quotaUser", valid_594075
  var valid_594076 = query.getOrDefault("alt")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = newJString("json"))
  if valid_594076 != nil:
    section.add "alt", valid_594076
  var valid_594077 = query.getOrDefault("oauth_token")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "oauth_token", valid_594077
  var valid_594078 = query.getOrDefault("callback")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "callback", valid_594078
  var valid_594079 = query.getOrDefault("access_token")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "access_token", valid_594079
  var valid_594080 = query.getOrDefault("uploadType")
  valid_594080 = validateParameter(valid_594080, JString, required = false,
                                 default = nil)
  if valid_594080 != nil:
    section.add "uploadType", valid_594080
  var valid_594081 = query.getOrDefault("key")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "key", valid_594081
  var valid_594082 = query.getOrDefault("$.xgafv")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = newJString("1"))
  if valid_594082 != nil:
    section.add "$.xgafv", valid_594082
  var valid_594083 = query.getOrDefault("prettyPrint")
  valid_594083 = validateParameter(valid_594083, JBool, required = false,
                                 default = newJBool(true))
  if valid_594083 != nil:
    section.add "prettyPrint", valid_594083
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

proc call*(call_594085: Call_RedisProjectsLocationsInstancesExport_594069;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Export Redis instance data into a Redis RDB format file in Cloud Storage.
  ## 
  ## Redis will continue serving during this operation.
  ## 
  ## The returned operation is automatically deleted after a few hours, so
  ## there is no need to call DeleteOperation.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_RedisProjectsLocationsInstancesExport_594069;
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
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  var body_594089 = newJObject()
  add(query_594088, "upload_protocol", newJString(uploadProtocol))
  add(query_594088, "fields", newJString(fields))
  add(query_594088, "quotaUser", newJString(quotaUser))
  add(path_594087, "name", newJString(name))
  add(query_594088, "alt", newJString(alt))
  add(query_594088, "oauth_token", newJString(oauthToken))
  add(query_594088, "callback", newJString(callback))
  add(query_594088, "access_token", newJString(accessToken))
  add(query_594088, "uploadType", newJString(uploadType))
  add(query_594088, "key", newJString(key))
  add(query_594088, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594089 = body
  add(query_594088, "prettyPrint", newJBool(prettyPrint))
  result = call_594086.call(path_594087, query_594088, nil, nil, body_594089)

var redisProjectsLocationsInstancesExport* = Call_RedisProjectsLocationsInstancesExport_594069(
    name: "redisProjectsLocationsInstancesExport", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1beta1/{name}:export",
    validator: validate_RedisProjectsLocationsInstancesExport_594070, base: "/",
    url: url_RedisProjectsLocationsInstancesExport_594071, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesFailover_594090 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesFailover_594092(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":failover")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesFailover_594091(path: JsonNode;
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
  var valid_594093 = path.getOrDefault("name")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "name", valid_594093
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
  var valid_594094 = query.getOrDefault("upload_protocol")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "upload_protocol", valid_594094
  var valid_594095 = query.getOrDefault("fields")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "fields", valid_594095
  var valid_594096 = query.getOrDefault("quotaUser")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = nil)
  if valid_594096 != nil:
    section.add "quotaUser", valid_594096
  var valid_594097 = query.getOrDefault("alt")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = newJString("json"))
  if valid_594097 != nil:
    section.add "alt", valid_594097
  var valid_594098 = query.getOrDefault("oauth_token")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "oauth_token", valid_594098
  var valid_594099 = query.getOrDefault("callback")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "callback", valid_594099
  var valid_594100 = query.getOrDefault("access_token")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "access_token", valid_594100
  var valid_594101 = query.getOrDefault("uploadType")
  valid_594101 = validateParameter(valid_594101, JString, required = false,
                                 default = nil)
  if valid_594101 != nil:
    section.add "uploadType", valid_594101
  var valid_594102 = query.getOrDefault("key")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "key", valid_594102
  var valid_594103 = query.getOrDefault("$.xgafv")
  valid_594103 = validateParameter(valid_594103, JString, required = false,
                                 default = newJString("1"))
  if valid_594103 != nil:
    section.add "$.xgafv", valid_594103
  var valid_594104 = query.getOrDefault("prettyPrint")
  valid_594104 = validateParameter(valid_594104, JBool, required = false,
                                 default = newJBool(true))
  if valid_594104 != nil:
    section.add "prettyPrint", valid_594104
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

proc call*(call_594106: Call_RedisProjectsLocationsInstancesFailover_594090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Initiates a failover of the master node to current replica node for a
  ## specific STANDARD tier Cloud Memorystore for Redis instance.
  ## 
  let valid = call_594106.validator(path, query, header, formData, body)
  let scheme = call_594106.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594106.url(scheme.get, call_594106.host, call_594106.base,
                         call_594106.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594106, url, valid)

proc call*(call_594107: Call_RedisProjectsLocationsInstancesFailover_594090;
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
  var path_594108 = newJObject()
  var query_594109 = newJObject()
  var body_594110 = newJObject()
  add(query_594109, "upload_protocol", newJString(uploadProtocol))
  add(query_594109, "fields", newJString(fields))
  add(query_594109, "quotaUser", newJString(quotaUser))
  add(path_594108, "name", newJString(name))
  add(query_594109, "alt", newJString(alt))
  add(query_594109, "oauth_token", newJString(oauthToken))
  add(query_594109, "callback", newJString(callback))
  add(query_594109, "access_token", newJString(accessToken))
  add(query_594109, "uploadType", newJString(uploadType))
  add(query_594109, "key", newJString(key))
  add(query_594109, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594110 = body
  add(query_594109, "prettyPrint", newJBool(prettyPrint))
  result = call_594107.call(path_594108, query_594109, nil, nil, body_594110)

var redisProjectsLocationsInstancesFailover* = Call_RedisProjectsLocationsInstancesFailover_594090(
    name: "redisProjectsLocationsInstancesFailover", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1beta1/{name}:failover",
    validator: validate_RedisProjectsLocationsInstancesFailover_594091, base: "/",
    url: url_RedisProjectsLocationsInstancesFailover_594092,
    schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesImport_594111 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesImport_594113(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "name" in path, "`name` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "name"),
               (kind: ConstantSegment, value: ":import")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesImport_594112(path: JsonNode;
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
  var valid_594114 = path.getOrDefault("name")
  valid_594114 = validateParameter(valid_594114, JString, required = true,
                                 default = nil)
  if valid_594114 != nil:
    section.add "name", valid_594114
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
  var valid_594115 = query.getOrDefault("upload_protocol")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "upload_protocol", valid_594115
  var valid_594116 = query.getOrDefault("fields")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "fields", valid_594116
  var valid_594117 = query.getOrDefault("quotaUser")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "quotaUser", valid_594117
  var valid_594118 = query.getOrDefault("alt")
  valid_594118 = validateParameter(valid_594118, JString, required = false,
                                 default = newJString("json"))
  if valid_594118 != nil:
    section.add "alt", valid_594118
  var valid_594119 = query.getOrDefault("oauth_token")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "oauth_token", valid_594119
  var valid_594120 = query.getOrDefault("callback")
  valid_594120 = validateParameter(valid_594120, JString, required = false,
                                 default = nil)
  if valid_594120 != nil:
    section.add "callback", valid_594120
  var valid_594121 = query.getOrDefault("access_token")
  valid_594121 = validateParameter(valid_594121, JString, required = false,
                                 default = nil)
  if valid_594121 != nil:
    section.add "access_token", valid_594121
  var valid_594122 = query.getOrDefault("uploadType")
  valid_594122 = validateParameter(valid_594122, JString, required = false,
                                 default = nil)
  if valid_594122 != nil:
    section.add "uploadType", valid_594122
  var valid_594123 = query.getOrDefault("key")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "key", valid_594123
  var valid_594124 = query.getOrDefault("$.xgafv")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = newJString("1"))
  if valid_594124 != nil:
    section.add "$.xgafv", valid_594124
  var valid_594125 = query.getOrDefault("prettyPrint")
  valid_594125 = validateParameter(valid_594125, JBool, required = false,
                                 default = newJBool(true))
  if valid_594125 != nil:
    section.add "prettyPrint", valid_594125
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

proc call*(call_594127: Call_RedisProjectsLocationsInstancesImport_594111;
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
  let valid = call_594127.validator(path, query, header, formData, body)
  let scheme = call_594127.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594127.url(scheme.get, call_594127.host, call_594127.base,
                         call_594127.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594127, url, valid)

proc call*(call_594128: Call_RedisProjectsLocationsInstancesImport_594111;
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
  var path_594129 = newJObject()
  var query_594130 = newJObject()
  var body_594131 = newJObject()
  add(query_594130, "upload_protocol", newJString(uploadProtocol))
  add(query_594130, "fields", newJString(fields))
  add(query_594130, "quotaUser", newJString(quotaUser))
  add(path_594129, "name", newJString(name))
  add(query_594130, "alt", newJString(alt))
  add(query_594130, "oauth_token", newJString(oauthToken))
  add(query_594130, "callback", newJString(callback))
  add(query_594130, "access_token", newJString(accessToken))
  add(query_594130, "uploadType", newJString(uploadType))
  add(query_594130, "key", newJString(key))
  add(query_594130, "$.xgafv", newJString(Xgafv))
  if body != nil:
    body_594131 = body
  add(query_594130, "prettyPrint", newJBool(prettyPrint))
  result = call_594128.call(path_594129, query_594130, nil, nil, body_594131)

var redisProjectsLocationsInstancesImport* = Call_RedisProjectsLocationsInstancesImport_594111(
    name: "redisProjectsLocationsInstancesImport", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1beta1/{name}:import",
    validator: validate_RedisProjectsLocationsInstancesImport_594112, base: "/",
    url: url_RedisProjectsLocationsInstancesImport_594113, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesCreate_594153 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesCreate_594155(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesCreate_594154(path: JsonNode;
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
  var valid_594156 = path.getOrDefault("parent")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "parent", valid_594156
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
  var valid_594157 = query.getOrDefault("upload_protocol")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "upload_protocol", valid_594157
  var valid_594158 = query.getOrDefault("fields")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "fields", valid_594158
  var valid_594159 = query.getOrDefault("quotaUser")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = nil)
  if valid_594159 != nil:
    section.add "quotaUser", valid_594159
  var valid_594160 = query.getOrDefault("alt")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = newJString("json"))
  if valid_594160 != nil:
    section.add "alt", valid_594160
  var valid_594161 = query.getOrDefault("oauth_token")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "oauth_token", valid_594161
  var valid_594162 = query.getOrDefault("callback")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "callback", valid_594162
  var valid_594163 = query.getOrDefault("access_token")
  valid_594163 = validateParameter(valid_594163, JString, required = false,
                                 default = nil)
  if valid_594163 != nil:
    section.add "access_token", valid_594163
  var valid_594164 = query.getOrDefault("uploadType")
  valid_594164 = validateParameter(valid_594164, JString, required = false,
                                 default = nil)
  if valid_594164 != nil:
    section.add "uploadType", valid_594164
  var valid_594165 = query.getOrDefault("key")
  valid_594165 = validateParameter(valid_594165, JString, required = false,
                                 default = nil)
  if valid_594165 != nil:
    section.add "key", valid_594165
  var valid_594166 = query.getOrDefault("$.xgafv")
  valid_594166 = validateParameter(valid_594166, JString, required = false,
                                 default = newJString("1"))
  if valid_594166 != nil:
    section.add "$.xgafv", valid_594166
  var valid_594167 = query.getOrDefault("instanceId")
  valid_594167 = validateParameter(valid_594167, JString, required = false,
                                 default = nil)
  if valid_594167 != nil:
    section.add "instanceId", valid_594167
  var valid_594168 = query.getOrDefault("prettyPrint")
  valid_594168 = validateParameter(valid_594168, JBool, required = false,
                                 default = newJBool(true))
  if valid_594168 != nil:
    section.add "prettyPrint", valid_594168
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

proc call*(call_594170: Call_RedisProjectsLocationsInstancesCreate_594153;
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
  let valid = call_594170.validator(path, query, header, formData, body)
  let scheme = call_594170.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594170.url(scheme.get, call_594170.host, call_594170.base,
                         call_594170.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594170, url, valid)

proc call*(call_594171: Call_RedisProjectsLocationsInstancesCreate_594153;
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
  var path_594172 = newJObject()
  var query_594173 = newJObject()
  var body_594174 = newJObject()
  add(query_594173, "upload_protocol", newJString(uploadProtocol))
  add(query_594173, "fields", newJString(fields))
  add(query_594173, "quotaUser", newJString(quotaUser))
  add(query_594173, "alt", newJString(alt))
  add(query_594173, "oauth_token", newJString(oauthToken))
  add(query_594173, "callback", newJString(callback))
  add(query_594173, "access_token", newJString(accessToken))
  add(query_594173, "uploadType", newJString(uploadType))
  add(path_594172, "parent", newJString(parent))
  add(query_594173, "key", newJString(key))
  add(query_594173, "$.xgafv", newJString(Xgafv))
  add(query_594173, "instanceId", newJString(instanceId))
  if body != nil:
    body_594174 = body
  add(query_594173, "prettyPrint", newJBool(prettyPrint))
  result = call_594171.call(path_594172, query_594173, nil, nil, body_594174)

var redisProjectsLocationsInstancesCreate* = Call_RedisProjectsLocationsInstancesCreate_594153(
    name: "redisProjectsLocationsInstancesCreate", meth: HttpMethod.HttpPost,
    host: "redis.googleapis.com", route: "/v1beta1/{parent}/instances",
    validator: validate_RedisProjectsLocationsInstancesCreate_594154, base: "/",
    url: url_RedisProjectsLocationsInstancesCreate_594155, schemes: {Scheme.Https})
type
  Call_RedisProjectsLocationsInstancesList_594132 = ref object of OpenApiRestCall_593408
proc url_RedisProjectsLocationsInstancesList_594134(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "parent" in path, "`parent` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/v1beta1/"),
               (kind: VariableSegment, value: "parent"),
               (kind: ConstantSegment, value: "/instances")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_RedisProjectsLocationsInstancesList_594133(path: JsonNode;
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
  var valid_594135 = path.getOrDefault("parent")
  valid_594135 = validateParameter(valid_594135, JString, required = true,
                                 default = nil)
  if valid_594135 != nil:
    section.add "parent", valid_594135
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
  var valid_594136 = query.getOrDefault("upload_protocol")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "upload_protocol", valid_594136
  var valid_594137 = query.getOrDefault("fields")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "fields", valid_594137
  var valid_594138 = query.getOrDefault("pageToken")
  valid_594138 = validateParameter(valid_594138, JString, required = false,
                                 default = nil)
  if valid_594138 != nil:
    section.add "pageToken", valid_594138
  var valid_594139 = query.getOrDefault("quotaUser")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "quotaUser", valid_594139
  var valid_594140 = query.getOrDefault("alt")
  valid_594140 = validateParameter(valid_594140, JString, required = false,
                                 default = newJString("json"))
  if valid_594140 != nil:
    section.add "alt", valid_594140
  var valid_594141 = query.getOrDefault("oauth_token")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "oauth_token", valid_594141
  var valid_594142 = query.getOrDefault("callback")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "callback", valid_594142
  var valid_594143 = query.getOrDefault("access_token")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = nil)
  if valid_594143 != nil:
    section.add "access_token", valid_594143
  var valid_594144 = query.getOrDefault("uploadType")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "uploadType", valid_594144
  var valid_594145 = query.getOrDefault("key")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "key", valid_594145
  var valid_594146 = query.getOrDefault("$.xgafv")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = newJString("1"))
  if valid_594146 != nil:
    section.add "$.xgafv", valid_594146
  var valid_594147 = query.getOrDefault("pageSize")
  valid_594147 = validateParameter(valid_594147, JInt, required = false, default = nil)
  if valid_594147 != nil:
    section.add "pageSize", valid_594147
  var valid_594148 = query.getOrDefault("prettyPrint")
  valid_594148 = validateParameter(valid_594148, JBool, required = false,
                                 default = newJBool(true))
  if valid_594148 != nil:
    section.add "prettyPrint", valid_594148
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594149: Call_RedisProjectsLocationsInstancesList_594132;
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
  let valid = call_594149.validator(path, query, header, formData, body)
  let scheme = call_594149.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594149.url(scheme.get, call_594149.host, call_594149.base,
                         call_594149.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594149, url, valid)

proc call*(call_594150: Call_RedisProjectsLocationsInstancesList_594132;
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
  var path_594151 = newJObject()
  var query_594152 = newJObject()
  add(query_594152, "upload_protocol", newJString(uploadProtocol))
  add(query_594152, "fields", newJString(fields))
  add(query_594152, "pageToken", newJString(pageToken))
  add(query_594152, "quotaUser", newJString(quotaUser))
  add(query_594152, "alt", newJString(alt))
  add(query_594152, "oauth_token", newJString(oauthToken))
  add(query_594152, "callback", newJString(callback))
  add(query_594152, "access_token", newJString(accessToken))
  add(query_594152, "uploadType", newJString(uploadType))
  add(path_594151, "parent", newJString(parent))
  add(query_594152, "key", newJString(key))
  add(query_594152, "$.xgafv", newJString(Xgafv))
  add(query_594152, "pageSize", newJInt(pageSize))
  add(query_594152, "prettyPrint", newJBool(prettyPrint))
  result = call_594150.call(path_594151, query_594152, nil, nil, nil)

var redisProjectsLocationsInstancesList* = Call_RedisProjectsLocationsInstancesList_594132(
    name: "redisProjectsLocationsInstancesList", meth: HttpMethod.HttpGet,
    host: "redis.googleapis.com", route: "/v1beta1/{parent}/instances",
    validator: validate_RedisProjectsLocationsInstancesList_594133, base: "/",
    url: url_RedisProjectsLocationsInstancesList_594134, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
