
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1beta1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Lets you store and retrieve potentially-large, immutable data objects.
## 
## https://developers.google.com/storage/docs/json_api/
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

  OpenApiRestCall_588457 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_588457](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_588457): Option[Scheme] {.used.} =
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
    if js.kind notin {JString, JInt, JFloat, JNull, JBool}:
      return
    head = $js
  var remainder = input.hydratePath(segments[1 ..^ 1])
  if remainder.isNone:
    return
  result = some(head & remainder.get)

const
  gcpServiceName = "storage"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageBucketsInsert_588997 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsInsert_588999(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_588998(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589000 = query.getOrDefault("fields")
  valid_589000 = validateParameter(valid_589000, JString, required = false,
                                 default = nil)
  if valid_589000 != nil:
    section.add "fields", valid_589000
  var valid_589001 = query.getOrDefault("quotaUser")
  valid_589001 = validateParameter(valid_589001, JString, required = false,
                                 default = nil)
  if valid_589001 != nil:
    section.add "quotaUser", valid_589001
  var valid_589002 = query.getOrDefault("alt")
  valid_589002 = validateParameter(valid_589002, JString, required = false,
                                 default = newJString("json"))
  if valid_589002 != nil:
    section.add "alt", valid_589002
  var valid_589003 = query.getOrDefault("oauth_token")
  valid_589003 = validateParameter(valid_589003, JString, required = false,
                                 default = nil)
  if valid_589003 != nil:
    section.add "oauth_token", valid_589003
  var valid_589004 = query.getOrDefault("userIp")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "userIp", valid_589004
  var valid_589005 = query.getOrDefault("key")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "key", valid_589005
  var valid_589006 = query.getOrDefault("projection")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("full"))
  if valid_589006 != nil:
    section.add "projection", valid_589006
  var valid_589007 = query.getOrDefault("prettyPrint")
  valid_589007 = validateParameter(valid_589007, JBool, required = false,
                                 default = newJBool(true))
  if valid_589007 != nil:
    section.add "prettyPrint", valid_589007
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

proc call*(call_589009: Call_StorageBucketsInsert_588997; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_589009.validator(path, query, header, formData, body)
  let scheme = call_589009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589009.url(scheme.get, call_589009.host, call_589009.base,
                         call_589009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589009, url, valid)

proc call*(call_589010: Call_StorageBucketsInsert_588997; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; projection: string = "full";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageBucketsInsert
  ## Creates a new bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_589011 = newJObject()
  var body_589012 = newJObject()
  add(query_589011, "fields", newJString(fields))
  add(query_589011, "quotaUser", newJString(quotaUser))
  add(query_589011, "alt", newJString(alt))
  add(query_589011, "oauth_token", newJString(oauthToken))
  add(query_589011, "userIp", newJString(userIp))
  add(query_589011, "key", newJString(key))
  add(query_589011, "projection", newJString(projection))
  if body != nil:
    body_589012 = body
  add(query_589011, "prettyPrint", newJBool(prettyPrint))
  result = call_589010.call(nil, query_589011, nil, nil, body_589012)

var storageBucketsInsert* = Call_StorageBucketsInsert_588997(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_588998, base: "/storage/v1beta1",
    url: url_StorageBucketsInsert_588999, schemes: {Scheme.Https})
type
  Call_StorageBucketsList_588725 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsList_588727(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsList_588726(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of buckets for a given project.
  ## 
  var section: JsonNode
  result = newJObject()
  section = newJObject()
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : Maximum number of buckets to return.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   projectId: JString (required)
  ##            : A valid API project identifier.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_588839 = query.getOrDefault("fields")
  valid_588839 = validateParameter(valid_588839, JString, required = false,
                                 default = nil)
  if valid_588839 != nil:
    section.add "fields", valid_588839
  var valid_588840 = query.getOrDefault("pageToken")
  valid_588840 = validateParameter(valid_588840, JString, required = false,
                                 default = nil)
  if valid_588840 != nil:
    section.add "pageToken", valid_588840
  var valid_588841 = query.getOrDefault("quotaUser")
  valid_588841 = validateParameter(valid_588841, JString, required = false,
                                 default = nil)
  if valid_588841 != nil:
    section.add "quotaUser", valid_588841
  var valid_588855 = query.getOrDefault("alt")
  valid_588855 = validateParameter(valid_588855, JString, required = false,
                                 default = newJString("json"))
  if valid_588855 != nil:
    section.add "alt", valid_588855
  var valid_588856 = query.getOrDefault("oauth_token")
  valid_588856 = validateParameter(valid_588856, JString, required = false,
                                 default = nil)
  if valid_588856 != nil:
    section.add "oauth_token", valid_588856
  var valid_588857 = query.getOrDefault("userIp")
  valid_588857 = validateParameter(valid_588857, JString, required = false,
                                 default = nil)
  if valid_588857 != nil:
    section.add "userIp", valid_588857
  var valid_588858 = query.getOrDefault("key")
  valid_588858 = validateParameter(valid_588858, JString, required = false,
                                 default = nil)
  if valid_588858 != nil:
    section.add "key", valid_588858
  var valid_588859 = query.getOrDefault("max-results")
  valid_588859 = validateParameter(valid_588859, JInt, required = false, default = nil)
  if valid_588859 != nil:
    section.add "max-results", valid_588859
  var valid_588860 = query.getOrDefault("projection")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = newJString("full"))
  if valid_588860 != nil:
    section.add "projection", valid_588860
  assert query != nil,
        "query argument is necessary due to required `projectId` field"
  var valid_588861 = query.getOrDefault("projectId")
  valid_588861 = validateParameter(valid_588861, JString, required = true,
                                 default = nil)
  if valid_588861 != nil:
    section.add "projectId", valid_588861
  var valid_588862 = query.getOrDefault("prettyPrint")
  valid_588862 = validateParameter(valid_588862, JBool, required = false,
                                 default = newJBool(true))
  if valid_588862 != nil:
    section.add "prettyPrint", valid_588862
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588885: Call_StorageBucketsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_588885.validator(path, query, header, formData, body)
  let scheme = call_588885.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588885.url(scheme.get, call_588885.host, call_588885.base,
                         call_588885.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588885, url, valid)

proc call*(call_588956: Call_StorageBucketsList_588725; projectId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; projection: string = "full";
          prettyPrint: bool = true): Recallable =
  ## storageBucketsList
  ## Retrieves a list of buckets for a given project.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : Maximum number of buckets to return.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   projectId: string (required)
  ##            : A valid API project identifier.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_588957 = newJObject()
  add(query_588957, "fields", newJString(fields))
  add(query_588957, "pageToken", newJString(pageToken))
  add(query_588957, "quotaUser", newJString(quotaUser))
  add(query_588957, "alt", newJString(alt))
  add(query_588957, "oauth_token", newJString(oauthToken))
  add(query_588957, "userIp", newJString(userIp))
  add(query_588957, "key", newJString(key))
  add(query_588957, "max-results", newJInt(maxResults))
  add(query_588957, "projection", newJString(projection))
  add(query_588957, "projectId", newJString(projectId))
  add(query_588957, "prettyPrint", newJBool(prettyPrint))
  result = call_588956.call(nil, query_588957, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_588725(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsList_588726, base: "/storage/v1beta1",
    url: url_StorageBucketsList_588727, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_589043 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsUpdate_589045(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsUpdate_589044(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589046 = path.getOrDefault("bucket")
  valid_589046 = validateParameter(valid_589046, JString, required = true,
                                 default = nil)
  if valid_589046 != nil:
    section.add "bucket", valid_589046
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589047 = query.getOrDefault("fields")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = nil)
  if valid_589047 != nil:
    section.add "fields", valid_589047
  var valid_589048 = query.getOrDefault("quotaUser")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "quotaUser", valid_589048
  var valid_589049 = query.getOrDefault("alt")
  valid_589049 = validateParameter(valid_589049, JString, required = false,
                                 default = newJString("json"))
  if valid_589049 != nil:
    section.add "alt", valid_589049
  var valid_589050 = query.getOrDefault("oauth_token")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "oauth_token", valid_589050
  var valid_589051 = query.getOrDefault("userIp")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "userIp", valid_589051
  var valid_589052 = query.getOrDefault("key")
  valid_589052 = validateParameter(valid_589052, JString, required = false,
                                 default = nil)
  if valid_589052 != nil:
    section.add "key", valid_589052
  var valid_589053 = query.getOrDefault("projection")
  valid_589053 = validateParameter(valid_589053, JString, required = false,
                                 default = newJString("full"))
  if valid_589053 != nil:
    section.add "projection", valid_589053
  var valid_589054 = query.getOrDefault("prettyPrint")
  valid_589054 = validateParameter(valid_589054, JBool, required = false,
                                 default = newJBool(true))
  if valid_589054 != nil:
    section.add "prettyPrint", valid_589054
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

proc call*(call_589056: Call_StorageBucketsUpdate_589043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket.
  ## 
  let valid = call_589056.validator(path, query, header, formData, body)
  let scheme = call_589056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589056.url(scheme.get, call_589056.host, call_589056.base,
                         call_589056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589056, url, valid)

proc call*(call_589057: Call_StorageBucketsUpdate_589043; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageBucketsUpdate
  ## Updates a bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589058 = newJObject()
  var query_589059 = newJObject()
  var body_589060 = newJObject()
  add(path_589058, "bucket", newJString(bucket))
  add(query_589059, "fields", newJString(fields))
  add(query_589059, "quotaUser", newJString(quotaUser))
  add(query_589059, "alt", newJString(alt))
  add(query_589059, "oauth_token", newJString(oauthToken))
  add(query_589059, "userIp", newJString(userIp))
  add(query_589059, "key", newJString(key))
  add(query_589059, "projection", newJString(projection))
  if body != nil:
    body_589060 = body
  add(query_589059, "prettyPrint", newJBool(prettyPrint))
  result = call_589057.call(path_589058, query_589059, nil, nil, body_589060)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_589043(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_589044, base: "/storage/v1beta1",
    url: url_StorageBucketsUpdate_589045, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_589013 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsGet_589015(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsGet_589014(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Returns metadata for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589030 = path.getOrDefault("bucket")
  valid_589030 = validateParameter(valid_589030, JString, required = true,
                                 default = nil)
  if valid_589030 != nil:
    section.add "bucket", valid_589030
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589031 = query.getOrDefault("fields")
  valid_589031 = validateParameter(valid_589031, JString, required = false,
                                 default = nil)
  if valid_589031 != nil:
    section.add "fields", valid_589031
  var valid_589032 = query.getOrDefault("quotaUser")
  valid_589032 = validateParameter(valid_589032, JString, required = false,
                                 default = nil)
  if valid_589032 != nil:
    section.add "quotaUser", valid_589032
  var valid_589033 = query.getOrDefault("alt")
  valid_589033 = validateParameter(valid_589033, JString, required = false,
                                 default = newJString("json"))
  if valid_589033 != nil:
    section.add "alt", valid_589033
  var valid_589034 = query.getOrDefault("oauth_token")
  valid_589034 = validateParameter(valid_589034, JString, required = false,
                                 default = nil)
  if valid_589034 != nil:
    section.add "oauth_token", valid_589034
  var valid_589035 = query.getOrDefault("userIp")
  valid_589035 = validateParameter(valid_589035, JString, required = false,
                                 default = nil)
  if valid_589035 != nil:
    section.add "userIp", valid_589035
  var valid_589036 = query.getOrDefault("key")
  valid_589036 = validateParameter(valid_589036, JString, required = false,
                                 default = nil)
  if valid_589036 != nil:
    section.add "key", valid_589036
  var valid_589037 = query.getOrDefault("projection")
  valid_589037 = validateParameter(valid_589037, JString, required = false,
                                 default = newJString("full"))
  if valid_589037 != nil:
    section.add "projection", valid_589037
  var valid_589038 = query.getOrDefault("prettyPrint")
  valid_589038 = validateParameter(valid_589038, JBool, required = false,
                                 default = newJBool(true))
  if valid_589038 != nil:
    section.add "prettyPrint", valid_589038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589039: Call_StorageBucketsGet_589013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_589039.validator(path, query, header, formData, body)
  let scheme = call_589039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589039.url(scheme.get, call_589039.host, call_589039.base,
                         call_589039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589039, url, valid)

proc call*(call_589040: Call_StorageBucketsGet_589013; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; prettyPrint: bool = true): Recallable =
  ## storageBucketsGet
  ## Returns metadata for the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589041 = newJObject()
  var query_589042 = newJObject()
  add(path_589041, "bucket", newJString(bucket))
  add(query_589042, "fields", newJString(fields))
  add(query_589042, "quotaUser", newJString(quotaUser))
  add(query_589042, "alt", newJString(alt))
  add(query_589042, "oauth_token", newJString(oauthToken))
  add(query_589042, "userIp", newJString(userIp))
  add(query_589042, "key", newJString(key))
  add(query_589042, "projection", newJString(projection))
  add(query_589042, "prettyPrint", newJBool(prettyPrint))
  result = call_589040.call(path_589041, query_589042, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_589013(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_589014, base: "/storage/v1beta1",
    url: url_StorageBucketsGet_589015, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_589076 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsPatch_589078(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsPatch_589077(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589079 = path.getOrDefault("bucket")
  valid_589079 = validateParameter(valid_589079, JString, required = true,
                                 default = nil)
  if valid_589079 != nil:
    section.add "bucket", valid_589079
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589080 = query.getOrDefault("fields")
  valid_589080 = validateParameter(valid_589080, JString, required = false,
                                 default = nil)
  if valid_589080 != nil:
    section.add "fields", valid_589080
  var valid_589081 = query.getOrDefault("quotaUser")
  valid_589081 = validateParameter(valid_589081, JString, required = false,
                                 default = nil)
  if valid_589081 != nil:
    section.add "quotaUser", valid_589081
  var valid_589082 = query.getOrDefault("alt")
  valid_589082 = validateParameter(valid_589082, JString, required = false,
                                 default = newJString("json"))
  if valid_589082 != nil:
    section.add "alt", valid_589082
  var valid_589083 = query.getOrDefault("oauth_token")
  valid_589083 = validateParameter(valid_589083, JString, required = false,
                                 default = nil)
  if valid_589083 != nil:
    section.add "oauth_token", valid_589083
  var valid_589084 = query.getOrDefault("userIp")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "userIp", valid_589084
  var valid_589085 = query.getOrDefault("key")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "key", valid_589085
  var valid_589086 = query.getOrDefault("projection")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("full"))
  if valid_589086 != nil:
    section.add "projection", valid_589086
  var valid_589087 = query.getOrDefault("prettyPrint")
  valid_589087 = validateParameter(valid_589087, JBool, required = false,
                                 default = newJBool(true))
  if valid_589087 != nil:
    section.add "prettyPrint", valid_589087
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

proc call*(call_589089: Call_StorageBucketsPatch_589076; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  let valid = call_589089.validator(path, query, header, formData, body)
  let scheme = call_589089.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589089.url(scheme.get, call_589089.host, call_589089.base,
                         call_589089.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589089, url, valid)

proc call*(call_589090: Call_StorageBucketsPatch_589076; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageBucketsPatch
  ## Updates a bucket. This method supports patch semantics.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589091 = newJObject()
  var query_589092 = newJObject()
  var body_589093 = newJObject()
  add(path_589091, "bucket", newJString(bucket))
  add(query_589092, "fields", newJString(fields))
  add(query_589092, "quotaUser", newJString(quotaUser))
  add(query_589092, "alt", newJString(alt))
  add(query_589092, "oauth_token", newJString(oauthToken))
  add(query_589092, "userIp", newJString(userIp))
  add(query_589092, "key", newJString(key))
  add(query_589092, "projection", newJString(projection))
  if body != nil:
    body_589093 = body
  add(query_589092, "prettyPrint", newJBool(prettyPrint))
  result = call_589090.call(path_589091, query_589092, nil, nil, body_589093)

var storageBucketsPatch* = Call_StorageBucketsPatch_589076(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_589077, base: "/storage/v1beta1",
    url: url_StorageBucketsPatch_589078, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_589061 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsDelete_589063(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsDelete_589062(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an empty bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589064 = path.getOrDefault("bucket")
  valid_589064 = validateParameter(valid_589064, JString, required = true,
                                 default = nil)
  if valid_589064 != nil:
    section.add "bucket", valid_589064
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589065 = query.getOrDefault("fields")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = nil)
  if valid_589065 != nil:
    section.add "fields", valid_589065
  var valid_589066 = query.getOrDefault("quotaUser")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "quotaUser", valid_589066
  var valid_589067 = query.getOrDefault("alt")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = newJString("json"))
  if valid_589067 != nil:
    section.add "alt", valid_589067
  var valid_589068 = query.getOrDefault("oauth_token")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = nil)
  if valid_589068 != nil:
    section.add "oauth_token", valid_589068
  var valid_589069 = query.getOrDefault("userIp")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "userIp", valid_589069
  var valid_589070 = query.getOrDefault("key")
  valid_589070 = validateParameter(valid_589070, JString, required = false,
                                 default = nil)
  if valid_589070 != nil:
    section.add "key", valid_589070
  var valid_589071 = query.getOrDefault("prettyPrint")
  valid_589071 = validateParameter(valid_589071, JBool, required = false,
                                 default = newJBool(true))
  if valid_589071 != nil:
    section.add "prettyPrint", valid_589071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589072: Call_StorageBucketsDelete_589061; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an empty bucket.
  ## 
  let valid = call_589072.validator(path, query, header, formData, body)
  let scheme = call_589072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589072.url(scheme.get, call_589072.host, call_589072.base,
                         call_589072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589072, url, valid)

proc call*(call_589073: Call_StorageBucketsDelete_589061; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageBucketsDelete
  ## Deletes an empty bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589074 = newJObject()
  var query_589075 = newJObject()
  add(path_589074, "bucket", newJString(bucket))
  add(query_589075, "fields", newJString(fields))
  add(query_589075, "quotaUser", newJString(quotaUser))
  add(query_589075, "alt", newJString(alt))
  add(query_589075, "oauth_token", newJString(oauthToken))
  add(query_589075, "userIp", newJString(userIp))
  add(query_589075, "key", newJString(key))
  add(query_589075, "prettyPrint", newJBool(prettyPrint))
  result = call_589073.call(path_589074, query_589075, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_589061(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_589062, base: "/storage/v1beta1",
    url: url_StorageBucketsDelete_589063, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_589109 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsInsert_589111(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsInsert_589110(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589112 = path.getOrDefault("bucket")
  valid_589112 = validateParameter(valid_589112, JString, required = true,
                                 default = nil)
  if valid_589112 != nil:
    section.add "bucket", valid_589112
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589113 = query.getOrDefault("fields")
  valid_589113 = validateParameter(valid_589113, JString, required = false,
                                 default = nil)
  if valid_589113 != nil:
    section.add "fields", valid_589113
  var valid_589114 = query.getOrDefault("quotaUser")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "quotaUser", valid_589114
  var valid_589115 = query.getOrDefault("alt")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("json"))
  if valid_589115 != nil:
    section.add "alt", valid_589115
  var valid_589116 = query.getOrDefault("oauth_token")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "oauth_token", valid_589116
  var valid_589117 = query.getOrDefault("userIp")
  valid_589117 = validateParameter(valid_589117, JString, required = false,
                                 default = nil)
  if valid_589117 != nil:
    section.add "userIp", valid_589117
  var valid_589118 = query.getOrDefault("key")
  valid_589118 = validateParameter(valid_589118, JString, required = false,
                                 default = nil)
  if valid_589118 != nil:
    section.add "key", valid_589118
  var valid_589119 = query.getOrDefault("prettyPrint")
  valid_589119 = validateParameter(valid_589119, JBool, required = false,
                                 default = newJBool(true))
  if valid_589119 != nil:
    section.add "prettyPrint", valid_589119
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

proc call*(call_589121: Call_StorageBucketAccessControlsInsert_589109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_589121.validator(path, query, header, formData, body)
  let scheme = call_589121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589121.url(scheme.get, call_589121.host, call_589121.base,
                         call_589121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589121, url, valid)

proc call*(call_589122: Call_StorageBucketAccessControlsInsert_589109;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageBucketAccessControlsInsert
  ## Creates a new ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589123 = newJObject()
  var query_589124 = newJObject()
  var body_589125 = newJObject()
  add(path_589123, "bucket", newJString(bucket))
  add(query_589124, "fields", newJString(fields))
  add(query_589124, "quotaUser", newJString(quotaUser))
  add(query_589124, "alt", newJString(alt))
  add(query_589124, "oauth_token", newJString(oauthToken))
  add(query_589124, "userIp", newJString(userIp))
  add(query_589124, "key", newJString(key))
  if body != nil:
    body_589125 = body
  add(query_589124, "prettyPrint", newJBool(prettyPrint))
  result = call_589122.call(path_589123, query_589124, nil, nil, body_589125)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_589109(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_589110,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsInsert_589111,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_589094 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsList_589096(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsList_589095(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589097 = path.getOrDefault("bucket")
  valid_589097 = validateParameter(valid_589097, JString, required = true,
                                 default = nil)
  if valid_589097 != nil:
    section.add "bucket", valid_589097
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589098 = query.getOrDefault("fields")
  valid_589098 = validateParameter(valid_589098, JString, required = false,
                                 default = nil)
  if valid_589098 != nil:
    section.add "fields", valid_589098
  var valid_589099 = query.getOrDefault("quotaUser")
  valid_589099 = validateParameter(valid_589099, JString, required = false,
                                 default = nil)
  if valid_589099 != nil:
    section.add "quotaUser", valid_589099
  var valid_589100 = query.getOrDefault("alt")
  valid_589100 = validateParameter(valid_589100, JString, required = false,
                                 default = newJString("json"))
  if valid_589100 != nil:
    section.add "alt", valid_589100
  var valid_589101 = query.getOrDefault("oauth_token")
  valid_589101 = validateParameter(valid_589101, JString, required = false,
                                 default = nil)
  if valid_589101 != nil:
    section.add "oauth_token", valid_589101
  var valid_589102 = query.getOrDefault("userIp")
  valid_589102 = validateParameter(valid_589102, JString, required = false,
                                 default = nil)
  if valid_589102 != nil:
    section.add "userIp", valid_589102
  var valid_589103 = query.getOrDefault("key")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "key", valid_589103
  var valid_589104 = query.getOrDefault("prettyPrint")
  valid_589104 = validateParameter(valid_589104, JBool, required = false,
                                 default = newJBool(true))
  if valid_589104 != nil:
    section.add "prettyPrint", valid_589104
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589105: Call_StorageBucketAccessControlsList_589094;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_589105.validator(path, query, header, formData, body)
  let scheme = call_589105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589105.url(scheme.get, call_589105.host, call_589105.base,
                         call_589105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589105, url, valid)

proc call*(call_589106: Call_StorageBucketAccessControlsList_589094;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageBucketAccessControlsList
  ## Retrieves ACL entries on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589107 = newJObject()
  var query_589108 = newJObject()
  add(path_589107, "bucket", newJString(bucket))
  add(query_589108, "fields", newJString(fields))
  add(query_589108, "quotaUser", newJString(quotaUser))
  add(query_589108, "alt", newJString(alt))
  add(query_589108, "oauth_token", newJString(oauthToken))
  add(query_589108, "userIp", newJString(userIp))
  add(query_589108, "key", newJString(key))
  add(query_589108, "prettyPrint", newJBool(prettyPrint))
  result = call_589106.call(path_589107, query_589108, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_589094(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_589095,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsList_589096,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_589142 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsUpdate_589144(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsUpdate_589143(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589145 = path.getOrDefault("bucket")
  valid_589145 = validateParameter(valid_589145, JString, required = true,
                                 default = nil)
  if valid_589145 != nil:
    section.add "bucket", valid_589145
  var valid_589146 = path.getOrDefault("entity")
  valid_589146 = validateParameter(valid_589146, JString, required = true,
                                 default = nil)
  if valid_589146 != nil:
    section.add "entity", valid_589146
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589147 = query.getOrDefault("fields")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "fields", valid_589147
  var valid_589148 = query.getOrDefault("quotaUser")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "quotaUser", valid_589148
  var valid_589149 = query.getOrDefault("alt")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = newJString("json"))
  if valid_589149 != nil:
    section.add "alt", valid_589149
  var valid_589150 = query.getOrDefault("oauth_token")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "oauth_token", valid_589150
  var valid_589151 = query.getOrDefault("userIp")
  valid_589151 = validateParameter(valid_589151, JString, required = false,
                                 default = nil)
  if valid_589151 != nil:
    section.add "userIp", valid_589151
  var valid_589152 = query.getOrDefault("key")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "key", valid_589152
  var valid_589153 = query.getOrDefault("prettyPrint")
  valid_589153 = validateParameter(valid_589153, JBool, required = false,
                                 default = newJBool(true))
  if valid_589153 != nil:
    section.add "prettyPrint", valid_589153
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

proc call*(call_589155: Call_StorageBucketAccessControlsUpdate_589142;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_589155.validator(path, query, header, formData, body)
  let scheme = call_589155.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589155.url(scheme.get, call_589155.host, call_589155.base,
                         call_589155.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589155, url, valid)

proc call*(call_589156: Call_StorageBucketAccessControlsUpdate_589142;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageBucketAccessControlsUpdate
  ## Updates an ACL entry on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  var path_589157 = newJObject()
  var query_589158 = newJObject()
  var body_589159 = newJObject()
  add(path_589157, "bucket", newJString(bucket))
  add(query_589158, "fields", newJString(fields))
  add(query_589158, "quotaUser", newJString(quotaUser))
  add(query_589158, "alt", newJString(alt))
  add(query_589158, "oauth_token", newJString(oauthToken))
  add(query_589158, "userIp", newJString(userIp))
  add(query_589158, "key", newJString(key))
  if body != nil:
    body_589159 = body
  add(query_589158, "prettyPrint", newJBool(prettyPrint))
  add(path_589157, "entity", newJString(entity))
  result = call_589156.call(path_589157, query_589158, nil, nil, body_589159)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_589142(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_589143,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsUpdate_589144,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_589126 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsGet_589128(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsGet_589127(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589129 = path.getOrDefault("bucket")
  valid_589129 = validateParameter(valid_589129, JString, required = true,
                                 default = nil)
  if valid_589129 != nil:
    section.add "bucket", valid_589129
  var valid_589130 = path.getOrDefault("entity")
  valid_589130 = validateParameter(valid_589130, JString, required = true,
                                 default = nil)
  if valid_589130 != nil:
    section.add "entity", valid_589130
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589131 = query.getOrDefault("fields")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "fields", valid_589131
  var valid_589132 = query.getOrDefault("quotaUser")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "quotaUser", valid_589132
  var valid_589133 = query.getOrDefault("alt")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = newJString("json"))
  if valid_589133 != nil:
    section.add "alt", valid_589133
  var valid_589134 = query.getOrDefault("oauth_token")
  valid_589134 = validateParameter(valid_589134, JString, required = false,
                                 default = nil)
  if valid_589134 != nil:
    section.add "oauth_token", valid_589134
  var valid_589135 = query.getOrDefault("userIp")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "userIp", valid_589135
  var valid_589136 = query.getOrDefault("key")
  valid_589136 = validateParameter(valid_589136, JString, required = false,
                                 default = nil)
  if valid_589136 != nil:
    section.add "key", valid_589136
  var valid_589137 = query.getOrDefault("prettyPrint")
  valid_589137 = validateParameter(valid_589137, JBool, required = false,
                                 default = newJBool(true))
  if valid_589137 != nil:
    section.add "prettyPrint", valid_589137
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589138: Call_StorageBucketAccessControlsGet_589126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_589138.validator(path, query, header, formData, body)
  let scheme = call_589138.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589138.url(scheme.get, call_589138.host, call_589138.base,
                         call_589138.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589138, url, valid)

proc call*(call_589139: Call_StorageBucketAccessControlsGet_589126; bucket: string;
          entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageBucketAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  var path_589140 = newJObject()
  var query_589141 = newJObject()
  add(path_589140, "bucket", newJString(bucket))
  add(query_589141, "fields", newJString(fields))
  add(query_589141, "quotaUser", newJString(quotaUser))
  add(query_589141, "alt", newJString(alt))
  add(query_589141, "oauth_token", newJString(oauthToken))
  add(query_589141, "userIp", newJString(userIp))
  add(query_589141, "key", newJString(key))
  add(query_589141, "prettyPrint", newJBool(prettyPrint))
  add(path_589140, "entity", newJString(entity))
  result = call_589139.call(path_589140, query_589141, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_589126(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_589127,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsGet_589128,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_589176 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsPatch_589178(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsPatch_589177(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589179 = path.getOrDefault("bucket")
  valid_589179 = validateParameter(valid_589179, JString, required = true,
                                 default = nil)
  if valid_589179 != nil:
    section.add "bucket", valid_589179
  var valid_589180 = path.getOrDefault("entity")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "entity", valid_589180
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589181 = query.getOrDefault("fields")
  valid_589181 = validateParameter(valid_589181, JString, required = false,
                                 default = nil)
  if valid_589181 != nil:
    section.add "fields", valid_589181
  var valid_589182 = query.getOrDefault("quotaUser")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "quotaUser", valid_589182
  var valid_589183 = query.getOrDefault("alt")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = newJString("json"))
  if valid_589183 != nil:
    section.add "alt", valid_589183
  var valid_589184 = query.getOrDefault("oauth_token")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = nil)
  if valid_589184 != nil:
    section.add "oauth_token", valid_589184
  var valid_589185 = query.getOrDefault("userIp")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "userIp", valid_589185
  var valid_589186 = query.getOrDefault("key")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "key", valid_589186
  var valid_589187 = query.getOrDefault("prettyPrint")
  valid_589187 = validateParameter(valid_589187, JBool, required = false,
                                 default = newJBool(true))
  if valid_589187 != nil:
    section.add "prettyPrint", valid_589187
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

proc call*(call_589189: Call_StorageBucketAccessControlsPatch_589176;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_589189.validator(path, query, header, formData, body)
  let scheme = call_589189.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589189.url(scheme.get, call_589189.host, call_589189.base,
                         call_589189.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589189, url, valid)

proc call*(call_589190: Call_StorageBucketAccessControlsPatch_589176;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageBucketAccessControlsPatch
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  var path_589191 = newJObject()
  var query_589192 = newJObject()
  var body_589193 = newJObject()
  add(path_589191, "bucket", newJString(bucket))
  add(query_589192, "fields", newJString(fields))
  add(query_589192, "quotaUser", newJString(quotaUser))
  add(query_589192, "alt", newJString(alt))
  add(query_589192, "oauth_token", newJString(oauthToken))
  add(query_589192, "userIp", newJString(userIp))
  add(query_589192, "key", newJString(key))
  if body != nil:
    body_589193 = body
  add(query_589192, "prettyPrint", newJBool(prettyPrint))
  add(path_589191, "entity", newJString(entity))
  result = call_589190.call(path_589191, query_589192, nil, nil, body_589193)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_589176(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_589177,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsPatch_589178,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_589160 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsDelete_589162(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketAccessControlsDelete_589161(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589163 = path.getOrDefault("bucket")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "bucket", valid_589163
  var valid_589164 = path.getOrDefault("entity")
  valid_589164 = validateParameter(valid_589164, JString, required = true,
                                 default = nil)
  if valid_589164 != nil:
    section.add "entity", valid_589164
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589165 = query.getOrDefault("fields")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "fields", valid_589165
  var valid_589166 = query.getOrDefault("quotaUser")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = nil)
  if valid_589166 != nil:
    section.add "quotaUser", valid_589166
  var valid_589167 = query.getOrDefault("alt")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = newJString("json"))
  if valid_589167 != nil:
    section.add "alt", valid_589167
  var valid_589168 = query.getOrDefault("oauth_token")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "oauth_token", valid_589168
  var valid_589169 = query.getOrDefault("userIp")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "userIp", valid_589169
  var valid_589170 = query.getOrDefault("key")
  valid_589170 = validateParameter(valid_589170, JString, required = false,
                                 default = nil)
  if valid_589170 != nil:
    section.add "key", valid_589170
  var valid_589171 = query.getOrDefault("prettyPrint")
  valid_589171 = validateParameter(valid_589171, JBool, required = false,
                                 default = newJBool(true))
  if valid_589171 != nil:
    section.add "prettyPrint", valid_589171
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589172: Call_StorageBucketAccessControlsDelete_589160;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_589172.validator(path, query, header, formData, body)
  let scheme = call_589172.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589172.url(scheme.get, call_589172.host, call_589172.base,
                         call_589172.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589172, url, valid)

proc call*(call_589173: Call_StorageBucketAccessControlsDelete_589160;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageBucketAccessControlsDelete
  ## Deletes the ACL entry for the specified entity on the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  var path_589174 = newJObject()
  var query_589175 = newJObject()
  add(path_589174, "bucket", newJString(bucket))
  add(query_589175, "fields", newJString(fields))
  add(query_589175, "quotaUser", newJString(quotaUser))
  add(query_589175, "alt", newJString(alt))
  add(query_589175, "oauth_token", newJString(oauthToken))
  add(query_589175, "userIp", newJString(userIp))
  add(query_589175, "key", newJString(key))
  add(query_589175, "prettyPrint", newJBool(prettyPrint))
  add(path_589174, "entity", newJString(entity))
  result = call_589173.call(path_589174, query_589175, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_589160(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_589161,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsDelete_589162,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_589214 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsInsert_589216(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsInsert_589215(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stores new data blobs and associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589217 = path.getOrDefault("bucket")
  valid_589217 = validateParameter(valid_589217, JString, required = true,
                                 default = nil)
  if valid_589217 != nil:
    section.add "bucket", valid_589217
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl, unless the object resource specifies the acl property, when it defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589218 = query.getOrDefault("fields")
  valid_589218 = validateParameter(valid_589218, JString, required = false,
                                 default = nil)
  if valid_589218 != nil:
    section.add "fields", valid_589218
  var valid_589219 = query.getOrDefault("quotaUser")
  valid_589219 = validateParameter(valid_589219, JString, required = false,
                                 default = nil)
  if valid_589219 != nil:
    section.add "quotaUser", valid_589219
  var valid_589220 = query.getOrDefault("alt")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = newJString("json"))
  if valid_589220 != nil:
    section.add "alt", valid_589220
  var valid_589221 = query.getOrDefault("oauth_token")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "oauth_token", valid_589221
  var valid_589222 = query.getOrDefault("userIp")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = nil)
  if valid_589222 != nil:
    section.add "userIp", valid_589222
  var valid_589223 = query.getOrDefault("key")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "key", valid_589223
  var valid_589224 = query.getOrDefault("name")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "name", valid_589224
  var valid_589225 = query.getOrDefault("projection")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = newJString("full"))
  if valid_589225 != nil:
    section.add "projection", valid_589225
  var valid_589226 = query.getOrDefault("prettyPrint")
  valid_589226 = validateParameter(valid_589226, JBool, required = false,
                                 default = newJBool(true))
  if valid_589226 != nil:
    section.add "prettyPrint", valid_589226
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

proc call*(call_589228: Call_StorageObjectsInsert_589214; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores new data blobs and associated metadata.
  ## 
  let valid = call_589228.validator(path, query, header, formData, body)
  let scheme = call_589228.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589228.url(scheme.get, call_589228.host, call_589228.base,
                         call_589228.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589228, url, valid)

proc call*(call_589229: Call_StorageObjectsInsert_589214; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = ""; name: string = "";
          projection: string = "full"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageObjectsInsert
  ## Stores new data blobs and associated metadata.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl, unless the object resource specifies the acl property, when it defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_589230 = newJObject()
  var query_589231 = newJObject()
  var body_589232 = newJObject()
  add(path_589230, "bucket", newJString(bucket))
  add(query_589231, "fields", newJString(fields))
  add(query_589231, "quotaUser", newJString(quotaUser))
  add(query_589231, "alt", newJString(alt))
  add(query_589231, "oauth_token", newJString(oauthToken))
  add(query_589231, "userIp", newJString(userIp))
  add(query_589231, "key", newJString(key))
  add(query_589231, "name", newJString(name))
  add(query_589231, "projection", newJString(projection))
  if body != nil:
    body_589232 = body
  add(query_589231, "prettyPrint", newJBool(prettyPrint))
  result = call_589229.call(path_589230, query_589231, nil, nil, body_589232)

var storageObjectsInsert* = Call_StorageObjectsInsert_589214(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_589215, base: "/storage/v1beta1",
    url: url_StorageObjectsInsert_589216, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_589194 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsList_589196(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsList_589195(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Retrieves a list of objects matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589197 = path.getOrDefault("bucket")
  valid_589197 = validateParameter(valid_589197, JString, required = true,
                                 default = nil)
  if valid_589197 != nil:
    section.add "bucket", valid_589197
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   max-results: JInt
  ##              : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  section = newJObject()
  var valid_589198 = query.getOrDefault("fields")
  valid_589198 = validateParameter(valid_589198, JString, required = false,
                                 default = nil)
  if valid_589198 != nil:
    section.add "fields", valid_589198
  var valid_589199 = query.getOrDefault("pageToken")
  valid_589199 = validateParameter(valid_589199, JString, required = false,
                                 default = nil)
  if valid_589199 != nil:
    section.add "pageToken", valid_589199
  var valid_589200 = query.getOrDefault("quotaUser")
  valid_589200 = validateParameter(valid_589200, JString, required = false,
                                 default = nil)
  if valid_589200 != nil:
    section.add "quotaUser", valid_589200
  var valid_589201 = query.getOrDefault("alt")
  valid_589201 = validateParameter(valid_589201, JString, required = false,
                                 default = newJString("json"))
  if valid_589201 != nil:
    section.add "alt", valid_589201
  var valid_589202 = query.getOrDefault("oauth_token")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "oauth_token", valid_589202
  var valid_589203 = query.getOrDefault("userIp")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "userIp", valid_589203
  var valid_589204 = query.getOrDefault("key")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = nil)
  if valid_589204 != nil:
    section.add "key", valid_589204
  var valid_589205 = query.getOrDefault("max-results")
  valid_589205 = validateParameter(valid_589205, JInt, required = false, default = nil)
  if valid_589205 != nil:
    section.add "max-results", valid_589205
  var valid_589206 = query.getOrDefault("projection")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = newJString("full"))
  if valid_589206 != nil:
    section.add "projection", valid_589206
  var valid_589207 = query.getOrDefault("delimiter")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "delimiter", valid_589207
  var valid_589208 = query.getOrDefault("prettyPrint")
  valid_589208 = validateParameter(valid_589208, JBool, required = false,
                                 default = newJBool(true))
  if valid_589208 != nil:
    section.add "prettyPrint", valid_589208
  var valid_589209 = query.getOrDefault("prefix")
  valid_589209 = validateParameter(valid_589209, JString, required = false,
                                 default = nil)
  if valid_589209 != nil:
    section.add "prefix", valid_589209
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589210: Call_StorageObjectsList_589194; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_589210.validator(path, query, header, formData, body)
  let scheme = call_589210.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589210.url(scheme.get, call_589210.host, call_589210.base,
                         call_589210.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589210, url, valid)

proc call*(call_589211: Call_StorageObjectsList_589194; bucket: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; maxResults: int = 0; projection: string = "full";
          delimiter: string = ""; prettyPrint: bool = true; prefix: string = ""): Recallable =
  ## storageObjectsList
  ## Retrieves a list of objects matching the criteria.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to look for objects.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: string
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  var path_589212 = newJObject()
  var query_589213 = newJObject()
  add(path_589212, "bucket", newJString(bucket))
  add(query_589213, "fields", newJString(fields))
  add(query_589213, "pageToken", newJString(pageToken))
  add(query_589213, "quotaUser", newJString(quotaUser))
  add(query_589213, "alt", newJString(alt))
  add(query_589213, "oauth_token", newJString(oauthToken))
  add(query_589213, "userIp", newJString(userIp))
  add(query_589213, "key", newJString(key))
  add(query_589213, "max-results", newJInt(maxResults))
  add(query_589213, "projection", newJString(projection))
  add(query_589213, "delimiter", newJString(delimiter))
  add(query_589213, "prettyPrint", newJBool(prettyPrint))
  add(query_589213, "prefix", newJString(prefix))
  result = call_589211.call(path_589212, query_589213, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_589194(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_589195, base: "/storage/v1beta1",
    url: url_StorageObjectsList_589196, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_589250 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsUpdate_589252(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsUpdate_589251(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a data blob's associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589253 = path.getOrDefault("bucket")
  valid_589253 = validateParameter(valid_589253, JString, required = true,
                                 default = nil)
  if valid_589253 != nil:
    section.add "bucket", valid_589253
  var valid_589254 = path.getOrDefault("object")
  valid_589254 = validateParameter(valid_589254, JString, required = true,
                                 default = nil)
  if valid_589254 != nil:
    section.add "object", valid_589254
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589255 = query.getOrDefault("fields")
  valid_589255 = validateParameter(valid_589255, JString, required = false,
                                 default = nil)
  if valid_589255 != nil:
    section.add "fields", valid_589255
  var valid_589256 = query.getOrDefault("quotaUser")
  valid_589256 = validateParameter(valid_589256, JString, required = false,
                                 default = nil)
  if valid_589256 != nil:
    section.add "quotaUser", valid_589256
  var valid_589257 = query.getOrDefault("alt")
  valid_589257 = validateParameter(valid_589257, JString, required = false,
                                 default = newJString("json"))
  if valid_589257 != nil:
    section.add "alt", valid_589257
  var valid_589258 = query.getOrDefault("oauth_token")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "oauth_token", valid_589258
  var valid_589259 = query.getOrDefault("userIp")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "userIp", valid_589259
  var valid_589260 = query.getOrDefault("key")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = nil)
  if valid_589260 != nil:
    section.add "key", valid_589260
  var valid_589261 = query.getOrDefault("projection")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = newJString("full"))
  if valid_589261 != nil:
    section.add "projection", valid_589261
  var valid_589262 = query.getOrDefault("prettyPrint")
  valid_589262 = validateParameter(valid_589262, JBool, required = false,
                                 default = newJBool(true))
  if valid_589262 != nil:
    section.add "prettyPrint", valid_589262
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

proc call*(call_589264: Call_StorageObjectsUpdate_589250; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata.
  ## 
  let valid = call_589264.validator(path, query, header, formData, body)
  let scheme = call_589264.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589264.url(scheme.get, call_589264.host, call_589264.base,
                         call_589264.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589264, url, valid)

proc call*(call_589265: Call_StorageObjectsUpdate_589250; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; projection: string = "full"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storageObjectsUpdate
  ## Updates a data blob's associated metadata.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589266 = newJObject()
  var query_589267 = newJObject()
  var body_589268 = newJObject()
  add(path_589266, "bucket", newJString(bucket))
  add(query_589267, "fields", newJString(fields))
  add(query_589267, "quotaUser", newJString(quotaUser))
  add(query_589267, "alt", newJString(alt))
  add(query_589267, "oauth_token", newJString(oauthToken))
  add(query_589267, "userIp", newJString(userIp))
  add(query_589267, "key", newJString(key))
  add(query_589267, "projection", newJString(projection))
  if body != nil:
    body_589268 = body
  add(query_589267, "prettyPrint", newJBool(prettyPrint))
  add(path_589266, "object", newJString(`object`))
  result = call_589265.call(path_589266, query_589267, nil, nil, body_589268)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_589250(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_589251, base: "/storage/v1beta1",
    url: url_StorageObjectsUpdate_589252, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_589233 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsGet_589235(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsGet_589234(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves objects or their associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589236 = path.getOrDefault("bucket")
  valid_589236 = validateParameter(valid_589236, JString, required = true,
                                 default = nil)
  if valid_589236 != nil:
    section.add "bucket", valid_589236
  var valid_589237 = path.getOrDefault("object")
  valid_589237 = validateParameter(valid_589237, JString, required = true,
                                 default = nil)
  if valid_589237 != nil:
    section.add "object", valid_589237
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to no_acl.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589238 = query.getOrDefault("fields")
  valid_589238 = validateParameter(valid_589238, JString, required = false,
                                 default = nil)
  if valid_589238 != nil:
    section.add "fields", valid_589238
  var valid_589239 = query.getOrDefault("quotaUser")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "quotaUser", valid_589239
  var valid_589240 = query.getOrDefault("alt")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = newJString("json"))
  if valid_589240 != nil:
    section.add "alt", valid_589240
  var valid_589241 = query.getOrDefault("oauth_token")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = nil)
  if valid_589241 != nil:
    section.add "oauth_token", valid_589241
  var valid_589242 = query.getOrDefault("userIp")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "userIp", valid_589242
  var valid_589243 = query.getOrDefault("key")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "key", valid_589243
  var valid_589244 = query.getOrDefault("projection")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = newJString("full"))
  if valid_589244 != nil:
    section.add "projection", valid_589244
  var valid_589245 = query.getOrDefault("prettyPrint")
  valid_589245 = validateParameter(valid_589245, JBool, required = false,
                                 default = newJBool(true))
  if valid_589245 != nil:
    section.add "prettyPrint", valid_589245
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589246: Call_StorageObjectsGet_589233; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves objects or their associated metadata.
  ## 
  let valid = call_589246.validator(path, query, header, formData, body)
  let scheme = call_589246.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589246.url(scheme.get, call_589246.host, call_589246.base,
                         call_589246.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589246, url, valid)

proc call*(call_589247: Call_StorageObjectsGet_589233; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; projection: string = "full"; prettyPrint: bool = true): Recallable =
  ## storageObjectsGet
  ## Retrieves objects or their associated metadata.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to no_acl.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589248 = newJObject()
  var query_589249 = newJObject()
  add(path_589248, "bucket", newJString(bucket))
  add(query_589249, "fields", newJString(fields))
  add(query_589249, "quotaUser", newJString(quotaUser))
  add(query_589249, "alt", newJString(alt))
  add(query_589249, "oauth_token", newJString(oauthToken))
  add(query_589249, "userIp", newJString(userIp))
  add(query_589249, "key", newJString(key))
  add(query_589249, "projection", newJString(projection))
  add(query_589249, "prettyPrint", newJBool(prettyPrint))
  add(path_589248, "object", newJString(`object`))
  result = call_589247.call(path_589248, query_589249, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_589233(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_589234,
    base: "/storage/v1beta1", url: url_StorageObjectsGet_589235,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_589285 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsPatch_589287(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsPatch_589286(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589288 = path.getOrDefault("bucket")
  valid_589288 = validateParameter(valid_589288, JString, required = true,
                                 default = nil)
  if valid_589288 != nil:
    section.add "bucket", valid_589288
  var valid_589289 = path.getOrDefault("object")
  valid_589289 = validateParameter(valid_589289, JString, required = true,
                                 default = nil)
  if valid_589289 != nil:
    section.add "object", valid_589289
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589290 = query.getOrDefault("fields")
  valid_589290 = validateParameter(valid_589290, JString, required = false,
                                 default = nil)
  if valid_589290 != nil:
    section.add "fields", valid_589290
  var valid_589291 = query.getOrDefault("quotaUser")
  valid_589291 = validateParameter(valid_589291, JString, required = false,
                                 default = nil)
  if valid_589291 != nil:
    section.add "quotaUser", valid_589291
  var valid_589292 = query.getOrDefault("alt")
  valid_589292 = validateParameter(valid_589292, JString, required = false,
                                 default = newJString("json"))
  if valid_589292 != nil:
    section.add "alt", valid_589292
  var valid_589293 = query.getOrDefault("oauth_token")
  valid_589293 = validateParameter(valid_589293, JString, required = false,
                                 default = nil)
  if valid_589293 != nil:
    section.add "oauth_token", valid_589293
  var valid_589294 = query.getOrDefault("userIp")
  valid_589294 = validateParameter(valid_589294, JString, required = false,
                                 default = nil)
  if valid_589294 != nil:
    section.add "userIp", valid_589294
  var valid_589295 = query.getOrDefault("key")
  valid_589295 = validateParameter(valid_589295, JString, required = false,
                                 default = nil)
  if valid_589295 != nil:
    section.add "key", valid_589295
  var valid_589296 = query.getOrDefault("projection")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = newJString("full"))
  if valid_589296 != nil:
    section.add "projection", valid_589296
  var valid_589297 = query.getOrDefault("prettyPrint")
  valid_589297 = validateParameter(valid_589297, JBool, required = false,
                                 default = newJBool(true))
  if valid_589297 != nil:
    section.add "prettyPrint", valid_589297
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

proc call*(call_589299: Call_StorageObjectsPatch_589285; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  let valid = call_589299.validator(path, query, header, formData, body)
  let scheme = call_589299.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589299.url(scheme.get, call_589299.host, call_589299.base,
                         call_589299.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589299, url, valid)

proc call*(call_589300: Call_StorageObjectsPatch_589285; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; projection: string = "full"; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storageObjectsPatch
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589301 = newJObject()
  var query_589302 = newJObject()
  var body_589303 = newJObject()
  add(path_589301, "bucket", newJString(bucket))
  add(query_589302, "fields", newJString(fields))
  add(query_589302, "quotaUser", newJString(quotaUser))
  add(query_589302, "alt", newJString(alt))
  add(query_589302, "oauth_token", newJString(oauthToken))
  add(query_589302, "userIp", newJString(userIp))
  add(query_589302, "key", newJString(key))
  add(query_589302, "projection", newJString(projection))
  if body != nil:
    body_589303 = body
  add(query_589302, "prettyPrint", newJBool(prettyPrint))
  add(path_589301, "object", newJString(`object`))
  result = call_589300.call(path_589301, query_589302, nil, nil, body_589303)

var storageObjectsPatch* = Call_StorageObjectsPatch_589285(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_589286, base: "/storage/v1beta1",
    url: url_StorageObjectsPatch_589287, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_589269 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsDelete_589271(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsDelete_589270(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes data blobs and associated metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589272 = path.getOrDefault("bucket")
  valid_589272 = validateParameter(valid_589272, JString, required = true,
                                 default = nil)
  if valid_589272 != nil:
    section.add "bucket", valid_589272
  var valid_589273 = path.getOrDefault("object")
  valid_589273 = validateParameter(valid_589273, JString, required = true,
                                 default = nil)
  if valid_589273 != nil:
    section.add "object", valid_589273
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589274 = query.getOrDefault("fields")
  valid_589274 = validateParameter(valid_589274, JString, required = false,
                                 default = nil)
  if valid_589274 != nil:
    section.add "fields", valid_589274
  var valid_589275 = query.getOrDefault("quotaUser")
  valid_589275 = validateParameter(valid_589275, JString, required = false,
                                 default = nil)
  if valid_589275 != nil:
    section.add "quotaUser", valid_589275
  var valid_589276 = query.getOrDefault("alt")
  valid_589276 = validateParameter(valid_589276, JString, required = false,
                                 default = newJString("json"))
  if valid_589276 != nil:
    section.add "alt", valid_589276
  var valid_589277 = query.getOrDefault("oauth_token")
  valid_589277 = validateParameter(valid_589277, JString, required = false,
                                 default = nil)
  if valid_589277 != nil:
    section.add "oauth_token", valid_589277
  var valid_589278 = query.getOrDefault("userIp")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "userIp", valid_589278
  var valid_589279 = query.getOrDefault("key")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "key", valid_589279
  var valid_589280 = query.getOrDefault("prettyPrint")
  valid_589280 = validateParameter(valid_589280, JBool, required = false,
                                 default = newJBool(true))
  if valid_589280 != nil:
    section.add "prettyPrint", valid_589280
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589281: Call_StorageObjectsDelete_589269; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes data blobs and associated metadata.
  ## 
  let valid = call_589281.validator(path, query, header, formData, body)
  let scheme = call_589281.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589281.url(scheme.get, call_589281.host, call_589281.base,
                         call_589281.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589281, url, valid)

proc call*(call_589282: Call_StorageObjectsDelete_589269; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageObjectsDelete
  ## Deletes data blobs and associated metadata.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589283 = newJObject()
  var query_589284 = newJObject()
  add(path_589283, "bucket", newJString(bucket))
  add(query_589284, "fields", newJString(fields))
  add(query_589284, "quotaUser", newJString(quotaUser))
  add(query_589284, "alt", newJString(alt))
  add(query_589284, "oauth_token", newJString(oauthToken))
  add(query_589284, "userIp", newJString(userIp))
  add(query_589284, "key", newJString(key))
  add(query_589284, "prettyPrint", newJBool(prettyPrint))
  add(path_589283, "object", newJString(`object`))
  result = call_589282.call(path_589283, query_589284, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_589269(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_589270, base: "/storage/v1beta1",
    url: url_StorageObjectsDelete_589271, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_589320 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsInsert_589322(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsInsert_589321(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589323 = path.getOrDefault("bucket")
  valid_589323 = validateParameter(valid_589323, JString, required = true,
                                 default = nil)
  if valid_589323 != nil:
    section.add "bucket", valid_589323
  var valid_589324 = path.getOrDefault("object")
  valid_589324 = validateParameter(valid_589324, JString, required = true,
                                 default = nil)
  if valid_589324 != nil:
    section.add "object", valid_589324
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589325 = query.getOrDefault("fields")
  valid_589325 = validateParameter(valid_589325, JString, required = false,
                                 default = nil)
  if valid_589325 != nil:
    section.add "fields", valid_589325
  var valid_589326 = query.getOrDefault("quotaUser")
  valid_589326 = validateParameter(valid_589326, JString, required = false,
                                 default = nil)
  if valid_589326 != nil:
    section.add "quotaUser", valid_589326
  var valid_589327 = query.getOrDefault("alt")
  valid_589327 = validateParameter(valid_589327, JString, required = false,
                                 default = newJString("json"))
  if valid_589327 != nil:
    section.add "alt", valid_589327
  var valid_589328 = query.getOrDefault("oauth_token")
  valid_589328 = validateParameter(valid_589328, JString, required = false,
                                 default = nil)
  if valid_589328 != nil:
    section.add "oauth_token", valid_589328
  var valid_589329 = query.getOrDefault("userIp")
  valid_589329 = validateParameter(valid_589329, JString, required = false,
                                 default = nil)
  if valid_589329 != nil:
    section.add "userIp", valid_589329
  var valid_589330 = query.getOrDefault("key")
  valid_589330 = validateParameter(valid_589330, JString, required = false,
                                 default = nil)
  if valid_589330 != nil:
    section.add "key", valid_589330
  var valid_589331 = query.getOrDefault("prettyPrint")
  valid_589331 = validateParameter(valid_589331, JBool, required = false,
                                 default = newJBool(true))
  if valid_589331 != nil:
    section.add "prettyPrint", valid_589331
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

proc call*(call_589333: Call_StorageObjectAccessControlsInsert_589320;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_589333.validator(path, query, header, formData, body)
  let scheme = call_589333.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589333.url(scheme.get, call_589333.host, call_589333.base,
                         call_589333.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589333, url, valid)

proc call*(call_589334: Call_StorageObjectAccessControlsInsert_589320;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageObjectAccessControlsInsert
  ## Creates a new ACL entry on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589335 = newJObject()
  var query_589336 = newJObject()
  var body_589337 = newJObject()
  add(path_589335, "bucket", newJString(bucket))
  add(query_589336, "fields", newJString(fields))
  add(query_589336, "quotaUser", newJString(quotaUser))
  add(query_589336, "alt", newJString(alt))
  add(query_589336, "oauth_token", newJString(oauthToken))
  add(query_589336, "userIp", newJString(userIp))
  add(query_589336, "key", newJString(key))
  if body != nil:
    body_589337 = body
  add(query_589336, "prettyPrint", newJBool(prettyPrint))
  add(path_589335, "object", newJString(`object`))
  result = call_589334.call(path_589335, query_589336, nil, nil, body_589337)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_589320(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_589321,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsInsert_589322,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_589304 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsList_589306(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsList_589305(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589307 = path.getOrDefault("bucket")
  valid_589307 = validateParameter(valid_589307, JString, required = true,
                                 default = nil)
  if valid_589307 != nil:
    section.add "bucket", valid_589307
  var valid_589308 = path.getOrDefault("object")
  valid_589308 = validateParameter(valid_589308, JString, required = true,
                                 default = nil)
  if valid_589308 != nil:
    section.add "object", valid_589308
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589309 = query.getOrDefault("fields")
  valid_589309 = validateParameter(valid_589309, JString, required = false,
                                 default = nil)
  if valid_589309 != nil:
    section.add "fields", valid_589309
  var valid_589310 = query.getOrDefault("quotaUser")
  valid_589310 = validateParameter(valid_589310, JString, required = false,
                                 default = nil)
  if valid_589310 != nil:
    section.add "quotaUser", valid_589310
  var valid_589311 = query.getOrDefault("alt")
  valid_589311 = validateParameter(valid_589311, JString, required = false,
                                 default = newJString("json"))
  if valid_589311 != nil:
    section.add "alt", valid_589311
  var valid_589312 = query.getOrDefault("oauth_token")
  valid_589312 = validateParameter(valid_589312, JString, required = false,
                                 default = nil)
  if valid_589312 != nil:
    section.add "oauth_token", valid_589312
  var valid_589313 = query.getOrDefault("userIp")
  valid_589313 = validateParameter(valid_589313, JString, required = false,
                                 default = nil)
  if valid_589313 != nil:
    section.add "userIp", valid_589313
  var valid_589314 = query.getOrDefault("key")
  valid_589314 = validateParameter(valid_589314, JString, required = false,
                                 default = nil)
  if valid_589314 != nil:
    section.add "key", valid_589314
  var valid_589315 = query.getOrDefault("prettyPrint")
  valid_589315 = validateParameter(valid_589315, JBool, required = false,
                                 default = newJBool(true))
  if valid_589315 != nil:
    section.add "prettyPrint", valid_589315
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589316: Call_StorageObjectAccessControlsList_589304;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_589316.validator(path, query, header, formData, body)
  let scheme = call_589316.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589316.url(scheme.get, call_589316.host, call_589316.base,
                         call_589316.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589316, url, valid)

proc call*(call_589317: Call_StorageObjectAccessControlsList_589304;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageObjectAccessControlsList
  ## Retrieves ACL entries on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589318 = newJObject()
  var query_589319 = newJObject()
  add(path_589318, "bucket", newJString(bucket))
  add(query_589319, "fields", newJString(fields))
  add(query_589319, "quotaUser", newJString(quotaUser))
  add(query_589319, "alt", newJString(alt))
  add(query_589319, "oauth_token", newJString(oauthToken))
  add(query_589319, "userIp", newJString(userIp))
  add(query_589319, "key", newJString(key))
  add(query_589319, "prettyPrint", newJBool(prettyPrint))
  add(path_589318, "object", newJString(`object`))
  result = call_589317.call(path_589318, query_589319, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_589304(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_589305,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsList_589306,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_589355 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsUpdate_589357(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsUpdate_589356(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589358 = path.getOrDefault("bucket")
  valid_589358 = validateParameter(valid_589358, JString, required = true,
                                 default = nil)
  if valid_589358 != nil:
    section.add "bucket", valid_589358
  var valid_589359 = path.getOrDefault("entity")
  valid_589359 = validateParameter(valid_589359, JString, required = true,
                                 default = nil)
  if valid_589359 != nil:
    section.add "entity", valid_589359
  var valid_589360 = path.getOrDefault("object")
  valid_589360 = validateParameter(valid_589360, JString, required = true,
                                 default = nil)
  if valid_589360 != nil:
    section.add "object", valid_589360
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589361 = query.getOrDefault("fields")
  valid_589361 = validateParameter(valid_589361, JString, required = false,
                                 default = nil)
  if valid_589361 != nil:
    section.add "fields", valid_589361
  var valid_589362 = query.getOrDefault("quotaUser")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "quotaUser", valid_589362
  var valid_589363 = query.getOrDefault("alt")
  valid_589363 = validateParameter(valid_589363, JString, required = false,
                                 default = newJString("json"))
  if valid_589363 != nil:
    section.add "alt", valid_589363
  var valid_589364 = query.getOrDefault("oauth_token")
  valid_589364 = validateParameter(valid_589364, JString, required = false,
                                 default = nil)
  if valid_589364 != nil:
    section.add "oauth_token", valid_589364
  var valid_589365 = query.getOrDefault("userIp")
  valid_589365 = validateParameter(valid_589365, JString, required = false,
                                 default = nil)
  if valid_589365 != nil:
    section.add "userIp", valid_589365
  var valid_589366 = query.getOrDefault("key")
  valid_589366 = validateParameter(valid_589366, JString, required = false,
                                 default = nil)
  if valid_589366 != nil:
    section.add "key", valid_589366
  var valid_589367 = query.getOrDefault("prettyPrint")
  valid_589367 = validateParameter(valid_589367, JBool, required = false,
                                 default = newJBool(true))
  if valid_589367 != nil:
    section.add "prettyPrint", valid_589367
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

proc call*(call_589369: Call_StorageObjectAccessControlsUpdate_589355;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_589369.validator(path, query, header, formData, body)
  let scheme = call_589369.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589369.url(scheme.get, call_589369.host, call_589369.base,
                         call_589369.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589369, url, valid)

proc call*(call_589370: Call_StorageObjectAccessControlsUpdate_589355;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storageObjectAccessControlsUpdate
  ## Updates an ACL entry on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589371 = newJObject()
  var query_589372 = newJObject()
  var body_589373 = newJObject()
  add(path_589371, "bucket", newJString(bucket))
  add(query_589372, "fields", newJString(fields))
  add(query_589372, "quotaUser", newJString(quotaUser))
  add(query_589372, "alt", newJString(alt))
  add(query_589372, "oauth_token", newJString(oauthToken))
  add(query_589372, "userIp", newJString(userIp))
  add(query_589372, "key", newJString(key))
  if body != nil:
    body_589373 = body
  add(query_589372, "prettyPrint", newJBool(prettyPrint))
  add(path_589371, "entity", newJString(entity))
  add(path_589371, "object", newJString(`object`))
  result = call_589370.call(path_589371, query_589372, nil, nil, body_589373)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_589355(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_589356,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsUpdate_589357,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_589338 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsGet_589340(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsGet_589339(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589341 = path.getOrDefault("bucket")
  valid_589341 = validateParameter(valid_589341, JString, required = true,
                                 default = nil)
  if valid_589341 != nil:
    section.add "bucket", valid_589341
  var valid_589342 = path.getOrDefault("entity")
  valid_589342 = validateParameter(valid_589342, JString, required = true,
                                 default = nil)
  if valid_589342 != nil:
    section.add "entity", valid_589342
  var valid_589343 = path.getOrDefault("object")
  valid_589343 = validateParameter(valid_589343, JString, required = true,
                                 default = nil)
  if valid_589343 != nil:
    section.add "object", valid_589343
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589344 = query.getOrDefault("fields")
  valid_589344 = validateParameter(valid_589344, JString, required = false,
                                 default = nil)
  if valid_589344 != nil:
    section.add "fields", valid_589344
  var valid_589345 = query.getOrDefault("quotaUser")
  valid_589345 = validateParameter(valid_589345, JString, required = false,
                                 default = nil)
  if valid_589345 != nil:
    section.add "quotaUser", valid_589345
  var valid_589346 = query.getOrDefault("alt")
  valid_589346 = validateParameter(valid_589346, JString, required = false,
                                 default = newJString("json"))
  if valid_589346 != nil:
    section.add "alt", valid_589346
  var valid_589347 = query.getOrDefault("oauth_token")
  valid_589347 = validateParameter(valid_589347, JString, required = false,
                                 default = nil)
  if valid_589347 != nil:
    section.add "oauth_token", valid_589347
  var valid_589348 = query.getOrDefault("userIp")
  valid_589348 = validateParameter(valid_589348, JString, required = false,
                                 default = nil)
  if valid_589348 != nil:
    section.add "userIp", valid_589348
  var valid_589349 = query.getOrDefault("key")
  valid_589349 = validateParameter(valid_589349, JString, required = false,
                                 default = nil)
  if valid_589349 != nil:
    section.add "key", valid_589349
  var valid_589350 = query.getOrDefault("prettyPrint")
  valid_589350 = validateParameter(valid_589350, JBool, required = false,
                                 default = newJBool(true))
  if valid_589350 != nil:
    section.add "prettyPrint", valid_589350
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589351: Call_StorageObjectAccessControlsGet_589338; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_589351.validator(path, query, header, formData, body)
  let scheme = call_589351.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589351.url(scheme.get, call_589351.host, call_589351.base,
                         call_589351.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589351, url, valid)

proc call*(call_589352: Call_StorageObjectAccessControlsGet_589338; bucket: string;
          entity: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageObjectAccessControlsGet
  ## Returns the ACL entry for the specified entity on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589353 = newJObject()
  var query_589354 = newJObject()
  add(path_589353, "bucket", newJString(bucket))
  add(query_589354, "fields", newJString(fields))
  add(query_589354, "quotaUser", newJString(quotaUser))
  add(query_589354, "alt", newJString(alt))
  add(query_589354, "oauth_token", newJString(oauthToken))
  add(query_589354, "userIp", newJString(userIp))
  add(query_589354, "key", newJString(key))
  add(query_589354, "prettyPrint", newJBool(prettyPrint))
  add(path_589353, "entity", newJString(entity))
  add(path_589353, "object", newJString(`object`))
  result = call_589352.call(path_589353, query_589354, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_589338(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_589339,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsGet_589340,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_589391 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsPatch_589393(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsPatch_589392(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589394 = path.getOrDefault("bucket")
  valid_589394 = validateParameter(valid_589394, JString, required = true,
                                 default = nil)
  if valid_589394 != nil:
    section.add "bucket", valid_589394
  var valid_589395 = path.getOrDefault("entity")
  valid_589395 = validateParameter(valid_589395, JString, required = true,
                                 default = nil)
  if valid_589395 != nil:
    section.add "entity", valid_589395
  var valid_589396 = path.getOrDefault("object")
  valid_589396 = validateParameter(valid_589396, JString, required = true,
                                 default = nil)
  if valid_589396 != nil:
    section.add "object", valid_589396
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589397 = query.getOrDefault("fields")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "fields", valid_589397
  var valid_589398 = query.getOrDefault("quotaUser")
  valid_589398 = validateParameter(valid_589398, JString, required = false,
                                 default = nil)
  if valid_589398 != nil:
    section.add "quotaUser", valid_589398
  var valid_589399 = query.getOrDefault("alt")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = newJString("json"))
  if valid_589399 != nil:
    section.add "alt", valid_589399
  var valid_589400 = query.getOrDefault("oauth_token")
  valid_589400 = validateParameter(valid_589400, JString, required = false,
                                 default = nil)
  if valid_589400 != nil:
    section.add "oauth_token", valid_589400
  var valid_589401 = query.getOrDefault("userIp")
  valid_589401 = validateParameter(valid_589401, JString, required = false,
                                 default = nil)
  if valid_589401 != nil:
    section.add "userIp", valid_589401
  var valid_589402 = query.getOrDefault("key")
  valid_589402 = validateParameter(valid_589402, JString, required = false,
                                 default = nil)
  if valid_589402 != nil:
    section.add "key", valid_589402
  var valid_589403 = query.getOrDefault("prettyPrint")
  valid_589403 = validateParameter(valid_589403, JBool, required = false,
                                 default = newJBool(true))
  if valid_589403 != nil:
    section.add "prettyPrint", valid_589403
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

proc call*(call_589405: Call_StorageObjectAccessControlsPatch_589391;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  let valid = call_589405.validator(path, query, header, formData, body)
  let scheme = call_589405.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589405.url(scheme.get, call_589405.host, call_589405.base,
                         call_589405.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589405, url, valid)

proc call*(call_589406: Call_StorageObjectAccessControlsPatch_589391;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storageObjectAccessControlsPatch
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589407 = newJObject()
  var query_589408 = newJObject()
  var body_589409 = newJObject()
  add(path_589407, "bucket", newJString(bucket))
  add(query_589408, "fields", newJString(fields))
  add(query_589408, "quotaUser", newJString(quotaUser))
  add(query_589408, "alt", newJString(alt))
  add(query_589408, "oauth_token", newJString(oauthToken))
  add(query_589408, "userIp", newJString(userIp))
  add(query_589408, "key", newJString(key))
  if body != nil:
    body_589409 = body
  add(query_589408, "prettyPrint", newJBool(prettyPrint))
  add(path_589407, "entity", newJString(entity))
  add(path_589407, "object", newJString(`object`))
  result = call_589406.call(path_589407, query_589408, nil, nil, body_589409)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_589391(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_589392,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsPatch_589393,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_589374 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsDelete_589376(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "object" in path, "`object` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "object"),
               (kind: ConstantSegment, value: "/acl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectAccessControlsDelete_589375(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes the ACL entry for the specified entity on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_589377 = path.getOrDefault("bucket")
  valid_589377 = validateParameter(valid_589377, JString, required = true,
                                 default = nil)
  if valid_589377 != nil:
    section.add "bucket", valid_589377
  var valid_589378 = path.getOrDefault("entity")
  valid_589378 = validateParameter(valid_589378, JString, required = true,
                                 default = nil)
  if valid_589378 != nil:
    section.add "entity", valid_589378
  var valid_589379 = path.getOrDefault("object")
  valid_589379 = validateParameter(valid_589379, JString, required = true,
                                 default = nil)
  if valid_589379 != nil:
    section.add "object", valid_589379
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_589380 = query.getOrDefault("fields")
  valid_589380 = validateParameter(valid_589380, JString, required = false,
                                 default = nil)
  if valid_589380 != nil:
    section.add "fields", valid_589380
  var valid_589381 = query.getOrDefault("quotaUser")
  valid_589381 = validateParameter(valid_589381, JString, required = false,
                                 default = nil)
  if valid_589381 != nil:
    section.add "quotaUser", valid_589381
  var valid_589382 = query.getOrDefault("alt")
  valid_589382 = validateParameter(valid_589382, JString, required = false,
                                 default = newJString("json"))
  if valid_589382 != nil:
    section.add "alt", valid_589382
  var valid_589383 = query.getOrDefault("oauth_token")
  valid_589383 = validateParameter(valid_589383, JString, required = false,
                                 default = nil)
  if valid_589383 != nil:
    section.add "oauth_token", valid_589383
  var valid_589384 = query.getOrDefault("userIp")
  valid_589384 = validateParameter(valid_589384, JString, required = false,
                                 default = nil)
  if valid_589384 != nil:
    section.add "userIp", valid_589384
  var valid_589385 = query.getOrDefault("key")
  valid_589385 = validateParameter(valid_589385, JString, required = false,
                                 default = nil)
  if valid_589385 != nil:
    section.add "key", valid_589385
  var valid_589386 = query.getOrDefault("prettyPrint")
  valid_589386 = validateParameter(valid_589386, JBool, required = false,
                                 default = newJBool(true))
  if valid_589386 != nil:
    section.add "prettyPrint", valid_589386
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589387: Call_StorageObjectAccessControlsDelete_589374;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_589387.validator(path, query, header, formData, body)
  let scheme = call_589387.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589387.url(scheme.get, call_589387.host, call_589387.base,
                         call_589387.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589387, url, valid)

proc call*(call_589388: Call_StorageObjectAccessControlsDelete_589374;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageObjectAccessControlsDelete
  ## Deletes the ACL entry for the specified entity on the specified object.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_589389 = newJObject()
  var query_589390 = newJObject()
  add(path_589389, "bucket", newJString(bucket))
  add(query_589390, "fields", newJString(fields))
  add(query_589390, "quotaUser", newJString(quotaUser))
  add(query_589390, "alt", newJString(alt))
  add(query_589390, "oauth_token", newJString(oauthToken))
  add(query_589390, "userIp", newJString(userIp))
  add(query_589390, "key", newJString(key))
  add(query_589390, "prettyPrint", newJBool(prettyPrint))
  add(path_589389, "entity", newJString(entity))
  add(path_589389, "object", newJString(`object`))
  result = call_589388.call(path_589389, query_589390, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_589374(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_589375,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsDelete_589376,
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
