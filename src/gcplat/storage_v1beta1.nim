
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

  OpenApiRestCall_579424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_579424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_579424): Option[Scheme] {.used.} =
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
  gcpServiceName = "storage"
proc composeQueryString(query: JsonNode): string
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageBucketsInsert_579964 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsInsert_579966(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_579965(path: JsonNode; query: JsonNode;
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
  var valid_579967 = query.getOrDefault("fields")
  valid_579967 = validateParameter(valid_579967, JString, required = false,
                                 default = nil)
  if valid_579967 != nil:
    section.add "fields", valid_579967
  var valid_579968 = query.getOrDefault("quotaUser")
  valid_579968 = validateParameter(valid_579968, JString, required = false,
                                 default = nil)
  if valid_579968 != nil:
    section.add "quotaUser", valid_579968
  var valid_579969 = query.getOrDefault("alt")
  valid_579969 = validateParameter(valid_579969, JString, required = false,
                                 default = newJString("json"))
  if valid_579969 != nil:
    section.add "alt", valid_579969
  var valid_579970 = query.getOrDefault("oauth_token")
  valid_579970 = validateParameter(valid_579970, JString, required = false,
                                 default = nil)
  if valid_579970 != nil:
    section.add "oauth_token", valid_579970
  var valid_579971 = query.getOrDefault("userIp")
  valid_579971 = validateParameter(valid_579971, JString, required = false,
                                 default = nil)
  if valid_579971 != nil:
    section.add "userIp", valid_579971
  var valid_579972 = query.getOrDefault("key")
  valid_579972 = validateParameter(valid_579972, JString, required = false,
                                 default = nil)
  if valid_579972 != nil:
    section.add "key", valid_579972
  var valid_579973 = query.getOrDefault("projection")
  valid_579973 = validateParameter(valid_579973, JString, required = false,
                                 default = newJString("full"))
  if valid_579973 != nil:
    section.add "projection", valid_579973
  var valid_579974 = query.getOrDefault("prettyPrint")
  valid_579974 = validateParameter(valid_579974, JBool, required = false,
                                 default = newJBool(true))
  if valid_579974 != nil:
    section.add "prettyPrint", valid_579974
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

proc call*(call_579976: Call_StorageBucketsInsert_579964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_579976.validator(path, query, header, formData, body)
  let scheme = call_579976.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579976.url(scheme.get, call_579976.host, call_579976.base,
                         call_579976.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579976, url, valid)

proc call*(call_579977: Call_StorageBucketsInsert_579964; fields: string = "";
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
  var query_579978 = newJObject()
  var body_579979 = newJObject()
  add(query_579978, "fields", newJString(fields))
  add(query_579978, "quotaUser", newJString(quotaUser))
  add(query_579978, "alt", newJString(alt))
  add(query_579978, "oauth_token", newJString(oauthToken))
  add(query_579978, "userIp", newJString(userIp))
  add(query_579978, "key", newJString(key))
  add(query_579978, "projection", newJString(projection))
  if body != nil:
    body_579979 = body
  add(query_579978, "prettyPrint", newJBool(prettyPrint))
  result = call_579977.call(nil, query_579978, nil, nil, body_579979)

var storageBucketsInsert* = Call_StorageBucketsInsert_579964(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_579965, base: "/storage/v1beta1",
    url: url_StorageBucketsInsert_579966, schemes: {Scheme.Https})
type
  Call_StorageBucketsList_579692 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsList_579694(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsList_579693(path: JsonNode; query: JsonNode;
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
  var valid_579806 = query.getOrDefault("fields")
  valid_579806 = validateParameter(valid_579806, JString, required = false,
                                 default = nil)
  if valid_579806 != nil:
    section.add "fields", valid_579806
  var valid_579807 = query.getOrDefault("pageToken")
  valid_579807 = validateParameter(valid_579807, JString, required = false,
                                 default = nil)
  if valid_579807 != nil:
    section.add "pageToken", valid_579807
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
  var valid_579824 = query.getOrDefault("userIp")
  valid_579824 = validateParameter(valid_579824, JString, required = false,
                                 default = nil)
  if valid_579824 != nil:
    section.add "userIp", valid_579824
  var valid_579825 = query.getOrDefault("key")
  valid_579825 = validateParameter(valid_579825, JString, required = false,
                                 default = nil)
  if valid_579825 != nil:
    section.add "key", valid_579825
  var valid_579826 = query.getOrDefault("max-results")
  valid_579826 = validateParameter(valid_579826, JInt, required = false, default = nil)
  if valid_579826 != nil:
    section.add "max-results", valid_579826
  var valid_579827 = query.getOrDefault("projection")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = newJString("full"))
  if valid_579827 != nil:
    section.add "projection", valid_579827
  assert query != nil,
        "query argument is necessary due to required `projectId` field"
  var valid_579828 = query.getOrDefault("projectId")
  valid_579828 = validateParameter(valid_579828, JString, required = true,
                                 default = nil)
  if valid_579828 != nil:
    section.add "projectId", valid_579828
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

proc call*(call_579852: Call_StorageBucketsList_579692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_579852.validator(path, query, header, formData, body)
  let scheme = call_579852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579852.url(scheme.get, call_579852.host, call_579852.base,
                         call_579852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579852, url, valid)

proc call*(call_579923: Call_StorageBucketsList_579692; projectId: string;
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
  var query_579924 = newJObject()
  add(query_579924, "fields", newJString(fields))
  add(query_579924, "pageToken", newJString(pageToken))
  add(query_579924, "quotaUser", newJString(quotaUser))
  add(query_579924, "alt", newJString(alt))
  add(query_579924, "oauth_token", newJString(oauthToken))
  add(query_579924, "userIp", newJString(userIp))
  add(query_579924, "key", newJString(key))
  add(query_579924, "max-results", newJInt(maxResults))
  add(query_579924, "projection", newJString(projection))
  add(query_579924, "projectId", newJString(projectId))
  add(query_579924, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(nil, query_579924, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_579692(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsList_579693, base: "/storage/v1beta1",
    url: url_StorageBucketsList_579694, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_580010 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsUpdate_580012(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsUpdate_580011(path: JsonNode; query: JsonNode;
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
  var valid_580013 = path.getOrDefault("bucket")
  valid_580013 = validateParameter(valid_580013, JString, required = true,
                                 default = nil)
  if valid_580013 != nil:
    section.add "bucket", valid_580013
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
  var valid_580014 = query.getOrDefault("fields")
  valid_580014 = validateParameter(valid_580014, JString, required = false,
                                 default = nil)
  if valid_580014 != nil:
    section.add "fields", valid_580014
  var valid_580015 = query.getOrDefault("quotaUser")
  valid_580015 = validateParameter(valid_580015, JString, required = false,
                                 default = nil)
  if valid_580015 != nil:
    section.add "quotaUser", valid_580015
  var valid_580016 = query.getOrDefault("alt")
  valid_580016 = validateParameter(valid_580016, JString, required = false,
                                 default = newJString("json"))
  if valid_580016 != nil:
    section.add "alt", valid_580016
  var valid_580017 = query.getOrDefault("oauth_token")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "oauth_token", valid_580017
  var valid_580018 = query.getOrDefault("userIp")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "userIp", valid_580018
  var valid_580019 = query.getOrDefault("key")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = nil)
  if valid_580019 != nil:
    section.add "key", valid_580019
  var valid_580020 = query.getOrDefault("projection")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = newJString("full"))
  if valid_580020 != nil:
    section.add "projection", valid_580020
  var valid_580021 = query.getOrDefault("prettyPrint")
  valid_580021 = validateParameter(valid_580021, JBool, required = false,
                                 default = newJBool(true))
  if valid_580021 != nil:
    section.add "prettyPrint", valid_580021
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

proc call*(call_580023: Call_StorageBucketsUpdate_580010; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket.
  ## 
  let valid = call_580023.validator(path, query, header, formData, body)
  let scheme = call_580023.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580023.url(scheme.get, call_580023.host, call_580023.base,
                         call_580023.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580023, url, valid)

proc call*(call_580024: Call_StorageBucketsUpdate_580010; bucket: string;
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
  var path_580025 = newJObject()
  var query_580026 = newJObject()
  var body_580027 = newJObject()
  add(path_580025, "bucket", newJString(bucket))
  add(query_580026, "fields", newJString(fields))
  add(query_580026, "quotaUser", newJString(quotaUser))
  add(query_580026, "alt", newJString(alt))
  add(query_580026, "oauth_token", newJString(oauthToken))
  add(query_580026, "userIp", newJString(userIp))
  add(query_580026, "key", newJString(key))
  add(query_580026, "projection", newJString(projection))
  if body != nil:
    body_580027 = body
  add(query_580026, "prettyPrint", newJBool(prettyPrint))
  result = call_580024.call(path_580025, query_580026, nil, nil, body_580027)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_580010(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_580011, base: "/storage/v1beta1",
    url: url_StorageBucketsUpdate_580012, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_579980 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsGet_579982(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsGet_579981(path: JsonNode; query: JsonNode;
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
  var valid_579997 = path.getOrDefault("bucket")
  valid_579997 = validateParameter(valid_579997, JString, required = true,
                                 default = nil)
  if valid_579997 != nil:
    section.add "bucket", valid_579997
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
  var valid_579998 = query.getOrDefault("fields")
  valid_579998 = validateParameter(valid_579998, JString, required = false,
                                 default = nil)
  if valid_579998 != nil:
    section.add "fields", valid_579998
  var valid_579999 = query.getOrDefault("quotaUser")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "quotaUser", valid_579999
  var valid_580000 = query.getOrDefault("alt")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = newJString("json"))
  if valid_580000 != nil:
    section.add "alt", valid_580000
  var valid_580001 = query.getOrDefault("oauth_token")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = nil)
  if valid_580001 != nil:
    section.add "oauth_token", valid_580001
  var valid_580002 = query.getOrDefault("userIp")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "userIp", valid_580002
  var valid_580003 = query.getOrDefault("key")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "key", valid_580003
  var valid_580004 = query.getOrDefault("projection")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = newJString("full"))
  if valid_580004 != nil:
    section.add "projection", valid_580004
  var valid_580005 = query.getOrDefault("prettyPrint")
  valid_580005 = validateParameter(valid_580005, JBool, required = false,
                                 default = newJBool(true))
  if valid_580005 != nil:
    section.add "prettyPrint", valid_580005
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580006: Call_StorageBucketsGet_579980; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_580006.validator(path, query, header, formData, body)
  let scheme = call_580006.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580006.url(scheme.get, call_580006.host, call_580006.base,
                         call_580006.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580006, url, valid)

proc call*(call_580007: Call_StorageBucketsGet_579980; bucket: string;
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
  var path_580008 = newJObject()
  var query_580009 = newJObject()
  add(path_580008, "bucket", newJString(bucket))
  add(query_580009, "fields", newJString(fields))
  add(query_580009, "quotaUser", newJString(quotaUser))
  add(query_580009, "alt", newJString(alt))
  add(query_580009, "oauth_token", newJString(oauthToken))
  add(query_580009, "userIp", newJString(userIp))
  add(query_580009, "key", newJString(key))
  add(query_580009, "projection", newJString(projection))
  add(query_580009, "prettyPrint", newJBool(prettyPrint))
  result = call_580007.call(path_580008, query_580009, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_579980(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_579981, base: "/storage/v1beta1",
    url: url_StorageBucketsGet_579982, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_580043 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsPatch_580045(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsPatch_580044(path: JsonNode; query: JsonNode;
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
  var valid_580046 = path.getOrDefault("bucket")
  valid_580046 = validateParameter(valid_580046, JString, required = true,
                                 default = nil)
  if valid_580046 != nil:
    section.add "bucket", valid_580046
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
  var valid_580047 = query.getOrDefault("fields")
  valid_580047 = validateParameter(valid_580047, JString, required = false,
                                 default = nil)
  if valid_580047 != nil:
    section.add "fields", valid_580047
  var valid_580048 = query.getOrDefault("quotaUser")
  valid_580048 = validateParameter(valid_580048, JString, required = false,
                                 default = nil)
  if valid_580048 != nil:
    section.add "quotaUser", valid_580048
  var valid_580049 = query.getOrDefault("alt")
  valid_580049 = validateParameter(valid_580049, JString, required = false,
                                 default = newJString("json"))
  if valid_580049 != nil:
    section.add "alt", valid_580049
  var valid_580050 = query.getOrDefault("oauth_token")
  valid_580050 = validateParameter(valid_580050, JString, required = false,
                                 default = nil)
  if valid_580050 != nil:
    section.add "oauth_token", valid_580050
  var valid_580051 = query.getOrDefault("userIp")
  valid_580051 = validateParameter(valid_580051, JString, required = false,
                                 default = nil)
  if valid_580051 != nil:
    section.add "userIp", valid_580051
  var valid_580052 = query.getOrDefault("key")
  valid_580052 = validateParameter(valid_580052, JString, required = false,
                                 default = nil)
  if valid_580052 != nil:
    section.add "key", valid_580052
  var valid_580053 = query.getOrDefault("projection")
  valid_580053 = validateParameter(valid_580053, JString, required = false,
                                 default = newJString("full"))
  if valid_580053 != nil:
    section.add "projection", valid_580053
  var valid_580054 = query.getOrDefault("prettyPrint")
  valid_580054 = validateParameter(valid_580054, JBool, required = false,
                                 default = newJBool(true))
  if valid_580054 != nil:
    section.add "prettyPrint", valid_580054
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

proc call*(call_580056: Call_StorageBucketsPatch_580043; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  let valid = call_580056.validator(path, query, header, formData, body)
  let scheme = call_580056.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580056.url(scheme.get, call_580056.host, call_580056.base,
                         call_580056.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580056, url, valid)

proc call*(call_580057: Call_StorageBucketsPatch_580043; bucket: string;
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
  var path_580058 = newJObject()
  var query_580059 = newJObject()
  var body_580060 = newJObject()
  add(path_580058, "bucket", newJString(bucket))
  add(query_580059, "fields", newJString(fields))
  add(query_580059, "quotaUser", newJString(quotaUser))
  add(query_580059, "alt", newJString(alt))
  add(query_580059, "oauth_token", newJString(oauthToken))
  add(query_580059, "userIp", newJString(userIp))
  add(query_580059, "key", newJString(key))
  add(query_580059, "projection", newJString(projection))
  if body != nil:
    body_580060 = body
  add(query_580059, "prettyPrint", newJBool(prettyPrint))
  result = call_580057.call(path_580058, query_580059, nil, nil, body_580060)

var storageBucketsPatch* = Call_StorageBucketsPatch_580043(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_580044, base: "/storage/v1beta1",
    url: url_StorageBucketsPatch_580045, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_580028 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsDelete_580030(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsDelete_580029(path: JsonNode; query: JsonNode;
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
  var valid_580031 = path.getOrDefault("bucket")
  valid_580031 = validateParameter(valid_580031, JString, required = true,
                                 default = nil)
  if valid_580031 != nil:
    section.add "bucket", valid_580031
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
  var valid_580032 = query.getOrDefault("fields")
  valid_580032 = validateParameter(valid_580032, JString, required = false,
                                 default = nil)
  if valid_580032 != nil:
    section.add "fields", valid_580032
  var valid_580033 = query.getOrDefault("quotaUser")
  valid_580033 = validateParameter(valid_580033, JString, required = false,
                                 default = nil)
  if valid_580033 != nil:
    section.add "quotaUser", valid_580033
  var valid_580034 = query.getOrDefault("alt")
  valid_580034 = validateParameter(valid_580034, JString, required = false,
                                 default = newJString("json"))
  if valid_580034 != nil:
    section.add "alt", valid_580034
  var valid_580035 = query.getOrDefault("oauth_token")
  valid_580035 = validateParameter(valid_580035, JString, required = false,
                                 default = nil)
  if valid_580035 != nil:
    section.add "oauth_token", valid_580035
  var valid_580036 = query.getOrDefault("userIp")
  valid_580036 = validateParameter(valid_580036, JString, required = false,
                                 default = nil)
  if valid_580036 != nil:
    section.add "userIp", valid_580036
  var valid_580037 = query.getOrDefault("key")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "key", valid_580037
  var valid_580038 = query.getOrDefault("prettyPrint")
  valid_580038 = validateParameter(valid_580038, JBool, required = false,
                                 default = newJBool(true))
  if valid_580038 != nil:
    section.add "prettyPrint", valid_580038
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580039: Call_StorageBucketsDelete_580028; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an empty bucket.
  ## 
  let valid = call_580039.validator(path, query, header, formData, body)
  let scheme = call_580039.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580039.url(scheme.get, call_580039.host, call_580039.base,
                         call_580039.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580039, url, valid)

proc call*(call_580040: Call_StorageBucketsDelete_580028; bucket: string;
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
  var path_580041 = newJObject()
  var query_580042 = newJObject()
  add(path_580041, "bucket", newJString(bucket))
  add(query_580042, "fields", newJString(fields))
  add(query_580042, "quotaUser", newJString(quotaUser))
  add(query_580042, "alt", newJString(alt))
  add(query_580042, "oauth_token", newJString(oauthToken))
  add(query_580042, "userIp", newJString(userIp))
  add(query_580042, "key", newJString(key))
  add(query_580042, "prettyPrint", newJBool(prettyPrint))
  result = call_580040.call(path_580041, query_580042, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_580028(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_580029, base: "/storage/v1beta1",
    url: url_StorageBucketsDelete_580030, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_580076 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsInsert_580078(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsInsert_580077(path: JsonNode;
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
  var valid_580079 = path.getOrDefault("bucket")
  valid_580079 = validateParameter(valid_580079, JString, required = true,
                                 default = nil)
  if valid_580079 != nil:
    section.add "bucket", valid_580079
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
  var valid_580080 = query.getOrDefault("fields")
  valid_580080 = validateParameter(valid_580080, JString, required = false,
                                 default = nil)
  if valid_580080 != nil:
    section.add "fields", valid_580080
  var valid_580081 = query.getOrDefault("quotaUser")
  valid_580081 = validateParameter(valid_580081, JString, required = false,
                                 default = nil)
  if valid_580081 != nil:
    section.add "quotaUser", valid_580081
  var valid_580082 = query.getOrDefault("alt")
  valid_580082 = validateParameter(valid_580082, JString, required = false,
                                 default = newJString("json"))
  if valid_580082 != nil:
    section.add "alt", valid_580082
  var valid_580083 = query.getOrDefault("oauth_token")
  valid_580083 = validateParameter(valid_580083, JString, required = false,
                                 default = nil)
  if valid_580083 != nil:
    section.add "oauth_token", valid_580083
  var valid_580084 = query.getOrDefault("userIp")
  valid_580084 = validateParameter(valid_580084, JString, required = false,
                                 default = nil)
  if valid_580084 != nil:
    section.add "userIp", valid_580084
  var valid_580085 = query.getOrDefault("key")
  valid_580085 = validateParameter(valid_580085, JString, required = false,
                                 default = nil)
  if valid_580085 != nil:
    section.add "key", valid_580085
  var valid_580086 = query.getOrDefault("prettyPrint")
  valid_580086 = validateParameter(valid_580086, JBool, required = false,
                                 default = newJBool(true))
  if valid_580086 != nil:
    section.add "prettyPrint", valid_580086
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

proc call*(call_580088: Call_StorageBucketAccessControlsInsert_580076;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_580088.validator(path, query, header, formData, body)
  let scheme = call_580088.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580088.url(scheme.get, call_580088.host, call_580088.base,
                         call_580088.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580088, url, valid)

proc call*(call_580089: Call_StorageBucketAccessControlsInsert_580076;
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
  var path_580090 = newJObject()
  var query_580091 = newJObject()
  var body_580092 = newJObject()
  add(path_580090, "bucket", newJString(bucket))
  add(query_580091, "fields", newJString(fields))
  add(query_580091, "quotaUser", newJString(quotaUser))
  add(query_580091, "alt", newJString(alt))
  add(query_580091, "oauth_token", newJString(oauthToken))
  add(query_580091, "userIp", newJString(userIp))
  add(query_580091, "key", newJString(key))
  if body != nil:
    body_580092 = body
  add(query_580091, "prettyPrint", newJBool(prettyPrint))
  result = call_580089.call(path_580090, query_580091, nil, nil, body_580092)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_580076(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_580077,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsInsert_580078,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_580061 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsList_580063(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsList_580062(path: JsonNode;
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
  var valid_580064 = path.getOrDefault("bucket")
  valid_580064 = validateParameter(valid_580064, JString, required = true,
                                 default = nil)
  if valid_580064 != nil:
    section.add "bucket", valid_580064
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
  var valid_580065 = query.getOrDefault("fields")
  valid_580065 = validateParameter(valid_580065, JString, required = false,
                                 default = nil)
  if valid_580065 != nil:
    section.add "fields", valid_580065
  var valid_580066 = query.getOrDefault("quotaUser")
  valid_580066 = validateParameter(valid_580066, JString, required = false,
                                 default = nil)
  if valid_580066 != nil:
    section.add "quotaUser", valid_580066
  var valid_580067 = query.getOrDefault("alt")
  valid_580067 = validateParameter(valid_580067, JString, required = false,
                                 default = newJString("json"))
  if valid_580067 != nil:
    section.add "alt", valid_580067
  var valid_580068 = query.getOrDefault("oauth_token")
  valid_580068 = validateParameter(valid_580068, JString, required = false,
                                 default = nil)
  if valid_580068 != nil:
    section.add "oauth_token", valid_580068
  var valid_580069 = query.getOrDefault("userIp")
  valid_580069 = validateParameter(valid_580069, JString, required = false,
                                 default = nil)
  if valid_580069 != nil:
    section.add "userIp", valid_580069
  var valid_580070 = query.getOrDefault("key")
  valid_580070 = validateParameter(valid_580070, JString, required = false,
                                 default = nil)
  if valid_580070 != nil:
    section.add "key", valid_580070
  var valid_580071 = query.getOrDefault("prettyPrint")
  valid_580071 = validateParameter(valid_580071, JBool, required = false,
                                 default = newJBool(true))
  if valid_580071 != nil:
    section.add "prettyPrint", valid_580071
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580072: Call_StorageBucketAccessControlsList_580061;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_580072.validator(path, query, header, formData, body)
  let scheme = call_580072.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580072.url(scheme.get, call_580072.host, call_580072.base,
                         call_580072.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580072, url, valid)

proc call*(call_580073: Call_StorageBucketAccessControlsList_580061;
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
  var path_580074 = newJObject()
  var query_580075 = newJObject()
  add(path_580074, "bucket", newJString(bucket))
  add(query_580075, "fields", newJString(fields))
  add(query_580075, "quotaUser", newJString(quotaUser))
  add(query_580075, "alt", newJString(alt))
  add(query_580075, "oauth_token", newJString(oauthToken))
  add(query_580075, "userIp", newJString(userIp))
  add(query_580075, "key", newJString(key))
  add(query_580075, "prettyPrint", newJBool(prettyPrint))
  result = call_580073.call(path_580074, query_580075, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_580061(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_580062,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsList_580063,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_580109 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsUpdate_580111(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsUpdate_580110(path: JsonNode;
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
  var valid_580112 = path.getOrDefault("bucket")
  valid_580112 = validateParameter(valid_580112, JString, required = true,
                                 default = nil)
  if valid_580112 != nil:
    section.add "bucket", valid_580112
  var valid_580113 = path.getOrDefault("entity")
  valid_580113 = validateParameter(valid_580113, JString, required = true,
                                 default = nil)
  if valid_580113 != nil:
    section.add "entity", valid_580113
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
  var valid_580114 = query.getOrDefault("fields")
  valid_580114 = validateParameter(valid_580114, JString, required = false,
                                 default = nil)
  if valid_580114 != nil:
    section.add "fields", valid_580114
  var valid_580115 = query.getOrDefault("quotaUser")
  valid_580115 = validateParameter(valid_580115, JString, required = false,
                                 default = nil)
  if valid_580115 != nil:
    section.add "quotaUser", valid_580115
  var valid_580116 = query.getOrDefault("alt")
  valid_580116 = validateParameter(valid_580116, JString, required = false,
                                 default = newJString("json"))
  if valid_580116 != nil:
    section.add "alt", valid_580116
  var valid_580117 = query.getOrDefault("oauth_token")
  valid_580117 = validateParameter(valid_580117, JString, required = false,
                                 default = nil)
  if valid_580117 != nil:
    section.add "oauth_token", valid_580117
  var valid_580118 = query.getOrDefault("userIp")
  valid_580118 = validateParameter(valid_580118, JString, required = false,
                                 default = nil)
  if valid_580118 != nil:
    section.add "userIp", valid_580118
  var valid_580119 = query.getOrDefault("key")
  valid_580119 = validateParameter(valid_580119, JString, required = false,
                                 default = nil)
  if valid_580119 != nil:
    section.add "key", valid_580119
  var valid_580120 = query.getOrDefault("prettyPrint")
  valid_580120 = validateParameter(valid_580120, JBool, required = false,
                                 default = newJBool(true))
  if valid_580120 != nil:
    section.add "prettyPrint", valid_580120
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

proc call*(call_580122: Call_StorageBucketAccessControlsUpdate_580109;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_580122.validator(path, query, header, formData, body)
  let scheme = call_580122.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580122.url(scheme.get, call_580122.host, call_580122.base,
                         call_580122.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580122, url, valid)

proc call*(call_580123: Call_StorageBucketAccessControlsUpdate_580109;
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
  var path_580124 = newJObject()
  var query_580125 = newJObject()
  var body_580126 = newJObject()
  add(path_580124, "bucket", newJString(bucket))
  add(query_580125, "fields", newJString(fields))
  add(query_580125, "quotaUser", newJString(quotaUser))
  add(query_580125, "alt", newJString(alt))
  add(query_580125, "oauth_token", newJString(oauthToken))
  add(query_580125, "userIp", newJString(userIp))
  add(query_580125, "key", newJString(key))
  if body != nil:
    body_580126 = body
  add(query_580125, "prettyPrint", newJBool(prettyPrint))
  add(path_580124, "entity", newJString(entity))
  result = call_580123.call(path_580124, query_580125, nil, nil, body_580126)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_580109(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_580110,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsUpdate_580111,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_580093 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsGet_580095(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsGet_580094(path: JsonNode;
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
  var valid_580096 = path.getOrDefault("bucket")
  valid_580096 = validateParameter(valid_580096, JString, required = true,
                                 default = nil)
  if valid_580096 != nil:
    section.add "bucket", valid_580096
  var valid_580097 = path.getOrDefault("entity")
  valid_580097 = validateParameter(valid_580097, JString, required = true,
                                 default = nil)
  if valid_580097 != nil:
    section.add "entity", valid_580097
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
  var valid_580098 = query.getOrDefault("fields")
  valid_580098 = validateParameter(valid_580098, JString, required = false,
                                 default = nil)
  if valid_580098 != nil:
    section.add "fields", valid_580098
  var valid_580099 = query.getOrDefault("quotaUser")
  valid_580099 = validateParameter(valid_580099, JString, required = false,
                                 default = nil)
  if valid_580099 != nil:
    section.add "quotaUser", valid_580099
  var valid_580100 = query.getOrDefault("alt")
  valid_580100 = validateParameter(valid_580100, JString, required = false,
                                 default = newJString("json"))
  if valid_580100 != nil:
    section.add "alt", valid_580100
  var valid_580101 = query.getOrDefault("oauth_token")
  valid_580101 = validateParameter(valid_580101, JString, required = false,
                                 default = nil)
  if valid_580101 != nil:
    section.add "oauth_token", valid_580101
  var valid_580102 = query.getOrDefault("userIp")
  valid_580102 = validateParameter(valid_580102, JString, required = false,
                                 default = nil)
  if valid_580102 != nil:
    section.add "userIp", valid_580102
  var valid_580103 = query.getOrDefault("key")
  valid_580103 = validateParameter(valid_580103, JString, required = false,
                                 default = nil)
  if valid_580103 != nil:
    section.add "key", valid_580103
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
  if body != nil:
    result.add "body", body

proc call*(call_580105: Call_StorageBucketAccessControlsGet_580093; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580105.validator(path, query, header, formData, body)
  let scheme = call_580105.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580105.url(scheme.get, call_580105.host, call_580105.base,
                         call_580105.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580105, url, valid)

proc call*(call_580106: Call_StorageBucketAccessControlsGet_580093; bucket: string;
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
  var path_580107 = newJObject()
  var query_580108 = newJObject()
  add(path_580107, "bucket", newJString(bucket))
  add(query_580108, "fields", newJString(fields))
  add(query_580108, "quotaUser", newJString(quotaUser))
  add(query_580108, "alt", newJString(alt))
  add(query_580108, "oauth_token", newJString(oauthToken))
  add(query_580108, "userIp", newJString(userIp))
  add(query_580108, "key", newJString(key))
  add(query_580108, "prettyPrint", newJBool(prettyPrint))
  add(path_580107, "entity", newJString(entity))
  result = call_580106.call(path_580107, query_580108, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_580093(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_580094,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsGet_580095,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_580143 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsPatch_580145(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsPatch_580144(path: JsonNode;
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
  var valid_580146 = path.getOrDefault("bucket")
  valid_580146 = validateParameter(valid_580146, JString, required = true,
                                 default = nil)
  if valid_580146 != nil:
    section.add "bucket", valid_580146
  var valid_580147 = path.getOrDefault("entity")
  valid_580147 = validateParameter(valid_580147, JString, required = true,
                                 default = nil)
  if valid_580147 != nil:
    section.add "entity", valid_580147
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
  var valid_580148 = query.getOrDefault("fields")
  valid_580148 = validateParameter(valid_580148, JString, required = false,
                                 default = nil)
  if valid_580148 != nil:
    section.add "fields", valid_580148
  var valid_580149 = query.getOrDefault("quotaUser")
  valid_580149 = validateParameter(valid_580149, JString, required = false,
                                 default = nil)
  if valid_580149 != nil:
    section.add "quotaUser", valid_580149
  var valid_580150 = query.getOrDefault("alt")
  valid_580150 = validateParameter(valid_580150, JString, required = false,
                                 default = newJString("json"))
  if valid_580150 != nil:
    section.add "alt", valid_580150
  var valid_580151 = query.getOrDefault("oauth_token")
  valid_580151 = validateParameter(valid_580151, JString, required = false,
                                 default = nil)
  if valid_580151 != nil:
    section.add "oauth_token", valid_580151
  var valid_580152 = query.getOrDefault("userIp")
  valid_580152 = validateParameter(valid_580152, JString, required = false,
                                 default = nil)
  if valid_580152 != nil:
    section.add "userIp", valid_580152
  var valid_580153 = query.getOrDefault("key")
  valid_580153 = validateParameter(valid_580153, JString, required = false,
                                 default = nil)
  if valid_580153 != nil:
    section.add "key", valid_580153
  var valid_580154 = query.getOrDefault("prettyPrint")
  valid_580154 = validateParameter(valid_580154, JBool, required = false,
                                 default = newJBool(true))
  if valid_580154 != nil:
    section.add "prettyPrint", valid_580154
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

proc call*(call_580156: Call_StorageBucketAccessControlsPatch_580143;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_580156.validator(path, query, header, formData, body)
  let scheme = call_580156.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580156.url(scheme.get, call_580156.host, call_580156.base,
                         call_580156.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580156, url, valid)

proc call*(call_580157: Call_StorageBucketAccessControlsPatch_580143;
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
  var path_580158 = newJObject()
  var query_580159 = newJObject()
  var body_580160 = newJObject()
  add(path_580158, "bucket", newJString(bucket))
  add(query_580159, "fields", newJString(fields))
  add(query_580159, "quotaUser", newJString(quotaUser))
  add(query_580159, "alt", newJString(alt))
  add(query_580159, "oauth_token", newJString(oauthToken))
  add(query_580159, "userIp", newJString(userIp))
  add(query_580159, "key", newJString(key))
  if body != nil:
    body_580160 = body
  add(query_580159, "prettyPrint", newJBool(prettyPrint))
  add(path_580158, "entity", newJString(entity))
  result = call_580157.call(path_580158, query_580159, nil, nil, body_580160)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_580143(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_580144,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsPatch_580145,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_580127 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsDelete_580129(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsDelete_580128(path: JsonNode;
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
  var valid_580130 = path.getOrDefault("bucket")
  valid_580130 = validateParameter(valid_580130, JString, required = true,
                                 default = nil)
  if valid_580130 != nil:
    section.add "bucket", valid_580130
  var valid_580131 = path.getOrDefault("entity")
  valid_580131 = validateParameter(valid_580131, JString, required = true,
                                 default = nil)
  if valid_580131 != nil:
    section.add "entity", valid_580131
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
  var valid_580132 = query.getOrDefault("fields")
  valid_580132 = validateParameter(valid_580132, JString, required = false,
                                 default = nil)
  if valid_580132 != nil:
    section.add "fields", valid_580132
  var valid_580133 = query.getOrDefault("quotaUser")
  valid_580133 = validateParameter(valid_580133, JString, required = false,
                                 default = nil)
  if valid_580133 != nil:
    section.add "quotaUser", valid_580133
  var valid_580134 = query.getOrDefault("alt")
  valid_580134 = validateParameter(valid_580134, JString, required = false,
                                 default = newJString("json"))
  if valid_580134 != nil:
    section.add "alt", valid_580134
  var valid_580135 = query.getOrDefault("oauth_token")
  valid_580135 = validateParameter(valid_580135, JString, required = false,
                                 default = nil)
  if valid_580135 != nil:
    section.add "oauth_token", valid_580135
  var valid_580136 = query.getOrDefault("userIp")
  valid_580136 = validateParameter(valid_580136, JString, required = false,
                                 default = nil)
  if valid_580136 != nil:
    section.add "userIp", valid_580136
  var valid_580137 = query.getOrDefault("key")
  valid_580137 = validateParameter(valid_580137, JString, required = false,
                                 default = nil)
  if valid_580137 != nil:
    section.add "key", valid_580137
  var valid_580138 = query.getOrDefault("prettyPrint")
  valid_580138 = validateParameter(valid_580138, JBool, required = false,
                                 default = newJBool(true))
  if valid_580138 != nil:
    section.add "prettyPrint", valid_580138
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580139: Call_StorageBucketAccessControlsDelete_580127;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580139.validator(path, query, header, formData, body)
  let scheme = call_580139.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580139.url(scheme.get, call_580139.host, call_580139.base,
                         call_580139.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580139, url, valid)

proc call*(call_580140: Call_StorageBucketAccessControlsDelete_580127;
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
  var path_580141 = newJObject()
  var query_580142 = newJObject()
  add(path_580141, "bucket", newJString(bucket))
  add(query_580142, "fields", newJString(fields))
  add(query_580142, "quotaUser", newJString(quotaUser))
  add(query_580142, "alt", newJString(alt))
  add(query_580142, "oauth_token", newJString(oauthToken))
  add(query_580142, "userIp", newJString(userIp))
  add(query_580142, "key", newJString(key))
  add(query_580142, "prettyPrint", newJBool(prettyPrint))
  add(path_580141, "entity", newJString(entity))
  result = call_580140.call(path_580141, query_580142, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_580127(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_580128,
    base: "/storage/v1beta1", url: url_StorageBucketAccessControlsDelete_580129,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_580181 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsInsert_580183(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsInsert_580182(path: JsonNode; query: JsonNode;
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
  var valid_580184 = path.getOrDefault("bucket")
  valid_580184 = validateParameter(valid_580184, JString, required = true,
                                 default = nil)
  if valid_580184 != nil:
    section.add "bucket", valid_580184
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
  var valid_580185 = query.getOrDefault("fields")
  valid_580185 = validateParameter(valid_580185, JString, required = false,
                                 default = nil)
  if valid_580185 != nil:
    section.add "fields", valid_580185
  var valid_580186 = query.getOrDefault("quotaUser")
  valid_580186 = validateParameter(valid_580186, JString, required = false,
                                 default = nil)
  if valid_580186 != nil:
    section.add "quotaUser", valid_580186
  var valid_580187 = query.getOrDefault("alt")
  valid_580187 = validateParameter(valid_580187, JString, required = false,
                                 default = newJString("json"))
  if valid_580187 != nil:
    section.add "alt", valid_580187
  var valid_580188 = query.getOrDefault("oauth_token")
  valid_580188 = validateParameter(valid_580188, JString, required = false,
                                 default = nil)
  if valid_580188 != nil:
    section.add "oauth_token", valid_580188
  var valid_580189 = query.getOrDefault("userIp")
  valid_580189 = validateParameter(valid_580189, JString, required = false,
                                 default = nil)
  if valid_580189 != nil:
    section.add "userIp", valid_580189
  var valid_580190 = query.getOrDefault("key")
  valid_580190 = validateParameter(valid_580190, JString, required = false,
                                 default = nil)
  if valid_580190 != nil:
    section.add "key", valid_580190
  var valid_580191 = query.getOrDefault("name")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "name", valid_580191
  var valid_580192 = query.getOrDefault("projection")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = newJString("full"))
  if valid_580192 != nil:
    section.add "projection", valid_580192
  var valid_580193 = query.getOrDefault("prettyPrint")
  valid_580193 = validateParameter(valid_580193, JBool, required = false,
                                 default = newJBool(true))
  if valid_580193 != nil:
    section.add "prettyPrint", valid_580193
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

proc call*(call_580195: Call_StorageObjectsInsert_580181; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores new data blobs and associated metadata.
  ## 
  let valid = call_580195.validator(path, query, header, formData, body)
  let scheme = call_580195.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580195.url(scheme.get, call_580195.host, call_580195.base,
                         call_580195.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580195, url, valid)

proc call*(call_580196: Call_StorageObjectsInsert_580181; bucket: string;
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
  var path_580197 = newJObject()
  var query_580198 = newJObject()
  var body_580199 = newJObject()
  add(path_580197, "bucket", newJString(bucket))
  add(query_580198, "fields", newJString(fields))
  add(query_580198, "quotaUser", newJString(quotaUser))
  add(query_580198, "alt", newJString(alt))
  add(query_580198, "oauth_token", newJString(oauthToken))
  add(query_580198, "userIp", newJString(userIp))
  add(query_580198, "key", newJString(key))
  add(query_580198, "name", newJString(name))
  add(query_580198, "projection", newJString(projection))
  if body != nil:
    body_580199 = body
  add(query_580198, "prettyPrint", newJBool(prettyPrint))
  result = call_580196.call(path_580197, query_580198, nil, nil, body_580199)

var storageObjectsInsert* = Call_StorageObjectsInsert_580181(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_580182, base: "/storage/v1beta1",
    url: url_StorageObjectsInsert_580183, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_580161 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsList_580163(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsList_580162(path: JsonNode; query: JsonNode;
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
  var valid_580164 = path.getOrDefault("bucket")
  valid_580164 = validateParameter(valid_580164, JString, required = true,
                                 default = nil)
  if valid_580164 != nil:
    section.add "bucket", valid_580164
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
  var valid_580165 = query.getOrDefault("fields")
  valid_580165 = validateParameter(valid_580165, JString, required = false,
                                 default = nil)
  if valid_580165 != nil:
    section.add "fields", valid_580165
  var valid_580166 = query.getOrDefault("pageToken")
  valid_580166 = validateParameter(valid_580166, JString, required = false,
                                 default = nil)
  if valid_580166 != nil:
    section.add "pageToken", valid_580166
  var valid_580167 = query.getOrDefault("quotaUser")
  valid_580167 = validateParameter(valid_580167, JString, required = false,
                                 default = nil)
  if valid_580167 != nil:
    section.add "quotaUser", valid_580167
  var valid_580168 = query.getOrDefault("alt")
  valid_580168 = validateParameter(valid_580168, JString, required = false,
                                 default = newJString("json"))
  if valid_580168 != nil:
    section.add "alt", valid_580168
  var valid_580169 = query.getOrDefault("oauth_token")
  valid_580169 = validateParameter(valid_580169, JString, required = false,
                                 default = nil)
  if valid_580169 != nil:
    section.add "oauth_token", valid_580169
  var valid_580170 = query.getOrDefault("userIp")
  valid_580170 = validateParameter(valid_580170, JString, required = false,
                                 default = nil)
  if valid_580170 != nil:
    section.add "userIp", valid_580170
  var valid_580171 = query.getOrDefault("key")
  valid_580171 = validateParameter(valid_580171, JString, required = false,
                                 default = nil)
  if valid_580171 != nil:
    section.add "key", valid_580171
  var valid_580172 = query.getOrDefault("max-results")
  valid_580172 = validateParameter(valid_580172, JInt, required = false, default = nil)
  if valid_580172 != nil:
    section.add "max-results", valid_580172
  var valid_580173 = query.getOrDefault("projection")
  valid_580173 = validateParameter(valid_580173, JString, required = false,
                                 default = newJString("full"))
  if valid_580173 != nil:
    section.add "projection", valid_580173
  var valid_580174 = query.getOrDefault("delimiter")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "delimiter", valid_580174
  var valid_580175 = query.getOrDefault("prettyPrint")
  valid_580175 = validateParameter(valid_580175, JBool, required = false,
                                 default = newJBool(true))
  if valid_580175 != nil:
    section.add "prettyPrint", valid_580175
  var valid_580176 = query.getOrDefault("prefix")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = nil)
  if valid_580176 != nil:
    section.add "prefix", valid_580176
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580177: Call_StorageObjectsList_580161; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_580177.validator(path, query, header, formData, body)
  let scheme = call_580177.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580177.url(scheme.get, call_580177.host, call_580177.base,
                         call_580177.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580177, url, valid)

proc call*(call_580178: Call_StorageObjectsList_580161; bucket: string;
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
  var path_580179 = newJObject()
  var query_580180 = newJObject()
  add(path_580179, "bucket", newJString(bucket))
  add(query_580180, "fields", newJString(fields))
  add(query_580180, "pageToken", newJString(pageToken))
  add(query_580180, "quotaUser", newJString(quotaUser))
  add(query_580180, "alt", newJString(alt))
  add(query_580180, "oauth_token", newJString(oauthToken))
  add(query_580180, "userIp", newJString(userIp))
  add(query_580180, "key", newJString(key))
  add(query_580180, "max-results", newJInt(maxResults))
  add(query_580180, "projection", newJString(projection))
  add(query_580180, "delimiter", newJString(delimiter))
  add(query_580180, "prettyPrint", newJBool(prettyPrint))
  add(query_580180, "prefix", newJString(prefix))
  result = call_580178.call(path_580179, query_580180, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_580161(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_580162, base: "/storage/v1beta1",
    url: url_StorageObjectsList_580163, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_580217 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsUpdate_580219(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsUpdate_580218(path: JsonNode; query: JsonNode;
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
  var valid_580220 = path.getOrDefault("bucket")
  valid_580220 = validateParameter(valid_580220, JString, required = true,
                                 default = nil)
  if valid_580220 != nil:
    section.add "bucket", valid_580220
  var valid_580221 = path.getOrDefault("object")
  valid_580221 = validateParameter(valid_580221, JString, required = true,
                                 default = nil)
  if valid_580221 != nil:
    section.add "object", valid_580221
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
  var valid_580222 = query.getOrDefault("fields")
  valid_580222 = validateParameter(valid_580222, JString, required = false,
                                 default = nil)
  if valid_580222 != nil:
    section.add "fields", valid_580222
  var valid_580223 = query.getOrDefault("quotaUser")
  valid_580223 = validateParameter(valid_580223, JString, required = false,
                                 default = nil)
  if valid_580223 != nil:
    section.add "quotaUser", valid_580223
  var valid_580224 = query.getOrDefault("alt")
  valid_580224 = validateParameter(valid_580224, JString, required = false,
                                 default = newJString("json"))
  if valid_580224 != nil:
    section.add "alt", valid_580224
  var valid_580225 = query.getOrDefault("oauth_token")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "oauth_token", valid_580225
  var valid_580226 = query.getOrDefault("userIp")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "userIp", valid_580226
  var valid_580227 = query.getOrDefault("key")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = nil)
  if valid_580227 != nil:
    section.add "key", valid_580227
  var valid_580228 = query.getOrDefault("projection")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = newJString("full"))
  if valid_580228 != nil:
    section.add "projection", valid_580228
  var valid_580229 = query.getOrDefault("prettyPrint")
  valid_580229 = validateParameter(valid_580229, JBool, required = false,
                                 default = newJBool(true))
  if valid_580229 != nil:
    section.add "prettyPrint", valid_580229
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

proc call*(call_580231: Call_StorageObjectsUpdate_580217; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata.
  ## 
  let valid = call_580231.validator(path, query, header, formData, body)
  let scheme = call_580231.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580231.url(scheme.get, call_580231.host, call_580231.base,
                         call_580231.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580231, url, valid)

proc call*(call_580232: Call_StorageObjectsUpdate_580217; bucket: string;
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
  var path_580233 = newJObject()
  var query_580234 = newJObject()
  var body_580235 = newJObject()
  add(path_580233, "bucket", newJString(bucket))
  add(query_580234, "fields", newJString(fields))
  add(query_580234, "quotaUser", newJString(quotaUser))
  add(query_580234, "alt", newJString(alt))
  add(query_580234, "oauth_token", newJString(oauthToken))
  add(query_580234, "userIp", newJString(userIp))
  add(query_580234, "key", newJString(key))
  add(query_580234, "projection", newJString(projection))
  if body != nil:
    body_580235 = body
  add(query_580234, "prettyPrint", newJBool(prettyPrint))
  add(path_580233, "object", newJString(`object`))
  result = call_580232.call(path_580233, query_580234, nil, nil, body_580235)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_580217(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_580218, base: "/storage/v1beta1",
    url: url_StorageObjectsUpdate_580219, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_580200 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsGet_580202(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsGet_580201(path: JsonNode; query: JsonNode;
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
  var valid_580203 = path.getOrDefault("bucket")
  valid_580203 = validateParameter(valid_580203, JString, required = true,
                                 default = nil)
  if valid_580203 != nil:
    section.add "bucket", valid_580203
  var valid_580204 = path.getOrDefault("object")
  valid_580204 = validateParameter(valid_580204, JString, required = true,
                                 default = nil)
  if valid_580204 != nil:
    section.add "object", valid_580204
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
  var valid_580205 = query.getOrDefault("fields")
  valid_580205 = validateParameter(valid_580205, JString, required = false,
                                 default = nil)
  if valid_580205 != nil:
    section.add "fields", valid_580205
  var valid_580206 = query.getOrDefault("quotaUser")
  valid_580206 = validateParameter(valid_580206, JString, required = false,
                                 default = nil)
  if valid_580206 != nil:
    section.add "quotaUser", valid_580206
  var valid_580207 = query.getOrDefault("alt")
  valid_580207 = validateParameter(valid_580207, JString, required = false,
                                 default = newJString("json"))
  if valid_580207 != nil:
    section.add "alt", valid_580207
  var valid_580208 = query.getOrDefault("oauth_token")
  valid_580208 = validateParameter(valid_580208, JString, required = false,
                                 default = nil)
  if valid_580208 != nil:
    section.add "oauth_token", valid_580208
  var valid_580209 = query.getOrDefault("userIp")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "userIp", valid_580209
  var valid_580210 = query.getOrDefault("key")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "key", valid_580210
  var valid_580211 = query.getOrDefault("projection")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("full"))
  if valid_580211 != nil:
    section.add "projection", valid_580211
  var valid_580212 = query.getOrDefault("prettyPrint")
  valid_580212 = validateParameter(valid_580212, JBool, required = false,
                                 default = newJBool(true))
  if valid_580212 != nil:
    section.add "prettyPrint", valid_580212
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580213: Call_StorageObjectsGet_580200; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves objects or their associated metadata.
  ## 
  let valid = call_580213.validator(path, query, header, formData, body)
  let scheme = call_580213.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580213.url(scheme.get, call_580213.host, call_580213.base,
                         call_580213.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580213, url, valid)

proc call*(call_580214: Call_StorageObjectsGet_580200; bucket: string;
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
  var path_580215 = newJObject()
  var query_580216 = newJObject()
  add(path_580215, "bucket", newJString(bucket))
  add(query_580216, "fields", newJString(fields))
  add(query_580216, "quotaUser", newJString(quotaUser))
  add(query_580216, "alt", newJString(alt))
  add(query_580216, "oauth_token", newJString(oauthToken))
  add(query_580216, "userIp", newJString(userIp))
  add(query_580216, "key", newJString(key))
  add(query_580216, "projection", newJString(projection))
  add(query_580216, "prettyPrint", newJBool(prettyPrint))
  add(path_580215, "object", newJString(`object`))
  result = call_580214.call(path_580215, query_580216, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_580200(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_580201,
    base: "/storage/v1beta1", url: url_StorageObjectsGet_580202,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_580252 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsPatch_580254(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsPatch_580253(path: JsonNode; query: JsonNode;
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
  var valid_580255 = path.getOrDefault("bucket")
  valid_580255 = validateParameter(valid_580255, JString, required = true,
                                 default = nil)
  if valid_580255 != nil:
    section.add "bucket", valid_580255
  var valid_580256 = path.getOrDefault("object")
  valid_580256 = validateParameter(valid_580256, JString, required = true,
                                 default = nil)
  if valid_580256 != nil:
    section.add "object", valid_580256
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
  var valid_580257 = query.getOrDefault("fields")
  valid_580257 = validateParameter(valid_580257, JString, required = false,
                                 default = nil)
  if valid_580257 != nil:
    section.add "fields", valid_580257
  var valid_580258 = query.getOrDefault("quotaUser")
  valid_580258 = validateParameter(valid_580258, JString, required = false,
                                 default = nil)
  if valid_580258 != nil:
    section.add "quotaUser", valid_580258
  var valid_580259 = query.getOrDefault("alt")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = newJString("json"))
  if valid_580259 != nil:
    section.add "alt", valid_580259
  var valid_580260 = query.getOrDefault("oauth_token")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "oauth_token", valid_580260
  var valid_580261 = query.getOrDefault("userIp")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = nil)
  if valid_580261 != nil:
    section.add "userIp", valid_580261
  var valid_580262 = query.getOrDefault("key")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "key", valid_580262
  var valid_580263 = query.getOrDefault("projection")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = newJString("full"))
  if valid_580263 != nil:
    section.add "projection", valid_580263
  var valid_580264 = query.getOrDefault("prettyPrint")
  valid_580264 = validateParameter(valid_580264, JBool, required = false,
                                 default = newJBool(true))
  if valid_580264 != nil:
    section.add "prettyPrint", valid_580264
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

proc call*(call_580266: Call_StorageObjectsPatch_580252; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  let valid = call_580266.validator(path, query, header, formData, body)
  let scheme = call_580266.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580266.url(scheme.get, call_580266.host, call_580266.base,
                         call_580266.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580266, url, valid)

proc call*(call_580267: Call_StorageObjectsPatch_580252; bucket: string;
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
  var path_580268 = newJObject()
  var query_580269 = newJObject()
  var body_580270 = newJObject()
  add(path_580268, "bucket", newJString(bucket))
  add(query_580269, "fields", newJString(fields))
  add(query_580269, "quotaUser", newJString(quotaUser))
  add(query_580269, "alt", newJString(alt))
  add(query_580269, "oauth_token", newJString(oauthToken))
  add(query_580269, "userIp", newJString(userIp))
  add(query_580269, "key", newJString(key))
  add(query_580269, "projection", newJString(projection))
  if body != nil:
    body_580270 = body
  add(query_580269, "prettyPrint", newJBool(prettyPrint))
  add(path_580268, "object", newJString(`object`))
  result = call_580267.call(path_580268, query_580269, nil, nil, body_580270)

var storageObjectsPatch* = Call_StorageObjectsPatch_580252(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_580253, base: "/storage/v1beta1",
    url: url_StorageObjectsPatch_580254, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_580236 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsDelete_580238(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsDelete_580237(path: JsonNode; query: JsonNode;
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
  var valid_580239 = path.getOrDefault("bucket")
  valid_580239 = validateParameter(valid_580239, JString, required = true,
                                 default = nil)
  if valid_580239 != nil:
    section.add "bucket", valid_580239
  var valid_580240 = path.getOrDefault("object")
  valid_580240 = validateParameter(valid_580240, JString, required = true,
                                 default = nil)
  if valid_580240 != nil:
    section.add "object", valid_580240
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
  var valid_580241 = query.getOrDefault("fields")
  valid_580241 = validateParameter(valid_580241, JString, required = false,
                                 default = nil)
  if valid_580241 != nil:
    section.add "fields", valid_580241
  var valid_580242 = query.getOrDefault("quotaUser")
  valid_580242 = validateParameter(valid_580242, JString, required = false,
                                 default = nil)
  if valid_580242 != nil:
    section.add "quotaUser", valid_580242
  var valid_580243 = query.getOrDefault("alt")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = newJString("json"))
  if valid_580243 != nil:
    section.add "alt", valid_580243
  var valid_580244 = query.getOrDefault("oauth_token")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "oauth_token", valid_580244
  var valid_580245 = query.getOrDefault("userIp")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = nil)
  if valid_580245 != nil:
    section.add "userIp", valid_580245
  var valid_580246 = query.getOrDefault("key")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "key", valid_580246
  var valid_580247 = query.getOrDefault("prettyPrint")
  valid_580247 = validateParameter(valid_580247, JBool, required = false,
                                 default = newJBool(true))
  if valid_580247 != nil:
    section.add "prettyPrint", valid_580247
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580248: Call_StorageObjectsDelete_580236; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes data blobs and associated metadata.
  ## 
  let valid = call_580248.validator(path, query, header, formData, body)
  let scheme = call_580248.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580248.url(scheme.get, call_580248.host, call_580248.base,
                         call_580248.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580248, url, valid)

proc call*(call_580249: Call_StorageObjectsDelete_580236; bucket: string;
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
  var path_580250 = newJObject()
  var query_580251 = newJObject()
  add(path_580250, "bucket", newJString(bucket))
  add(query_580251, "fields", newJString(fields))
  add(query_580251, "quotaUser", newJString(quotaUser))
  add(query_580251, "alt", newJString(alt))
  add(query_580251, "oauth_token", newJString(oauthToken))
  add(query_580251, "userIp", newJString(userIp))
  add(query_580251, "key", newJString(key))
  add(query_580251, "prettyPrint", newJBool(prettyPrint))
  add(path_580250, "object", newJString(`object`))
  result = call_580249.call(path_580250, query_580251, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_580236(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_580237, base: "/storage/v1beta1",
    url: url_StorageObjectsDelete_580238, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_580287 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsInsert_580289(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsInsert_580288(path: JsonNode;
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
  var valid_580290 = path.getOrDefault("bucket")
  valid_580290 = validateParameter(valid_580290, JString, required = true,
                                 default = nil)
  if valid_580290 != nil:
    section.add "bucket", valid_580290
  var valid_580291 = path.getOrDefault("object")
  valid_580291 = validateParameter(valid_580291, JString, required = true,
                                 default = nil)
  if valid_580291 != nil:
    section.add "object", valid_580291
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
  var valid_580292 = query.getOrDefault("fields")
  valid_580292 = validateParameter(valid_580292, JString, required = false,
                                 default = nil)
  if valid_580292 != nil:
    section.add "fields", valid_580292
  var valid_580293 = query.getOrDefault("quotaUser")
  valid_580293 = validateParameter(valid_580293, JString, required = false,
                                 default = nil)
  if valid_580293 != nil:
    section.add "quotaUser", valid_580293
  var valid_580294 = query.getOrDefault("alt")
  valid_580294 = validateParameter(valid_580294, JString, required = false,
                                 default = newJString("json"))
  if valid_580294 != nil:
    section.add "alt", valid_580294
  var valid_580295 = query.getOrDefault("oauth_token")
  valid_580295 = validateParameter(valid_580295, JString, required = false,
                                 default = nil)
  if valid_580295 != nil:
    section.add "oauth_token", valid_580295
  var valid_580296 = query.getOrDefault("userIp")
  valid_580296 = validateParameter(valid_580296, JString, required = false,
                                 default = nil)
  if valid_580296 != nil:
    section.add "userIp", valid_580296
  var valid_580297 = query.getOrDefault("key")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "key", valid_580297
  var valid_580298 = query.getOrDefault("prettyPrint")
  valid_580298 = validateParameter(valid_580298, JBool, required = false,
                                 default = newJBool(true))
  if valid_580298 != nil:
    section.add "prettyPrint", valid_580298
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

proc call*(call_580300: Call_StorageObjectAccessControlsInsert_580287;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_580300.validator(path, query, header, formData, body)
  let scheme = call_580300.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580300.url(scheme.get, call_580300.host, call_580300.base,
                         call_580300.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580300, url, valid)

proc call*(call_580301: Call_StorageObjectAccessControlsInsert_580287;
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
  var path_580302 = newJObject()
  var query_580303 = newJObject()
  var body_580304 = newJObject()
  add(path_580302, "bucket", newJString(bucket))
  add(query_580303, "fields", newJString(fields))
  add(query_580303, "quotaUser", newJString(quotaUser))
  add(query_580303, "alt", newJString(alt))
  add(query_580303, "oauth_token", newJString(oauthToken))
  add(query_580303, "userIp", newJString(userIp))
  add(query_580303, "key", newJString(key))
  if body != nil:
    body_580304 = body
  add(query_580303, "prettyPrint", newJBool(prettyPrint))
  add(path_580302, "object", newJString(`object`))
  result = call_580301.call(path_580302, query_580303, nil, nil, body_580304)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_580287(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_580288,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsInsert_580289,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_580271 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsList_580273(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsList_580272(path: JsonNode;
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
  var valid_580274 = path.getOrDefault("bucket")
  valid_580274 = validateParameter(valid_580274, JString, required = true,
                                 default = nil)
  if valid_580274 != nil:
    section.add "bucket", valid_580274
  var valid_580275 = path.getOrDefault("object")
  valid_580275 = validateParameter(valid_580275, JString, required = true,
                                 default = nil)
  if valid_580275 != nil:
    section.add "object", valid_580275
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
  var valid_580276 = query.getOrDefault("fields")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "fields", valid_580276
  var valid_580277 = query.getOrDefault("quotaUser")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "quotaUser", valid_580277
  var valid_580278 = query.getOrDefault("alt")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = newJString("json"))
  if valid_580278 != nil:
    section.add "alt", valid_580278
  var valid_580279 = query.getOrDefault("oauth_token")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = nil)
  if valid_580279 != nil:
    section.add "oauth_token", valid_580279
  var valid_580280 = query.getOrDefault("userIp")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "userIp", valid_580280
  var valid_580281 = query.getOrDefault("key")
  valid_580281 = validateParameter(valid_580281, JString, required = false,
                                 default = nil)
  if valid_580281 != nil:
    section.add "key", valid_580281
  var valid_580282 = query.getOrDefault("prettyPrint")
  valid_580282 = validateParameter(valid_580282, JBool, required = false,
                                 default = newJBool(true))
  if valid_580282 != nil:
    section.add "prettyPrint", valid_580282
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580283: Call_StorageObjectAccessControlsList_580271;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_580283.validator(path, query, header, formData, body)
  let scheme = call_580283.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580283.url(scheme.get, call_580283.host, call_580283.base,
                         call_580283.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580283, url, valid)

proc call*(call_580284: Call_StorageObjectAccessControlsList_580271;
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
  var path_580285 = newJObject()
  var query_580286 = newJObject()
  add(path_580285, "bucket", newJString(bucket))
  add(query_580286, "fields", newJString(fields))
  add(query_580286, "quotaUser", newJString(quotaUser))
  add(query_580286, "alt", newJString(alt))
  add(query_580286, "oauth_token", newJString(oauthToken))
  add(query_580286, "userIp", newJString(userIp))
  add(query_580286, "key", newJString(key))
  add(query_580286, "prettyPrint", newJBool(prettyPrint))
  add(path_580285, "object", newJString(`object`))
  result = call_580284.call(path_580285, query_580286, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_580271(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_580272,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsList_580273,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_580322 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsUpdate_580324(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsUpdate_580323(path: JsonNode;
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
  var valid_580325 = path.getOrDefault("bucket")
  valid_580325 = validateParameter(valid_580325, JString, required = true,
                                 default = nil)
  if valid_580325 != nil:
    section.add "bucket", valid_580325
  var valid_580326 = path.getOrDefault("entity")
  valid_580326 = validateParameter(valid_580326, JString, required = true,
                                 default = nil)
  if valid_580326 != nil:
    section.add "entity", valid_580326
  var valid_580327 = path.getOrDefault("object")
  valid_580327 = validateParameter(valid_580327, JString, required = true,
                                 default = nil)
  if valid_580327 != nil:
    section.add "object", valid_580327
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
  var valid_580328 = query.getOrDefault("fields")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "fields", valid_580328
  var valid_580329 = query.getOrDefault("quotaUser")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = nil)
  if valid_580329 != nil:
    section.add "quotaUser", valid_580329
  var valid_580330 = query.getOrDefault("alt")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = newJString("json"))
  if valid_580330 != nil:
    section.add "alt", valid_580330
  var valid_580331 = query.getOrDefault("oauth_token")
  valid_580331 = validateParameter(valid_580331, JString, required = false,
                                 default = nil)
  if valid_580331 != nil:
    section.add "oauth_token", valid_580331
  var valid_580332 = query.getOrDefault("userIp")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "userIp", valid_580332
  var valid_580333 = query.getOrDefault("key")
  valid_580333 = validateParameter(valid_580333, JString, required = false,
                                 default = nil)
  if valid_580333 != nil:
    section.add "key", valid_580333
  var valid_580334 = query.getOrDefault("prettyPrint")
  valid_580334 = validateParameter(valid_580334, JBool, required = false,
                                 default = newJBool(true))
  if valid_580334 != nil:
    section.add "prettyPrint", valid_580334
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

proc call*(call_580336: Call_StorageObjectAccessControlsUpdate_580322;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_580336.validator(path, query, header, formData, body)
  let scheme = call_580336.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580336.url(scheme.get, call_580336.host, call_580336.base,
                         call_580336.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580336, url, valid)

proc call*(call_580337: Call_StorageObjectAccessControlsUpdate_580322;
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
  var path_580338 = newJObject()
  var query_580339 = newJObject()
  var body_580340 = newJObject()
  add(path_580338, "bucket", newJString(bucket))
  add(query_580339, "fields", newJString(fields))
  add(query_580339, "quotaUser", newJString(quotaUser))
  add(query_580339, "alt", newJString(alt))
  add(query_580339, "oauth_token", newJString(oauthToken))
  add(query_580339, "userIp", newJString(userIp))
  add(query_580339, "key", newJString(key))
  if body != nil:
    body_580340 = body
  add(query_580339, "prettyPrint", newJBool(prettyPrint))
  add(path_580338, "entity", newJString(entity))
  add(path_580338, "object", newJString(`object`))
  result = call_580337.call(path_580338, query_580339, nil, nil, body_580340)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_580322(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_580323,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsUpdate_580324,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_580305 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsGet_580307(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsGet_580306(path: JsonNode;
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
  var valid_580308 = path.getOrDefault("bucket")
  valid_580308 = validateParameter(valid_580308, JString, required = true,
                                 default = nil)
  if valid_580308 != nil:
    section.add "bucket", valid_580308
  var valid_580309 = path.getOrDefault("entity")
  valid_580309 = validateParameter(valid_580309, JString, required = true,
                                 default = nil)
  if valid_580309 != nil:
    section.add "entity", valid_580309
  var valid_580310 = path.getOrDefault("object")
  valid_580310 = validateParameter(valid_580310, JString, required = true,
                                 default = nil)
  if valid_580310 != nil:
    section.add "object", valid_580310
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
  var valid_580311 = query.getOrDefault("fields")
  valid_580311 = validateParameter(valid_580311, JString, required = false,
                                 default = nil)
  if valid_580311 != nil:
    section.add "fields", valid_580311
  var valid_580312 = query.getOrDefault("quotaUser")
  valid_580312 = validateParameter(valid_580312, JString, required = false,
                                 default = nil)
  if valid_580312 != nil:
    section.add "quotaUser", valid_580312
  var valid_580313 = query.getOrDefault("alt")
  valid_580313 = validateParameter(valid_580313, JString, required = false,
                                 default = newJString("json"))
  if valid_580313 != nil:
    section.add "alt", valid_580313
  var valid_580314 = query.getOrDefault("oauth_token")
  valid_580314 = validateParameter(valid_580314, JString, required = false,
                                 default = nil)
  if valid_580314 != nil:
    section.add "oauth_token", valid_580314
  var valid_580315 = query.getOrDefault("userIp")
  valid_580315 = validateParameter(valid_580315, JString, required = false,
                                 default = nil)
  if valid_580315 != nil:
    section.add "userIp", valid_580315
  var valid_580316 = query.getOrDefault("key")
  valid_580316 = validateParameter(valid_580316, JString, required = false,
                                 default = nil)
  if valid_580316 != nil:
    section.add "key", valid_580316
  var valid_580317 = query.getOrDefault("prettyPrint")
  valid_580317 = validateParameter(valid_580317, JBool, required = false,
                                 default = newJBool(true))
  if valid_580317 != nil:
    section.add "prettyPrint", valid_580317
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580318: Call_StorageObjectAccessControlsGet_580305; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580318.validator(path, query, header, formData, body)
  let scheme = call_580318.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580318.url(scheme.get, call_580318.host, call_580318.base,
                         call_580318.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580318, url, valid)

proc call*(call_580319: Call_StorageObjectAccessControlsGet_580305; bucket: string;
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
  var path_580320 = newJObject()
  var query_580321 = newJObject()
  add(path_580320, "bucket", newJString(bucket))
  add(query_580321, "fields", newJString(fields))
  add(query_580321, "quotaUser", newJString(quotaUser))
  add(query_580321, "alt", newJString(alt))
  add(query_580321, "oauth_token", newJString(oauthToken))
  add(query_580321, "userIp", newJString(userIp))
  add(query_580321, "key", newJString(key))
  add(query_580321, "prettyPrint", newJBool(prettyPrint))
  add(path_580320, "entity", newJString(entity))
  add(path_580320, "object", newJString(`object`))
  result = call_580319.call(path_580320, query_580321, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_580305(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_580306,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsGet_580307,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_580358 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsPatch_580360(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsPatch_580359(path: JsonNode;
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
  var valid_580361 = path.getOrDefault("bucket")
  valid_580361 = validateParameter(valid_580361, JString, required = true,
                                 default = nil)
  if valid_580361 != nil:
    section.add "bucket", valid_580361
  var valid_580362 = path.getOrDefault("entity")
  valid_580362 = validateParameter(valid_580362, JString, required = true,
                                 default = nil)
  if valid_580362 != nil:
    section.add "entity", valid_580362
  var valid_580363 = path.getOrDefault("object")
  valid_580363 = validateParameter(valid_580363, JString, required = true,
                                 default = nil)
  if valid_580363 != nil:
    section.add "object", valid_580363
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
  var valid_580364 = query.getOrDefault("fields")
  valid_580364 = validateParameter(valid_580364, JString, required = false,
                                 default = nil)
  if valid_580364 != nil:
    section.add "fields", valid_580364
  var valid_580365 = query.getOrDefault("quotaUser")
  valid_580365 = validateParameter(valid_580365, JString, required = false,
                                 default = nil)
  if valid_580365 != nil:
    section.add "quotaUser", valid_580365
  var valid_580366 = query.getOrDefault("alt")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = newJString("json"))
  if valid_580366 != nil:
    section.add "alt", valid_580366
  var valid_580367 = query.getOrDefault("oauth_token")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "oauth_token", valid_580367
  var valid_580368 = query.getOrDefault("userIp")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "userIp", valid_580368
  var valid_580369 = query.getOrDefault("key")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = nil)
  if valid_580369 != nil:
    section.add "key", valid_580369
  var valid_580370 = query.getOrDefault("prettyPrint")
  valid_580370 = validateParameter(valid_580370, JBool, required = false,
                                 default = newJBool(true))
  if valid_580370 != nil:
    section.add "prettyPrint", valid_580370
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

proc call*(call_580372: Call_StorageObjectAccessControlsPatch_580358;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  let valid = call_580372.validator(path, query, header, formData, body)
  let scheme = call_580372.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580372.url(scheme.get, call_580372.host, call_580372.base,
                         call_580372.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580372, url, valid)

proc call*(call_580373: Call_StorageObjectAccessControlsPatch_580358;
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
  var path_580374 = newJObject()
  var query_580375 = newJObject()
  var body_580376 = newJObject()
  add(path_580374, "bucket", newJString(bucket))
  add(query_580375, "fields", newJString(fields))
  add(query_580375, "quotaUser", newJString(quotaUser))
  add(query_580375, "alt", newJString(alt))
  add(query_580375, "oauth_token", newJString(oauthToken))
  add(query_580375, "userIp", newJString(userIp))
  add(query_580375, "key", newJString(key))
  if body != nil:
    body_580376 = body
  add(query_580375, "prettyPrint", newJBool(prettyPrint))
  add(path_580374, "entity", newJString(entity))
  add(path_580374, "object", newJString(`object`))
  result = call_580373.call(path_580374, query_580375, nil, nil, body_580376)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_580358(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_580359,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsPatch_580360,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_580341 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsDelete_580343(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsDelete_580342(path: JsonNode;
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
  var valid_580344 = path.getOrDefault("bucket")
  valid_580344 = validateParameter(valid_580344, JString, required = true,
                                 default = nil)
  if valid_580344 != nil:
    section.add "bucket", valid_580344
  var valid_580345 = path.getOrDefault("entity")
  valid_580345 = validateParameter(valid_580345, JString, required = true,
                                 default = nil)
  if valid_580345 != nil:
    section.add "entity", valid_580345
  var valid_580346 = path.getOrDefault("object")
  valid_580346 = validateParameter(valid_580346, JString, required = true,
                                 default = nil)
  if valid_580346 != nil:
    section.add "object", valid_580346
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
  var valid_580347 = query.getOrDefault("fields")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = nil)
  if valid_580347 != nil:
    section.add "fields", valid_580347
  var valid_580348 = query.getOrDefault("quotaUser")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "quotaUser", valid_580348
  var valid_580349 = query.getOrDefault("alt")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = newJString("json"))
  if valid_580349 != nil:
    section.add "alt", valid_580349
  var valid_580350 = query.getOrDefault("oauth_token")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "oauth_token", valid_580350
  var valid_580351 = query.getOrDefault("userIp")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "userIp", valid_580351
  var valid_580352 = query.getOrDefault("key")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = nil)
  if valid_580352 != nil:
    section.add "key", valid_580352
  var valid_580353 = query.getOrDefault("prettyPrint")
  valid_580353 = validateParameter(valid_580353, JBool, required = false,
                                 default = newJBool(true))
  if valid_580353 != nil:
    section.add "prettyPrint", valid_580353
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580354: Call_StorageObjectAccessControlsDelete_580341;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580354.validator(path, query, header, formData, body)
  let scheme = call_580354.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580354.url(scheme.get, call_580354.host, call_580354.base,
                         call_580354.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580354, url, valid)

proc call*(call_580355: Call_StorageObjectAccessControlsDelete_580341;
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
  var path_580356 = newJObject()
  var query_580357 = newJObject()
  add(path_580356, "bucket", newJString(bucket))
  add(query_580357, "fields", newJString(fields))
  add(query_580357, "quotaUser", newJString(quotaUser))
  add(query_580357, "alt", newJString(alt))
  add(query_580357, "oauth_token", newJString(oauthToken))
  add(query_580357, "userIp", newJString(userIp))
  add(query_580357, "key", newJString(key))
  add(query_580357, "prettyPrint", newJBool(prettyPrint))
  add(path_580356, "entity", newJString(entity))
  add(path_580356, "object", newJString(`object`))
  result = call_580355.call(path_580356, query_580357, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_580341(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_580342,
    base: "/storage/v1beta1", url: url_StorageObjectAccessControlsDelete_580343,
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
