
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1beta2
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
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   project: JString (required)
  ##          : A valid API project identifier.
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
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579975 = query.getOrDefault("project")
  valid_579975 = validateParameter(valid_579975, JString, required = true,
                                 default = nil)
  if valid_579975 != nil:
    section.add "project", valid_579975
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

proc call*(call_579977: Call_StorageBucketsInsert_579964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_579977.validator(path, query, header, formData, body)
  let scheme = call_579977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_579977.url(scheme.get, call_579977.host, call_579977.base,
                         call_579977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_579977, url, valid)

proc call*(call_579978: Call_StorageBucketsInsert_579964; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   project: string (required)
  ##          : A valid API project identifier.
  var query_579979 = newJObject()
  var body_579980 = newJObject()
  add(query_579979, "fields", newJString(fields))
  add(query_579979, "quotaUser", newJString(quotaUser))
  add(query_579979, "alt", newJString(alt))
  add(query_579979, "oauth_token", newJString(oauthToken))
  add(query_579979, "userIp", newJString(userIp))
  add(query_579979, "key", newJString(key))
  add(query_579979, "projection", newJString(projection))
  if body != nil:
    body_579980 = body
  add(query_579979, "prettyPrint", newJBool(prettyPrint))
  add(query_579979, "project", newJString(project))
  result = call_579978.call(nil, query_579979, nil, nil, body_579980)

var storageBucketsInsert* = Call_StorageBucketsInsert_579964(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_579965, base: "/storage/v1beta2",
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
  ##   maxResults: JInt
  ##             : Maximum number of buckets to return.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   project: JString (required)
  ##          : A valid API project identifier.
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
  var valid_579825 = query.getOrDefault("maxResults")
  valid_579825 = validateParameter(valid_579825, JInt, required = false, default = nil)
  if valid_579825 != nil:
    section.add "maxResults", valid_579825
  var valid_579826 = query.getOrDefault("key")
  valid_579826 = validateParameter(valid_579826, JString, required = false,
                                 default = nil)
  if valid_579826 != nil:
    section.add "key", valid_579826
  var valid_579827 = query.getOrDefault("projection")
  valid_579827 = validateParameter(valid_579827, JString, required = false,
                                 default = newJString("full"))
  if valid_579827 != nil:
    section.add "projection", valid_579827
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_579828 = query.getOrDefault("project")
  valid_579828 = validateParameter(valid_579828, JString, required = true,
                                 default = nil)
  if valid_579828 != nil:
    section.add "project", valid_579828
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

proc call*(call_579923: Call_StorageBucketsList_579692; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 0; key: string = ""; projection: string = "full";
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
  ##   maxResults: int
  ##             : Maximum number of buckets to return.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_579924 = newJObject()
  add(query_579924, "fields", newJString(fields))
  add(query_579924, "pageToken", newJString(pageToken))
  add(query_579924, "quotaUser", newJString(quotaUser))
  add(query_579924, "alt", newJString(alt))
  add(query_579924, "oauth_token", newJString(oauthToken))
  add(query_579924, "userIp", newJString(userIp))
  add(query_579924, "maxResults", newJInt(maxResults))
  add(query_579924, "key", newJString(key))
  add(query_579924, "projection", newJString(projection))
  add(query_579924, "project", newJString(project))
  add(query_579924, "prettyPrint", newJBool(prettyPrint))
  result = call_579923.call(nil, query_579924, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_579692(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsList_579693, base: "/storage/v1beta2",
    url: url_StorageBucketsList_579694, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_580013 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsUpdate_580015(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsUpdate_580014(path: JsonNode; query: JsonNode;
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
  var valid_580016 = path.getOrDefault("bucket")
  valid_580016 = validateParameter(valid_580016, JString, required = true,
                                 default = nil)
  if valid_580016 != nil:
    section.add "bucket", valid_580016
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  section = newJObject()
  var valid_580017 = query.getOrDefault("fields")
  valid_580017 = validateParameter(valid_580017, JString, required = false,
                                 default = nil)
  if valid_580017 != nil:
    section.add "fields", valid_580017
  var valid_580018 = query.getOrDefault("quotaUser")
  valid_580018 = validateParameter(valid_580018, JString, required = false,
                                 default = nil)
  if valid_580018 != nil:
    section.add "quotaUser", valid_580018
  var valid_580019 = query.getOrDefault("alt")
  valid_580019 = validateParameter(valid_580019, JString, required = false,
                                 default = newJString("json"))
  if valid_580019 != nil:
    section.add "alt", valid_580019
  var valid_580020 = query.getOrDefault("oauth_token")
  valid_580020 = validateParameter(valid_580020, JString, required = false,
                                 default = nil)
  if valid_580020 != nil:
    section.add "oauth_token", valid_580020
  var valid_580021 = query.getOrDefault("userIp")
  valid_580021 = validateParameter(valid_580021, JString, required = false,
                                 default = nil)
  if valid_580021 != nil:
    section.add "userIp", valid_580021
  var valid_580022 = query.getOrDefault("key")
  valid_580022 = validateParameter(valid_580022, JString, required = false,
                                 default = nil)
  if valid_580022 != nil:
    section.add "key", valid_580022
  var valid_580023 = query.getOrDefault("projection")
  valid_580023 = validateParameter(valid_580023, JString, required = false,
                                 default = newJString("full"))
  if valid_580023 != nil:
    section.add "projection", valid_580023
  var valid_580024 = query.getOrDefault("ifMetagenerationMatch")
  valid_580024 = validateParameter(valid_580024, JString, required = false,
                                 default = nil)
  if valid_580024 != nil:
    section.add "ifMetagenerationMatch", valid_580024
  var valid_580025 = query.getOrDefault("prettyPrint")
  valid_580025 = validateParameter(valid_580025, JBool, required = false,
                                 default = newJBool(true))
  if valid_580025 != nil:
    section.add "prettyPrint", valid_580025
  var valid_580026 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580026 = validateParameter(valid_580026, JString, required = false,
                                 default = nil)
  if valid_580026 != nil:
    section.add "ifMetagenerationNotMatch", valid_580026
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

proc call*(call_580028: Call_StorageBucketsUpdate_580013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket.
  ## 
  let valid = call_580028.validator(path, query, header, formData, body)
  let scheme = call_580028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580028.url(scheme.get, call_580028.host, call_580028.base,
                         call_580028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580028, url, valid)

proc call*(call_580029: Call_StorageBucketsUpdate_580013; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; ifMetagenerationMatch: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""): Recallable =
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
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  var path_580030 = newJObject()
  var query_580031 = newJObject()
  var body_580032 = newJObject()
  add(path_580030, "bucket", newJString(bucket))
  add(query_580031, "fields", newJString(fields))
  add(query_580031, "quotaUser", newJString(quotaUser))
  add(query_580031, "alt", newJString(alt))
  add(query_580031, "oauth_token", newJString(oauthToken))
  add(query_580031, "userIp", newJString(userIp))
  add(query_580031, "key", newJString(key))
  add(query_580031, "projection", newJString(projection))
  add(query_580031, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580032 = body
  add(query_580031, "prettyPrint", newJBool(prettyPrint))
  add(query_580031, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_580029.call(path_580030, query_580031, nil, nil, body_580032)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_580013(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_580014, base: "/storage/v1beta2",
    url: url_StorageBucketsUpdate_580015, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_579981 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsGet_579983(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsGet_579982(path: JsonNode; query: JsonNode;
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
  var valid_579998 = path.getOrDefault("bucket")
  valid_579998 = validateParameter(valid_579998, JString, required = true,
                                 default = nil)
  if valid_579998 != nil:
    section.add "bucket", valid_579998
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
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  section = newJObject()
  var valid_579999 = query.getOrDefault("fields")
  valid_579999 = validateParameter(valid_579999, JString, required = false,
                                 default = nil)
  if valid_579999 != nil:
    section.add "fields", valid_579999
  var valid_580000 = query.getOrDefault("quotaUser")
  valid_580000 = validateParameter(valid_580000, JString, required = false,
                                 default = nil)
  if valid_580000 != nil:
    section.add "quotaUser", valid_580000
  var valid_580001 = query.getOrDefault("alt")
  valid_580001 = validateParameter(valid_580001, JString, required = false,
                                 default = newJString("json"))
  if valid_580001 != nil:
    section.add "alt", valid_580001
  var valid_580002 = query.getOrDefault("oauth_token")
  valid_580002 = validateParameter(valid_580002, JString, required = false,
                                 default = nil)
  if valid_580002 != nil:
    section.add "oauth_token", valid_580002
  var valid_580003 = query.getOrDefault("userIp")
  valid_580003 = validateParameter(valid_580003, JString, required = false,
                                 default = nil)
  if valid_580003 != nil:
    section.add "userIp", valid_580003
  var valid_580004 = query.getOrDefault("key")
  valid_580004 = validateParameter(valid_580004, JString, required = false,
                                 default = nil)
  if valid_580004 != nil:
    section.add "key", valid_580004
  var valid_580005 = query.getOrDefault("projection")
  valid_580005 = validateParameter(valid_580005, JString, required = false,
                                 default = newJString("full"))
  if valid_580005 != nil:
    section.add "projection", valid_580005
  var valid_580006 = query.getOrDefault("ifMetagenerationMatch")
  valid_580006 = validateParameter(valid_580006, JString, required = false,
                                 default = nil)
  if valid_580006 != nil:
    section.add "ifMetagenerationMatch", valid_580006
  var valid_580007 = query.getOrDefault("prettyPrint")
  valid_580007 = validateParameter(valid_580007, JBool, required = false,
                                 default = newJBool(true))
  if valid_580007 != nil:
    section.add "prettyPrint", valid_580007
  var valid_580008 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580008 = validateParameter(valid_580008, JString, required = false,
                                 default = nil)
  if valid_580008 != nil:
    section.add "ifMetagenerationNotMatch", valid_580008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580009: Call_StorageBucketsGet_579981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_580009.validator(path, query, header, formData, body)
  let scheme = call_580009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580009.url(scheme.get, call_580009.host, call_580009.base,
                         call_580009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580009, url, valid)

proc call*(call_580010: Call_StorageBucketsGet_579981; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; ifMetagenerationMatch: string = "";
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = ""): Recallable =
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
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  var path_580011 = newJObject()
  var query_580012 = newJObject()
  add(path_580011, "bucket", newJString(bucket))
  add(query_580012, "fields", newJString(fields))
  add(query_580012, "quotaUser", newJString(quotaUser))
  add(query_580012, "alt", newJString(alt))
  add(query_580012, "oauth_token", newJString(oauthToken))
  add(query_580012, "userIp", newJString(userIp))
  add(query_580012, "key", newJString(key))
  add(query_580012, "projection", newJString(projection))
  add(query_580012, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580012, "prettyPrint", newJBool(prettyPrint))
  add(query_580012, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_580010.call(path_580011, query_580012, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_579981(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_579982, base: "/storage/v1beta2",
    url: url_StorageBucketsGet_579983, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_580050 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsPatch_580052(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsPatch_580051(path: JsonNode; query: JsonNode;
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
  var valid_580053 = path.getOrDefault("bucket")
  valid_580053 = validateParameter(valid_580053, JString, required = true,
                                 default = nil)
  if valid_580053 != nil:
    section.add "bucket", valid_580053
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  section = newJObject()
  var valid_580054 = query.getOrDefault("fields")
  valid_580054 = validateParameter(valid_580054, JString, required = false,
                                 default = nil)
  if valid_580054 != nil:
    section.add "fields", valid_580054
  var valid_580055 = query.getOrDefault("quotaUser")
  valid_580055 = validateParameter(valid_580055, JString, required = false,
                                 default = nil)
  if valid_580055 != nil:
    section.add "quotaUser", valid_580055
  var valid_580056 = query.getOrDefault("alt")
  valid_580056 = validateParameter(valid_580056, JString, required = false,
                                 default = newJString("json"))
  if valid_580056 != nil:
    section.add "alt", valid_580056
  var valid_580057 = query.getOrDefault("oauth_token")
  valid_580057 = validateParameter(valid_580057, JString, required = false,
                                 default = nil)
  if valid_580057 != nil:
    section.add "oauth_token", valid_580057
  var valid_580058 = query.getOrDefault("userIp")
  valid_580058 = validateParameter(valid_580058, JString, required = false,
                                 default = nil)
  if valid_580058 != nil:
    section.add "userIp", valid_580058
  var valid_580059 = query.getOrDefault("key")
  valid_580059 = validateParameter(valid_580059, JString, required = false,
                                 default = nil)
  if valid_580059 != nil:
    section.add "key", valid_580059
  var valid_580060 = query.getOrDefault("projection")
  valid_580060 = validateParameter(valid_580060, JString, required = false,
                                 default = newJString("full"))
  if valid_580060 != nil:
    section.add "projection", valid_580060
  var valid_580061 = query.getOrDefault("ifMetagenerationMatch")
  valid_580061 = validateParameter(valid_580061, JString, required = false,
                                 default = nil)
  if valid_580061 != nil:
    section.add "ifMetagenerationMatch", valid_580061
  var valid_580062 = query.getOrDefault("prettyPrint")
  valid_580062 = validateParameter(valid_580062, JBool, required = false,
                                 default = newJBool(true))
  if valid_580062 != nil:
    section.add "prettyPrint", valid_580062
  var valid_580063 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580063 = validateParameter(valid_580063, JString, required = false,
                                 default = nil)
  if valid_580063 != nil:
    section.add "ifMetagenerationNotMatch", valid_580063
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

proc call*(call_580065: Call_StorageBucketsPatch_580050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  let valid = call_580065.validator(path, query, header, formData, body)
  let scheme = call_580065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580065.url(scheme.get, call_580065.host, call_580065.base,
                         call_580065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580065, url, valid)

proc call*(call_580066: Call_StorageBucketsPatch_580050; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; ifMetagenerationMatch: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""): Recallable =
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
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  var path_580067 = newJObject()
  var query_580068 = newJObject()
  var body_580069 = newJObject()
  add(path_580067, "bucket", newJString(bucket))
  add(query_580068, "fields", newJString(fields))
  add(query_580068, "quotaUser", newJString(quotaUser))
  add(query_580068, "alt", newJString(alt))
  add(query_580068, "oauth_token", newJString(oauthToken))
  add(query_580068, "userIp", newJString(userIp))
  add(query_580068, "key", newJString(key))
  add(query_580068, "projection", newJString(projection))
  add(query_580068, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580069 = body
  add(query_580068, "prettyPrint", newJBool(prettyPrint))
  add(query_580068, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_580066.call(path_580067, query_580068, nil, nil, body_580069)

var storageBucketsPatch* = Call_StorageBucketsPatch_580050(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_580051, base: "/storage/v1beta2",
    url: url_StorageBucketsPatch_580052, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_580033 = ref object of OpenApiRestCall_579424
proc url_StorageBucketsDelete_580035(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsDelete_580034(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes an empty bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580036 = path.getOrDefault("bucket")
  valid_580036 = validateParameter(valid_580036, JString, required = true,
                                 default = nil)
  if valid_580036 != nil:
    section.add "bucket", valid_580036
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  section = newJObject()
  var valid_580037 = query.getOrDefault("fields")
  valid_580037 = validateParameter(valid_580037, JString, required = false,
                                 default = nil)
  if valid_580037 != nil:
    section.add "fields", valid_580037
  var valid_580038 = query.getOrDefault("quotaUser")
  valid_580038 = validateParameter(valid_580038, JString, required = false,
                                 default = nil)
  if valid_580038 != nil:
    section.add "quotaUser", valid_580038
  var valid_580039 = query.getOrDefault("alt")
  valid_580039 = validateParameter(valid_580039, JString, required = false,
                                 default = newJString("json"))
  if valid_580039 != nil:
    section.add "alt", valid_580039
  var valid_580040 = query.getOrDefault("oauth_token")
  valid_580040 = validateParameter(valid_580040, JString, required = false,
                                 default = nil)
  if valid_580040 != nil:
    section.add "oauth_token", valid_580040
  var valid_580041 = query.getOrDefault("userIp")
  valid_580041 = validateParameter(valid_580041, JString, required = false,
                                 default = nil)
  if valid_580041 != nil:
    section.add "userIp", valid_580041
  var valid_580042 = query.getOrDefault("key")
  valid_580042 = validateParameter(valid_580042, JString, required = false,
                                 default = nil)
  if valid_580042 != nil:
    section.add "key", valid_580042
  var valid_580043 = query.getOrDefault("ifMetagenerationMatch")
  valid_580043 = validateParameter(valid_580043, JString, required = false,
                                 default = nil)
  if valid_580043 != nil:
    section.add "ifMetagenerationMatch", valid_580043
  var valid_580044 = query.getOrDefault("prettyPrint")
  valid_580044 = validateParameter(valid_580044, JBool, required = false,
                                 default = newJBool(true))
  if valid_580044 != nil:
    section.add "prettyPrint", valid_580044
  var valid_580045 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580045 = validateParameter(valid_580045, JString, required = false,
                                 default = nil)
  if valid_580045 != nil:
    section.add "ifMetagenerationNotMatch", valid_580045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580046: Call_StorageBucketsDelete_580033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_580046.validator(path, query, header, formData, body)
  let scheme = call_580046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580046.url(scheme.get, call_580046.host, call_580046.base,
                         call_580046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580046, url, valid)

proc call*(call_580047: Call_StorageBucketsDelete_580033; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; key: string = "";
          ifMetagenerationMatch: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageBucketsDelete
  ## Permanently deletes an empty bucket.
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
  ##   ifMetagenerationMatch: string
  ##                        : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the return of the bucket metadata conditional on whether the bucket's current metageneration does not match the given value.
  var path_580048 = newJObject()
  var query_580049 = newJObject()
  add(path_580048, "bucket", newJString(bucket))
  add(query_580049, "fields", newJString(fields))
  add(query_580049, "quotaUser", newJString(quotaUser))
  add(query_580049, "alt", newJString(alt))
  add(query_580049, "oauth_token", newJString(oauthToken))
  add(query_580049, "userIp", newJString(userIp))
  add(query_580049, "key", newJString(key))
  add(query_580049, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580049, "prettyPrint", newJBool(prettyPrint))
  add(query_580049, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_580047.call(path_580048, query_580049, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_580033(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_580034, base: "/storage/v1beta2",
    url: url_StorageBucketsDelete_580035, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_580085 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsInsert_580087(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsInsert_580086(path: JsonNode;
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
  var valid_580088 = path.getOrDefault("bucket")
  valid_580088 = validateParameter(valid_580088, JString, required = true,
                                 default = nil)
  if valid_580088 != nil:
    section.add "bucket", valid_580088
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
  var valid_580089 = query.getOrDefault("fields")
  valid_580089 = validateParameter(valid_580089, JString, required = false,
                                 default = nil)
  if valid_580089 != nil:
    section.add "fields", valid_580089
  var valid_580090 = query.getOrDefault("quotaUser")
  valid_580090 = validateParameter(valid_580090, JString, required = false,
                                 default = nil)
  if valid_580090 != nil:
    section.add "quotaUser", valid_580090
  var valid_580091 = query.getOrDefault("alt")
  valid_580091 = validateParameter(valid_580091, JString, required = false,
                                 default = newJString("json"))
  if valid_580091 != nil:
    section.add "alt", valid_580091
  var valid_580092 = query.getOrDefault("oauth_token")
  valid_580092 = validateParameter(valid_580092, JString, required = false,
                                 default = nil)
  if valid_580092 != nil:
    section.add "oauth_token", valid_580092
  var valid_580093 = query.getOrDefault("userIp")
  valid_580093 = validateParameter(valid_580093, JString, required = false,
                                 default = nil)
  if valid_580093 != nil:
    section.add "userIp", valid_580093
  var valid_580094 = query.getOrDefault("key")
  valid_580094 = validateParameter(valid_580094, JString, required = false,
                                 default = nil)
  if valid_580094 != nil:
    section.add "key", valid_580094
  var valid_580095 = query.getOrDefault("prettyPrint")
  valid_580095 = validateParameter(valid_580095, JBool, required = false,
                                 default = newJBool(true))
  if valid_580095 != nil:
    section.add "prettyPrint", valid_580095
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

proc call*(call_580097: Call_StorageBucketAccessControlsInsert_580085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_580097.validator(path, query, header, formData, body)
  let scheme = call_580097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580097.url(scheme.get, call_580097.host, call_580097.base,
                         call_580097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580097, url, valid)

proc call*(call_580098: Call_StorageBucketAccessControlsInsert_580085;
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
  var path_580099 = newJObject()
  var query_580100 = newJObject()
  var body_580101 = newJObject()
  add(path_580099, "bucket", newJString(bucket))
  add(query_580100, "fields", newJString(fields))
  add(query_580100, "quotaUser", newJString(quotaUser))
  add(query_580100, "alt", newJString(alt))
  add(query_580100, "oauth_token", newJString(oauthToken))
  add(query_580100, "userIp", newJString(userIp))
  add(query_580100, "key", newJString(key))
  if body != nil:
    body_580101 = body
  add(query_580100, "prettyPrint", newJBool(prettyPrint))
  result = call_580098.call(path_580099, query_580100, nil, nil, body_580101)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_580085(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_580086,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsInsert_580087,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_580070 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsList_580072(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsList_580071(path: JsonNode;
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
  var valid_580073 = path.getOrDefault("bucket")
  valid_580073 = validateParameter(valid_580073, JString, required = true,
                                 default = nil)
  if valid_580073 != nil:
    section.add "bucket", valid_580073
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
  var valid_580078 = query.getOrDefault("userIp")
  valid_580078 = validateParameter(valid_580078, JString, required = false,
                                 default = nil)
  if valid_580078 != nil:
    section.add "userIp", valid_580078
  var valid_580079 = query.getOrDefault("key")
  valid_580079 = validateParameter(valid_580079, JString, required = false,
                                 default = nil)
  if valid_580079 != nil:
    section.add "key", valid_580079
  var valid_580080 = query.getOrDefault("prettyPrint")
  valid_580080 = validateParameter(valid_580080, JBool, required = false,
                                 default = newJBool(true))
  if valid_580080 != nil:
    section.add "prettyPrint", valid_580080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580081: Call_StorageBucketAccessControlsList_580070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_580081.validator(path, query, header, formData, body)
  let scheme = call_580081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580081.url(scheme.get, call_580081.host, call_580081.base,
                         call_580081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580081, url, valid)

proc call*(call_580082: Call_StorageBucketAccessControlsList_580070;
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
  var path_580083 = newJObject()
  var query_580084 = newJObject()
  add(path_580083, "bucket", newJString(bucket))
  add(query_580084, "fields", newJString(fields))
  add(query_580084, "quotaUser", newJString(quotaUser))
  add(query_580084, "alt", newJString(alt))
  add(query_580084, "oauth_token", newJString(oauthToken))
  add(query_580084, "userIp", newJString(userIp))
  add(query_580084, "key", newJString(key))
  add(query_580084, "prettyPrint", newJBool(prettyPrint))
  result = call_580082.call(path_580083, query_580084, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_580070(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_580071,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsList_580072,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_580118 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsUpdate_580120(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsUpdate_580119(path: JsonNode;
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
  var valid_580121 = path.getOrDefault("bucket")
  valid_580121 = validateParameter(valid_580121, JString, required = true,
                                 default = nil)
  if valid_580121 != nil:
    section.add "bucket", valid_580121
  var valid_580122 = path.getOrDefault("entity")
  valid_580122 = validateParameter(valid_580122, JString, required = true,
                                 default = nil)
  if valid_580122 != nil:
    section.add "entity", valid_580122
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
  var valid_580123 = query.getOrDefault("fields")
  valid_580123 = validateParameter(valid_580123, JString, required = false,
                                 default = nil)
  if valid_580123 != nil:
    section.add "fields", valid_580123
  var valid_580124 = query.getOrDefault("quotaUser")
  valid_580124 = validateParameter(valid_580124, JString, required = false,
                                 default = nil)
  if valid_580124 != nil:
    section.add "quotaUser", valid_580124
  var valid_580125 = query.getOrDefault("alt")
  valid_580125 = validateParameter(valid_580125, JString, required = false,
                                 default = newJString("json"))
  if valid_580125 != nil:
    section.add "alt", valid_580125
  var valid_580126 = query.getOrDefault("oauth_token")
  valid_580126 = validateParameter(valid_580126, JString, required = false,
                                 default = nil)
  if valid_580126 != nil:
    section.add "oauth_token", valid_580126
  var valid_580127 = query.getOrDefault("userIp")
  valid_580127 = validateParameter(valid_580127, JString, required = false,
                                 default = nil)
  if valid_580127 != nil:
    section.add "userIp", valid_580127
  var valid_580128 = query.getOrDefault("key")
  valid_580128 = validateParameter(valid_580128, JString, required = false,
                                 default = nil)
  if valid_580128 != nil:
    section.add "key", valid_580128
  var valid_580129 = query.getOrDefault("prettyPrint")
  valid_580129 = validateParameter(valid_580129, JBool, required = false,
                                 default = newJBool(true))
  if valid_580129 != nil:
    section.add "prettyPrint", valid_580129
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

proc call*(call_580131: Call_StorageBucketAccessControlsUpdate_580118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_580131.validator(path, query, header, formData, body)
  let scheme = call_580131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580131.url(scheme.get, call_580131.host, call_580131.base,
                         call_580131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580131, url, valid)

proc call*(call_580132: Call_StorageBucketAccessControlsUpdate_580118;
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
  var path_580133 = newJObject()
  var query_580134 = newJObject()
  var body_580135 = newJObject()
  add(path_580133, "bucket", newJString(bucket))
  add(query_580134, "fields", newJString(fields))
  add(query_580134, "quotaUser", newJString(quotaUser))
  add(query_580134, "alt", newJString(alt))
  add(query_580134, "oauth_token", newJString(oauthToken))
  add(query_580134, "userIp", newJString(userIp))
  add(query_580134, "key", newJString(key))
  if body != nil:
    body_580135 = body
  add(query_580134, "prettyPrint", newJBool(prettyPrint))
  add(path_580133, "entity", newJString(entity))
  result = call_580132.call(path_580133, query_580134, nil, nil, body_580135)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_580118(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_580119,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsUpdate_580120,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_580102 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsGet_580104(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsGet_580103(path: JsonNode;
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
  var valid_580105 = path.getOrDefault("bucket")
  valid_580105 = validateParameter(valid_580105, JString, required = true,
                                 default = nil)
  if valid_580105 != nil:
    section.add "bucket", valid_580105
  var valid_580106 = path.getOrDefault("entity")
  valid_580106 = validateParameter(valid_580106, JString, required = true,
                                 default = nil)
  if valid_580106 != nil:
    section.add "entity", valid_580106
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
  var valid_580107 = query.getOrDefault("fields")
  valid_580107 = validateParameter(valid_580107, JString, required = false,
                                 default = nil)
  if valid_580107 != nil:
    section.add "fields", valid_580107
  var valid_580108 = query.getOrDefault("quotaUser")
  valid_580108 = validateParameter(valid_580108, JString, required = false,
                                 default = nil)
  if valid_580108 != nil:
    section.add "quotaUser", valid_580108
  var valid_580109 = query.getOrDefault("alt")
  valid_580109 = validateParameter(valid_580109, JString, required = false,
                                 default = newJString("json"))
  if valid_580109 != nil:
    section.add "alt", valid_580109
  var valid_580110 = query.getOrDefault("oauth_token")
  valid_580110 = validateParameter(valid_580110, JString, required = false,
                                 default = nil)
  if valid_580110 != nil:
    section.add "oauth_token", valid_580110
  var valid_580111 = query.getOrDefault("userIp")
  valid_580111 = validateParameter(valid_580111, JString, required = false,
                                 default = nil)
  if valid_580111 != nil:
    section.add "userIp", valid_580111
  var valid_580112 = query.getOrDefault("key")
  valid_580112 = validateParameter(valid_580112, JString, required = false,
                                 default = nil)
  if valid_580112 != nil:
    section.add "key", valid_580112
  var valid_580113 = query.getOrDefault("prettyPrint")
  valid_580113 = validateParameter(valid_580113, JBool, required = false,
                                 default = newJBool(true))
  if valid_580113 != nil:
    section.add "prettyPrint", valid_580113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580114: Call_StorageBucketAccessControlsGet_580102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580114.validator(path, query, header, formData, body)
  let scheme = call_580114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580114.url(scheme.get, call_580114.host, call_580114.base,
                         call_580114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580114, url, valid)

proc call*(call_580115: Call_StorageBucketAccessControlsGet_580102; bucket: string;
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
  var path_580116 = newJObject()
  var query_580117 = newJObject()
  add(path_580116, "bucket", newJString(bucket))
  add(query_580117, "fields", newJString(fields))
  add(query_580117, "quotaUser", newJString(quotaUser))
  add(query_580117, "alt", newJString(alt))
  add(query_580117, "oauth_token", newJString(oauthToken))
  add(query_580117, "userIp", newJString(userIp))
  add(query_580117, "key", newJString(key))
  add(query_580117, "prettyPrint", newJBool(prettyPrint))
  add(path_580116, "entity", newJString(entity))
  result = call_580115.call(path_580116, query_580117, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_580102(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_580103,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsGet_580104,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_580152 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsPatch_580154(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsPatch_580153(path: JsonNode;
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
  var valid_580155 = path.getOrDefault("bucket")
  valid_580155 = validateParameter(valid_580155, JString, required = true,
                                 default = nil)
  if valid_580155 != nil:
    section.add "bucket", valid_580155
  var valid_580156 = path.getOrDefault("entity")
  valid_580156 = validateParameter(valid_580156, JString, required = true,
                                 default = nil)
  if valid_580156 != nil:
    section.add "entity", valid_580156
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
  var valid_580157 = query.getOrDefault("fields")
  valid_580157 = validateParameter(valid_580157, JString, required = false,
                                 default = nil)
  if valid_580157 != nil:
    section.add "fields", valid_580157
  var valid_580158 = query.getOrDefault("quotaUser")
  valid_580158 = validateParameter(valid_580158, JString, required = false,
                                 default = nil)
  if valid_580158 != nil:
    section.add "quotaUser", valid_580158
  var valid_580159 = query.getOrDefault("alt")
  valid_580159 = validateParameter(valid_580159, JString, required = false,
                                 default = newJString("json"))
  if valid_580159 != nil:
    section.add "alt", valid_580159
  var valid_580160 = query.getOrDefault("oauth_token")
  valid_580160 = validateParameter(valid_580160, JString, required = false,
                                 default = nil)
  if valid_580160 != nil:
    section.add "oauth_token", valid_580160
  var valid_580161 = query.getOrDefault("userIp")
  valid_580161 = validateParameter(valid_580161, JString, required = false,
                                 default = nil)
  if valid_580161 != nil:
    section.add "userIp", valid_580161
  var valid_580162 = query.getOrDefault("key")
  valid_580162 = validateParameter(valid_580162, JString, required = false,
                                 default = nil)
  if valid_580162 != nil:
    section.add "key", valid_580162
  var valid_580163 = query.getOrDefault("prettyPrint")
  valid_580163 = validateParameter(valid_580163, JBool, required = false,
                                 default = newJBool(true))
  if valid_580163 != nil:
    section.add "prettyPrint", valid_580163
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

proc call*(call_580165: Call_StorageBucketAccessControlsPatch_580152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_580165.validator(path, query, header, formData, body)
  let scheme = call_580165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580165.url(scheme.get, call_580165.host, call_580165.base,
                         call_580165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580165, url, valid)

proc call*(call_580166: Call_StorageBucketAccessControlsPatch_580152;
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
  var path_580167 = newJObject()
  var query_580168 = newJObject()
  var body_580169 = newJObject()
  add(path_580167, "bucket", newJString(bucket))
  add(query_580168, "fields", newJString(fields))
  add(query_580168, "quotaUser", newJString(quotaUser))
  add(query_580168, "alt", newJString(alt))
  add(query_580168, "oauth_token", newJString(oauthToken))
  add(query_580168, "userIp", newJString(userIp))
  add(query_580168, "key", newJString(key))
  if body != nil:
    body_580169 = body
  add(query_580168, "prettyPrint", newJBool(prettyPrint))
  add(path_580167, "entity", newJString(entity))
  result = call_580166.call(path_580167, query_580168, nil, nil, body_580169)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_580152(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_580153,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsPatch_580154,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_580136 = ref object of OpenApiRestCall_579424
proc url_StorageBucketAccessControlsDelete_580138(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsDelete_580137(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
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
  var valid_580139 = path.getOrDefault("bucket")
  valid_580139 = validateParameter(valid_580139, JString, required = true,
                                 default = nil)
  if valid_580139 != nil:
    section.add "bucket", valid_580139
  var valid_580140 = path.getOrDefault("entity")
  valid_580140 = validateParameter(valid_580140, JString, required = true,
                                 default = nil)
  if valid_580140 != nil:
    section.add "entity", valid_580140
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
  var valid_580141 = query.getOrDefault("fields")
  valid_580141 = validateParameter(valid_580141, JString, required = false,
                                 default = nil)
  if valid_580141 != nil:
    section.add "fields", valid_580141
  var valid_580142 = query.getOrDefault("quotaUser")
  valid_580142 = validateParameter(valid_580142, JString, required = false,
                                 default = nil)
  if valid_580142 != nil:
    section.add "quotaUser", valid_580142
  var valid_580143 = query.getOrDefault("alt")
  valid_580143 = validateParameter(valid_580143, JString, required = false,
                                 default = newJString("json"))
  if valid_580143 != nil:
    section.add "alt", valid_580143
  var valid_580144 = query.getOrDefault("oauth_token")
  valid_580144 = validateParameter(valid_580144, JString, required = false,
                                 default = nil)
  if valid_580144 != nil:
    section.add "oauth_token", valid_580144
  var valid_580145 = query.getOrDefault("userIp")
  valid_580145 = validateParameter(valid_580145, JString, required = false,
                                 default = nil)
  if valid_580145 != nil:
    section.add "userIp", valid_580145
  var valid_580146 = query.getOrDefault("key")
  valid_580146 = validateParameter(valid_580146, JString, required = false,
                                 default = nil)
  if valid_580146 != nil:
    section.add "key", valid_580146
  var valid_580147 = query.getOrDefault("prettyPrint")
  valid_580147 = validateParameter(valid_580147, JBool, required = false,
                                 default = newJBool(true))
  if valid_580147 != nil:
    section.add "prettyPrint", valid_580147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580148: Call_StorageBucketAccessControlsDelete_580136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580148.validator(path, query, header, formData, body)
  let scheme = call_580148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580148.url(scheme.get, call_580148.host, call_580148.base,
                         call_580148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580148, url, valid)

proc call*(call_580149: Call_StorageBucketAccessControlsDelete_580136;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageBucketAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
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
  var path_580150 = newJObject()
  var query_580151 = newJObject()
  add(path_580150, "bucket", newJString(bucket))
  add(query_580151, "fields", newJString(fields))
  add(query_580151, "quotaUser", newJString(quotaUser))
  add(query_580151, "alt", newJString(alt))
  add(query_580151, "oauth_token", newJString(oauthToken))
  add(query_580151, "userIp", newJString(userIp))
  add(query_580151, "key", newJString(key))
  add(query_580151, "prettyPrint", newJBool(prettyPrint))
  add(path_580150, "entity", newJString(entity))
  result = call_580149.call(path_580150, query_580151, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_580136(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_580137,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsDelete_580138,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_580187 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsInsert_580189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsInsert_580188(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580190 = path.getOrDefault("bucket")
  valid_580190 = validateParameter(valid_580190, JString, required = true,
                                 default = nil)
  if valid_580190 != nil:
    section.add "bucket", valid_580190
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
  var valid_580191 = query.getOrDefault("fields")
  valid_580191 = validateParameter(valid_580191, JString, required = false,
                                 default = nil)
  if valid_580191 != nil:
    section.add "fields", valid_580191
  var valid_580192 = query.getOrDefault("quotaUser")
  valid_580192 = validateParameter(valid_580192, JString, required = false,
                                 default = nil)
  if valid_580192 != nil:
    section.add "quotaUser", valid_580192
  var valid_580193 = query.getOrDefault("alt")
  valid_580193 = validateParameter(valid_580193, JString, required = false,
                                 default = newJString("json"))
  if valid_580193 != nil:
    section.add "alt", valid_580193
  var valid_580194 = query.getOrDefault("oauth_token")
  valid_580194 = validateParameter(valid_580194, JString, required = false,
                                 default = nil)
  if valid_580194 != nil:
    section.add "oauth_token", valid_580194
  var valid_580195 = query.getOrDefault("userIp")
  valid_580195 = validateParameter(valid_580195, JString, required = false,
                                 default = nil)
  if valid_580195 != nil:
    section.add "userIp", valid_580195
  var valid_580196 = query.getOrDefault("key")
  valid_580196 = validateParameter(valid_580196, JString, required = false,
                                 default = nil)
  if valid_580196 != nil:
    section.add "key", valid_580196
  var valid_580197 = query.getOrDefault("prettyPrint")
  valid_580197 = validateParameter(valid_580197, JBool, required = false,
                                 default = newJBool(true))
  if valid_580197 != nil:
    section.add "prettyPrint", valid_580197
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

proc call*(call_580199: Call_StorageDefaultObjectAccessControlsInsert_580187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_580199.validator(path, query, header, formData, body)
  let scheme = call_580199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580199.url(scheme.get, call_580199.host, call_580199.base,
                         call_580199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580199, url, valid)

proc call*(call_580200: Call_StorageDefaultObjectAccessControlsInsert_580187;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageDefaultObjectAccessControlsInsert
  ## Creates a new default object ACL entry on the specified bucket.
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
  var path_580201 = newJObject()
  var query_580202 = newJObject()
  var body_580203 = newJObject()
  add(path_580201, "bucket", newJString(bucket))
  add(query_580202, "fields", newJString(fields))
  add(query_580202, "quotaUser", newJString(quotaUser))
  add(query_580202, "alt", newJString(alt))
  add(query_580202, "oauth_token", newJString(oauthToken))
  add(query_580202, "userIp", newJString(userIp))
  add(query_580202, "key", newJString(key))
  if body != nil:
    body_580203 = body
  add(query_580202, "prettyPrint", newJBool(prettyPrint))
  result = call_580200.call(path_580201, query_580202, nil, nil, body_580203)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_580187(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_580188,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsInsert_580189,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_580170 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsList_580172(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsList_580171(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580173 = path.getOrDefault("bucket")
  valid_580173 = validateParameter(valid_580173, JString, required = true,
                                 default = nil)
  if valid_580173 != nil:
    section.add "bucket", valid_580173
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
  ##   ifMetagenerationMatch: JString
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  section = newJObject()
  var valid_580174 = query.getOrDefault("fields")
  valid_580174 = validateParameter(valid_580174, JString, required = false,
                                 default = nil)
  if valid_580174 != nil:
    section.add "fields", valid_580174
  var valid_580175 = query.getOrDefault("quotaUser")
  valid_580175 = validateParameter(valid_580175, JString, required = false,
                                 default = nil)
  if valid_580175 != nil:
    section.add "quotaUser", valid_580175
  var valid_580176 = query.getOrDefault("alt")
  valid_580176 = validateParameter(valid_580176, JString, required = false,
                                 default = newJString("json"))
  if valid_580176 != nil:
    section.add "alt", valid_580176
  var valid_580177 = query.getOrDefault("oauth_token")
  valid_580177 = validateParameter(valid_580177, JString, required = false,
                                 default = nil)
  if valid_580177 != nil:
    section.add "oauth_token", valid_580177
  var valid_580178 = query.getOrDefault("userIp")
  valid_580178 = validateParameter(valid_580178, JString, required = false,
                                 default = nil)
  if valid_580178 != nil:
    section.add "userIp", valid_580178
  var valid_580179 = query.getOrDefault("key")
  valid_580179 = validateParameter(valid_580179, JString, required = false,
                                 default = nil)
  if valid_580179 != nil:
    section.add "key", valid_580179
  var valid_580180 = query.getOrDefault("ifMetagenerationMatch")
  valid_580180 = validateParameter(valid_580180, JString, required = false,
                                 default = nil)
  if valid_580180 != nil:
    section.add "ifMetagenerationMatch", valid_580180
  var valid_580181 = query.getOrDefault("prettyPrint")
  valid_580181 = validateParameter(valid_580181, JBool, required = false,
                                 default = newJBool(true))
  if valid_580181 != nil:
    section.add "prettyPrint", valid_580181
  var valid_580182 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580182 = validateParameter(valid_580182, JString, required = false,
                                 default = nil)
  if valid_580182 != nil:
    section.add "ifMetagenerationNotMatch", valid_580182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580183: Call_StorageDefaultObjectAccessControlsList_580170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_580183.validator(path, query, header, formData, body)
  let scheme = call_580183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580183.url(scheme.get, call_580183.host, call_580183.base,
                         call_580183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580183, url, valid)

proc call*(call_580184: Call_StorageDefaultObjectAccessControlsList_580170;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; ifMetagenerationMatch: string = "";
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsList
  ## Retrieves default object ACL entries on the specified bucket.
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
  ##   ifMetagenerationMatch: string
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  var path_580185 = newJObject()
  var query_580186 = newJObject()
  add(path_580185, "bucket", newJString(bucket))
  add(query_580186, "fields", newJString(fields))
  add(query_580186, "quotaUser", newJString(quotaUser))
  add(query_580186, "alt", newJString(alt))
  add(query_580186, "oauth_token", newJString(oauthToken))
  add(query_580186, "userIp", newJString(userIp))
  add(query_580186, "key", newJString(key))
  add(query_580186, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580186, "prettyPrint", newJBool(prettyPrint))
  add(query_580186, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_580184.call(path_580185, query_580186, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_580170(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_580171,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsList_580172,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_580220 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsUpdate_580222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsUpdate_580221(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a default object ACL entry on the specified bucket.
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
  var valid_580223 = path.getOrDefault("bucket")
  valid_580223 = validateParameter(valid_580223, JString, required = true,
                                 default = nil)
  if valid_580223 != nil:
    section.add "bucket", valid_580223
  var valid_580224 = path.getOrDefault("entity")
  valid_580224 = validateParameter(valid_580224, JString, required = true,
                                 default = nil)
  if valid_580224 != nil:
    section.add "entity", valid_580224
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
  var valid_580225 = query.getOrDefault("fields")
  valid_580225 = validateParameter(valid_580225, JString, required = false,
                                 default = nil)
  if valid_580225 != nil:
    section.add "fields", valid_580225
  var valid_580226 = query.getOrDefault("quotaUser")
  valid_580226 = validateParameter(valid_580226, JString, required = false,
                                 default = nil)
  if valid_580226 != nil:
    section.add "quotaUser", valid_580226
  var valid_580227 = query.getOrDefault("alt")
  valid_580227 = validateParameter(valid_580227, JString, required = false,
                                 default = newJString("json"))
  if valid_580227 != nil:
    section.add "alt", valid_580227
  var valid_580228 = query.getOrDefault("oauth_token")
  valid_580228 = validateParameter(valid_580228, JString, required = false,
                                 default = nil)
  if valid_580228 != nil:
    section.add "oauth_token", valid_580228
  var valid_580229 = query.getOrDefault("userIp")
  valid_580229 = validateParameter(valid_580229, JString, required = false,
                                 default = nil)
  if valid_580229 != nil:
    section.add "userIp", valid_580229
  var valid_580230 = query.getOrDefault("key")
  valid_580230 = validateParameter(valid_580230, JString, required = false,
                                 default = nil)
  if valid_580230 != nil:
    section.add "key", valid_580230
  var valid_580231 = query.getOrDefault("prettyPrint")
  valid_580231 = validateParameter(valid_580231, JBool, required = false,
                                 default = newJBool(true))
  if valid_580231 != nil:
    section.add "prettyPrint", valid_580231
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

proc call*(call_580233: Call_StorageDefaultObjectAccessControlsUpdate_580220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_580233.validator(path, query, header, formData, body)
  let scheme = call_580233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580233.url(scheme.get, call_580233.host, call_580233.base,
                         call_580233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580233, url, valid)

proc call*(call_580234: Call_StorageDefaultObjectAccessControlsUpdate_580220;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageDefaultObjectAccessControlsUpdate
  ## Updates a default object ACL entry on the specified bucket.
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
  var path_580235 = newJObject()
  var query_580236 = newJObject()
  var body_580237 = newJObject()
  add(path_580235, "bucket", newJString(bucket))
  add(query_580236, "fields", newJString(fields))
  add(query_580236, "quotaUser", newJString(quotaUser))
  add(query_580236, "alt", newJString(alt))
  add(query_580236, "oauth_token", newJString(oauthToken))
  add(query_580236, "userIp", newJString(userIp))
  add(query_580236, "key", newJString(key))
  if body != nil:
    body_580237 = body
  add(query_580236, "prettyPrint", newJBool(prettyPrint))
  add(path_580235, "entity", newJString(entity))
  result = call_580234.call(path_580235, query_580236, nil, nil, body_580237)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_580220(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_580221,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsUpdate_580222,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_580204 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsGet_580206(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsGet_580205(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
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
  var valid_580207 = path.getOrDefault("bucket")
  valid_580207 = validateParameter(valid_580207, JString, required = true,
                                 default = nil)
  if valid_580207 != nil:
    section.add "bucket", valid_580207
  var valid_580208 = path.getOrDefault("entity")
  valid_580208 = validateParameter(valid_580208, JString, required = true,
                                 default = nil)
  if valid_580208 != nil:
    section.add "entity", valid_580208
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
  var valid_580209 = query.getOrDefault("fields")
  valid_580209 = validateParameter(valid_580209, JString, required = false,
                                 default = nil)
  if valid_580209 != nil:
    section.add "fields", valid_580209
  var valid_580210 = query.getOrDefault("quotaUser")
  valid_580210 = validateParameter(valid_580210, JString, required = false,
                                 default = nil)
  if valid_580210 != nil:
    section.add "quotaUser", valid_580210
  var valid_580211 = query.getOrDefault("alt")
  valid_580211 = validateParameter(valid_580211, JString, required = false,
                                 default = newJString("json"))
  if valid_580211 != nil:
    section.add "alt", valid_580211
  var valid_580212 = query.getOrDefault("oauth_token")
  valid_580212 = validateParameter(valid_580212, JString, required = false,
                                 default = nil)
  if valid_580212 != nil:
    section.add "oauth_token", valid_580212
  var valid_580213 = query.getOrDefault("userIp")
  valid_580213 = validateParameter(valid_580213, JString, required = false,
                                 default = nil)
  if valid_580213 != nil:
    section.add "userIp", valid_580213
  var valid_580214 = query.getOrDefault("key")
  valid_580214 = validateParameter(valid_580214, JString, required = false,
                                 default = nil)
  if valid_580214 != nil:
    section.add "key", valid_580214
  var valid_580215 = query.getOrDefault("prettyPrint")
  valid_580215 = validateParameter(valid_580215, JBool, required = false,
                                 default = newJBool(true))
  if valid_580215 != nil:
    section.add "prettyPrint", valid_580215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580216: Call_StorageDefaultObjectAccessControlsGet_580204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580216.validator(path, query, header, formData, body)
  let scheme = call_580216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580216.url(scheme.get, call_580216.host, call_580216.base,
                         call_580216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580216, url, valid)

proc call*(call_580217: Call_StorageDefaultObjectAccessControlsGet_580204;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageDefaultObjectAccessControlsGet
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
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
  var path_580218 = newJObject()
  var query_580219 = newJObject()
  add(path_580218, "bucket", newJString(bucket))
  add(query_580219, "fields", newJString(fields))
  add(query_580219, "quotaUser", newJString(quotaUser))
  add(query_580219, "alt", newJString(alt))
  add(query_580219, "oauth_token", newJString(oauthToken))
  add(query_580219, "userIp", newJString(userIp))
  add(query_580219, "key", newJString(key))
  add(query_580219, "prettyPrint", newJBool(prettyPrint))
  add(path_580218, "entity", newJString(entity))
  result = call_580217.call(path_580218, query_580219, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_580204(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_580205,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsGet_580206,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_580254 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsPatch_580256(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsPatch_580255(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
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
  var valid_580257 = path.getOrDefault("bucket")
  valid_580257 = validateParameter(valid_580257, JString, required = true,
                                 default = nil)
  if valid_580257 != nil:
    section.add "bucket", valid_580257
  var valid_580258 = path.getOrDefault("entity")
  valid_580258 = validateParameter(valid_580258, JString, required = true,
                                 default = nil)
  if valid_580258 != nil:
    section.add "entity", valid_580258
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
  var valid_580259 = query.getOrDefault("fields")
  valid_580259 = validateParameter(valid_580259, JString, required = false,
                                 default = nil)
  if valid_580259 != nil:
    section.add "fields", valid_580259
  var valid_580260 = query.getOrDefault("quotaUser")
  valid_580260 = validateParameter(valid_580260, JString, required = false,
                                 default = nil)
  if valid_580260 != nil:
    section.add "quotaUser", valid_580260
  var valid_580261 = query.getOrDefault("alt")
  valid_580261 = validateParameter(valid_580261, JString, required = false,
                                 default = newJString("json"))
  if valid_580261 != nil:
    section.add "alt", valid_580261
  var valid_580262 = query.getOrDefault("oauth_token")
  valid_580262 = validateParameter(valid_580262, JString, required = false,
                                 default = nil)
  if valid_580262 != nil:
    section.add "oauth_token", valid_580262
  var valid_580263 = query.getOrDefault("userIp")
  valid_580263 = validateParameter(valid_580263, JString, required = false,
                                 default = nil)
  if valid_580263 != nil:
    section.add "userIp", valid_580263
  var valid_580264 = query.getOrDefault("key")
  valid_580264 = validateParameter(valid_580264, JString, required = false,
                                 default = nil)
  if valid_580264 != nil:
    section.add "key", valid_580264
  var valid_580265 = query.getOrDefault("prettyPrint")
  valid_580265 = validateParameter(valid_580265, JBool, required = false,
                                 default = newJBool(true))
  if valid_580265 != nil:
    section.add "prettyPrint", valid_580265
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

proc call*(call_580267: Call_StorageDefaultObjectAccessControlsPatch_580254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_580267.validator(path, query, header, formData, body)
  let scheme = call_580267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580267.url(scheme.get, call_580267.host, call_580267.base,
                         call_580267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580267, url, valid)

proc call*(call_580268: Call_StorageDefaultObjectAccessControlsPatch_580254;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageDefaultObjectAccessControlsPatch
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
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
  var path_580269 = newJObject()
  var query_580270 = newJObject()
  var body_580271 = newJObject()
  add(path_580269, "bucket", newJString(bucket))
  add(query_580270, "fields", newJString(fields))
  add(query_580270, "quotaUser", newJString(quotaUser))
  add(query_580270, "alt", newJString(alt))
  add(query_580270, "oauth_token", newJString(oauthToken))
  add(query_580270, "userIp", newJString(userIp))
  add(query_580270, "key", newJString(key))
  if body != nil:
    body_580271 = body
  add(query_580270, "prettyPrint", newJBool(prettyPrint))
  add(path_580269, "entity", newJString(entity))
  result = call_580268.call(path_580269, query_580270, nil, nil, body_580271)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_580254(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_580255,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsPatch_580256,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_580238 = ref object of OpenApiRestCall_579424
proc url_StorageDefaultObjectAccessControlsDelete_580240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "entity" in path, "`entity` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/defaultObjectAcl/"),
               (kind: VariableSegment, value: "entity")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageDefaultObjectAccessControlsDelete_580239(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
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
  var valid_580241 = path.getOrDefault("bucket")
  valid_580241 = validateParameter(valid_580241, JString, required = true,
                                 default = nil)
  if valid_580241 != nil:
    section.add "bucket", valid_580241
  var valid_580242 = path.getOrDefault("entity")
  valid_580242 = validateParameter(valid_580242, JString, required = true,
                                 default = nil)
  if valid_580242 != nil:
    section.add "entity", valid_580242
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
  var valid_580243 = query.getOrDefault("fields")
  valid_580243 = validateParameter(valid_580243, JString, required = false,
                                 default = nil)
  if valid_580243 != nil:
    section.add "fields", valid_580243
  var valid_580244 = query.getOrDefault("quotaUser")
  valid_580244 = validateParameter(valid_580244, JString, required = false,
                                 default = nil)
  if valid_580244 != nil:
    section.add "quotaUser", valid_580244
  var valid_580245 = query.getOrDefault("alt")
  valid_580245 = validateParameter(valid_580245, JString, required = false,
                                 default = newJString("json"))
  if valid_580245 != nil:
    section.add "alt", valid_580245
  var valid_580246 = query.getOrDefault("oauth_token")
  valid_580246 = validateParameter(valid_580246, JString, required = false,
                                 default = nil)
  if valid_580246 != nil:
    section.add "oauth_token", valid_580246
  var valid_580247 = query.getOrDefault("userIp")
  valid_580247 = validateParameter(valid_580247, JString, required = false,
                                 default = nil)
  if valid_580247 != nil:
    section.add "userIp", valid_580247
  var valid_580248 = query.getOrDefault("key")
  valid_580248 = validateParameter(valid_580248, JString, required = false,
                                 default = nil)
  if valid_580248 != nil:
    section.add "key", valid_580248
  var valid_580249 = query.getOrDefault("prettyPrint")
  valid_580249 = validateParameter(valid_580249, JBool, required = false,
                                 default = newJBool(true))
  if valid_580249 != nil:
    section.add "prettyPrint", valid_580249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580250: Call_StorageDefaultObjectAccessControlsDelete_580238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_580250.validator(path, query, header, formData, body)
  let scheme = call_580250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580250.url(scheme.get, call_580250.host, call_580250.base,
                         call_580250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580250, url, valid)

proc call*(call_580251: Call_StorageDefaultObjectAccessControlsDelete_580238;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageDefaultObjectAccessControlsDelete
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
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
  var path_580252 = newJObject()
  var query_580253 = newJObject()
  add(path_580252, "bucket", newJString(bucket))
  add(query_580253, "fields", newJString(fields))
  add(query_580253, "quotaUser", newJString(quotaUser))
  add(query_580253, "alt", newJString(alt))
  add(query_580253, "oauth_token", newJString(oauthToken))
  add(query_580253, "userIp", newJString(userIp))
  add(query_580253, "key", newJString(key))
  add(query_580253, "prettyPrint", newJBool(prettyPrint))
  add(path_580252, "entity", newJString(entity))
  result = call_580251.call(path_580252, query_580253, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_580238(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_580239,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsDelete_580240,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_580293 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsInsert_580295(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsInsert_580294(path: JsonNode; query: JsonNode;
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
  var valid_580296 = path.getOrDefault("bucket")
  valid_580296 = validateParameter(valid_580296, JString, required = true,
                                 default = nil)
  if valid_580296 != nil:
    section.add "bucket", valid_580296
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  section = newJObject()
  var valid_580297 = query.getOrDefault("ifGenerationMatch")
  valid_580297 = validateParameter(valid_580297, JString, required = false,
                                 default = nil)
  if valid_580297 != nil:
    section.add "ifGenerationMatch", valid_580297
  var valid_580298 = query.getOrDefault("fields")
  valid_580298 = validateParameter(valid_580298, JString, required = false,
                                 default = nil)
  if valid_580298 != nil:
    section.add "fields", valid_580298
  var valid_580299 = query.getOrDefault("quotaUser")
  valid_580299 = validateParameter(valid_580299, JString, required = false,
                                 default = nil)
  if valid_580299 != nil:
    section.add "quotaUser", valid_580299
  var valid_580300 = query.getOrDefault("alt")
  valid_580300 = validateParameter(valid_580300, JString, required = false,
                                 default = newJString("json"))
  if valid_580300 != nil:
    section.add "alt", valid_580300
  var valid_580301 = query.getOrDefault("ifGenerationNotMatch")
  valid_580301 = validateParameter(valid_580301, JString, required = false,
                                 default = nil)
  if valid_580301 != nil:
    section.add "ifGenerationNotMatch", valid_580301
  var valid_580302 = query.getOrDefault("oauth_token")
  valid_580302 = validateParameter(valid_580302, JString, required = false,
                                 default = nil)
  if valid_580302 != nil:
    section.add "oauth_token", valid_580302
  var valid_580303 = query.getOrDefault("userIp")
  valid_580303 = validateParameter(valid_580303, JString, required = false,
                                 default = nil)
  if valid_580303 != nil:
    section.add "userIp", valid_580303
  var valid_580304 = query.getOrDefault("key")
  valid_580304 = validateParameter(valid_580304, JString, required = false,
                                 default = nil)
  if valid_580304 != nil:
    section.add "key", valid_580304
  var valid_580305 = query.getOrDefault("name")
  valid_580305 = validateParameter(valid_580305, JString, required = false,
                                 default = nil)
  if valid_580305 != nil:
    section.add "name", valid_580305
  var valid_580306 = query.getOrDefault("projection")
  valid_580306 = validateParameter(valid_580306, JString, required = false,
                                 default = newJString("full"))
  if valid_580306 != nil:
    section.add "projection", valid_580306
  var valid_580307 = query.getOrDefault("ifMetagenerationMatch")
  valid_580307 = validateParameter(valid_580307, JString, required = false,
                                 default = nil)
  if valid_580307 != nil:
    section.add "ifMetagenerationMatch", valid_580307
  var valid_580308 = query.getOrDefault("prettyPrint")
  valid_580308 = validateParameter(valid_580308, JBool, required = false,
                                 default = newJBool(true))
  if valid_580308 != nil:
    section.add "prettyPrint", valid_580308
  var valid_580309 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580309 = validateParameter(valid_580309, JString, required = false,
                                 default = nil)
  if valid_580309 != nil:
    section.add "ifMetagenerationNotMatch", valid_580309
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

proc call*(call_580311: Call_StorageObjectsInsert_580293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores new data blobs and associated metadata.
  ## 
  let valid = call_580311.validator(path, query, header, formData, body)
  let scheme = call_580311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580311.url(scheme.get, call_580311.host, call_580311.base,
                         call_580311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580311, url, valid)

proc call*(call_580312: Call_StorageObjectsInsert_580293; bucket: string;
          ifGenerationMatch: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; ifGenerationNotMatch: string = "";
          oauthToken: string = ""; userIp: string = ""; key: string = ""; name: string = "";
          projection: string = "full"; ifMetagenerationMatch: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageObjectsInsert
  ## Stores new data blobs and associated metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  var path_580313 = newJObject()
  var query_580314 = newJObject()
  var body_580315 = newJObject()
  add(query_580314, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580313, "bucket", newJString(bucket))
  add(query_580314, "fields", newJString(fields))
  add(query_580314, "quotaUser", newJString(quotaUser))
  add(query_580314, "alt", newJString(alt))
  add(query_580314, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580314, "oauth_token", newJString(oauthToken))
  add(query_580314, "userIp", newJString(userIp))
  add(query_580314, "key", newJString(key))
  add(query_580314, "name", newJString(name))
  add(query_580314, "projection", newJString(projection))
  add(query_580314, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580315 = body
  add(query_580314, "prettyPrint", newJBool(prettyPrint))
  add(query_580314, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_580312.call(path_580313, query_580314, nil, nil, body_580315)

var storageObjectsInsert* = Call_StorageObjectsInsert_580293(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_580294, base: "/storage/v1beta2",
    url: url_StorageObjectsInsert_580295, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_580272 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsList_580274(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsList_580273(path: JsonNode; query: JsonNode;
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
  var valid_580275 = path.getOrDefault("bucket")
  valid_580275 = validateParameter(valid_580275, JString, required = true,
                                 default = nil)
  if valid_580275 != nil:
    section.add "bucket", valid_580275
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
  ##   versions: JBool
  ##           : If true, lists all versions of a file as distinct results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  section = newJObject()
  var valid_580276 = query.getOrDefault("fields")
  valid_580276 = validateParameter(valid_580276, JString, required = false,
                                 default = nil)
  if valid_580276 != nil:
    section.add "fields", valid_580276
  var valid_580277 = query.getOrDefault("pageToken")
  valid_580277 = validateParameter(valid_580277, JString, required = false,
                                 default = nil)
  if valid_580277 != nil:
    section.add "pageToken", valid_580277
  var valid_580278 = query.getOrDefault("quotaUser")
  valid_580278 = validateParameter(valid_580278, JString, required = false,
                                 default = nil)
  if valid_580278 != nil:
    section.add "quotaUser", valid_580278
  var valid_580279 = query.getOrDefault("alt")
  valid_580279 = validateParameter(valid_580279, JString, required = false,
                                 default = newJString("json"))
  if valid_580279 != nil:
    section.add "alt", valid_580279
  var valid_580280 = query.getOrDefault("oauth_token")
  valid_580280 = validateParameter(valid_580280, JString, required = false,
                                 default = nil)
  if valid_580280 != nil:
    section.add "oauth_token", valid_580280
  var valid_580281 = query.getOrDefault("versions")
  valid_580281 = validateParameter(valid_580281, JBool, required = false, default = nil)
  if valid_580281 != nil:
    section.add "versions", valid_580281
  var valid_580282 = query.getOrDefault("userIp")
  valid_580282 = validateParameter(valid_580282, JString, required = false,
                                 default = nil)
  if valid_580282 != nil:
    section.add "userIp", valid_580282
  var valid_580283 = query.getOrDefault("maxResults")
  valid_580283 = validateParameter(valid_580283, JInt, required = false, default = nil)
  if valid_580283 != nil:
    section.add "maxResults", valid_580283
  var valid_580284 = query.getOrDefault("key")
  valid_580284 = validateParameter(valid_580284, JString, required = false,
                                 default = nil)
  if valid_580284 != nil:
    section.add "key", valid_580284
  var valid_580285 = query.getOrDefault("projection")
  valid_580285 = validateParameter(valid_580285, JString, required = false,
                                 default = newJString("full"))
  if valid_580285 != nil:
    section.add "projection", valid_580285
  var valid_580286 = query.getOrDefault("delimiter")
  valid_580286 = validateParameter(valid_580286, JString, required = false,
                                 default = nil)
  if valid_580286 != nil:
    section.add "delimiter", valid_580286
  var valid_580287 = query.getOrDefault("prettyPrint")
  valid_580287 = validateParameter(valid_580287, JBool, required = false,
                                 default = newJBool(true))
  if valid_580287 != nil:
    section.add "prettyPrint", valid_580287
  var valid_580288 = query.getOrDefault("prefix")
  valid_580288 = validateParameter(valid_580288, JString, required = false,
                                 default = nil)
  if valid_580288 != nil:
    section.add "prefix", valid_580288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580289: Call_StorageObjectsList_580272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_580289.validator(path, query, header, formData, body)
  let scheme = call_580289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580289.url(scheme.get, call_580289.host, call_580289.base,
                         call_580289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580289, url, valid)

proc call*(call_580290: Call_StorageObjectsList_580272; bucket: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; versions: bool = false;
          userIp: string = ""; maxResults: int = 0; key: string = "";
          projection: string = "full"; delimiter: string = ""; prettyPrint: bool = true;
          prefix: string = ""): Recallable =
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
  ##   versions: bool
  ##           : If true, lists all versions of a file as distinct results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  var path_580291 = newJObject()
  var query_580292 = newJObject()
  add(path_580291, "bucket", newJString(bucket))
  add(query_580292, "fields", newJString(fields))
  add(query_580292, "pageToken", newJString(pageToken))
  add(query_580292, "quotaUser", newJString(quotaUser))
  add(query_580292, "alt", newJString(alt))
  add(query_580292, "oauth_token", newJString(oauthToken))
  add(query_580292, "versions", newJBool(versions))
  add(query_580292, "userIp", newJString(userIp))
  add(query_580292, "maxResults", newJInt(maxResults))
  add(query_580292, "key", newJString(key))
  add(query_580292, "projection", newJString(projection))
  add(query_580292, "delimiter", newJString(delimiter))
  add(query_580292, "prettyPrint", newJBool(prettyPrint))
  add(query_580292, "prefix", newJString(prefix))
  result = call_580290.call(path_580291, query_580292, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_580272(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_580273, base: "/storage/v1beta2",
    url: url_StorageObjectsList_580274, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_580316 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsWatchAll_580318(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/o/watch")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsWatchAll_580317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Watch for changes on all objects in a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to look for objects.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_580319 = path.getOrDefault("bucket")
  valid_580319 = validateParameter(valid_580319, JString, required = true,
                                 default = nil)
  if valid_580319 != nil:
    section.add "bucket", valid_580319
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
  ##   versions: JBool
  ##           : If true, lists all versions of a file as distinct results.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: JString
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JString
  ##         : Filter results to objects whose names begin with this prefix.
  section = newJObject()
  var valid_580320 = query.getOrDefault("fields")
  valid_580320 = validateParameter(valid_580320, JString, required = false,
                                 default = nil)
  if valid_580320 != nil:
    section.add "fields", valid_580320
  var valid_580321 = query.getOrDefault("pageToken")
  valid_580321 = validateParameter(valid_580321, JString, required = false,
                                 default = nil)
  if valid_580321 != nil:
    section.add "pageToken", valid_580321
  var valid_580322 = query.getOrDefault("quotaUser")
  valid_580322 = validateParameter(valid_580322, JString, required = false,
                                 default = nil)
  if valid_580322 != nil:
    section.add "quotaUser", valid_580322
  var valid_580323 = query.getOrDefault("alt")
  valid_580323 = validateParameter(valid_580323, JString, required = false,
                                 default = newJString("json"))
  if valid_580323 != nil:
    section.add "alt", valid_580323
  var valid_580324 = query.getOrDefault("oauth_token")
  valid_580324 = validateParameter(valid_580324, JString, required = false,
                                 default = nil)
  if valid_580324 != nil:
    section.add "oauth_token", valid_580324
  var valid_580325 = query.getOrDefault("versions")
  valid_580325 = validateParameter(valid_580325, JBool, required = false, default = nil)
  if valid_580325 != nil:
    section.add "versions", valid_580325
  var valid_580326 = query.getOrDefault("userIp")
  valid_580326 = validateParameter(valid_580326, JString, required = false,
                                 default = nil)
  if valid_580326 != nil:
    section.add "userIp", valid_580326
  var valid_580327 = query.getOrDefault("maxResults")
  valid_580327 = validateParameter(valid_580327, JInt, required = false, default = nil)
  if valid_580327 != nil:
    section.add "maxResults", valid_580327
  var valid_580328 = query.getOrDefault("key")
  valid_580328 = validateParameter(valid_580328, JString, required = false,
                                 default = nil)
  if valid_580328 != nil:
    section.add "key", valid_580328
  var valid_580329 = query.getOrDefault("projection")
  valid_580329 = validateParameter(valid_580329, JString, required = false,
                                 default = newJString("full"))
  if valid_580329 != nil:
    section.add "projection", valid_580329
  var valid_580330 = query.getOrDefault("delimiter")
  valid_580330 = validateParameter(valid_580330, JString, required = false,
                                 default = nil)
  if valid_580330 != nil:
    section.add "delimiter", valid_580330
  var valid_580331 = query.getOrDefault("prettyPrint")
  valid_580331 = validateParameter(valid_580331, JBool, required = false,
                                 default = newJBool(true))
  if valid_580331 != nil:
    section.add "prettyPrint", valid_580331
  var valid_580332 = query.getOrDefault("prefix")
  valid_580332 = validateParameter(valid_580332, JString, required = false,
                                 default = nil)
  if valid_580332 != nil:
    section.add "prefix", valid_580332
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580334: Call_StorageObjectsWatchAll_580316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_580334.validator(path, query, header, formData, body)
  let scheme = call_580334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580334.url(scheme.get, call_580334.host, call_580334.base,
                         call_580334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580334, url, valid)

proc call*(call_580335: Call_StorageObjectsWatchAll_580316; bucket: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; versions: bool = false;
          userIp: string = ""; maxResults: int = 0; key: string = "";
          projection: string = "full"; delimiter: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true; prefix: string = ""): Recallable =
  ## storageObjectsWatchAll
  ## Watch for changes on all objects in a bucket.
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
  ##   versions: bool
  ##           : If true, lists all versions of a file as distinct results.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return. As duplicate prefixes are omitted, fewer total results may be returned than requested.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   delimiter: string
  ##            : Returns results in a directory-like mode. items will contain only objects whose names, aside from the prefix, do not contain delimiter. Objects whose names, aside from the prefix, contain delimiter will have their name, truncated after the delimiter, returned in prefixes. Duplicate prefixes are omitted.
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: string
  ##         : Filter results to objects whose names begin with this prefix.
  var path_580336 = newJObject()
  var query_580337 = newJObject()
  var body_580338 = newJObject()
  add(path_580336, "bucket", newJString(bucket))
  add(query_580337, "fields", newJString(fields))
  add(query_580337, "pageToken", newJString(pageToken))
  add(query_580337, "quotaUser", newJString(quotaUser))
  add(query_580337, "alt", newJString(alt))
  add(query_580337, "oauth_token", newJString(oauthToken))
  add(query_580337, "versions", newJBool(versions))
  add(query_580337, "userIp", newJString(userIp))
  add(query_580337, "maxResults", newJInt(maxResults))
  add(query_580337, "key", newJString(key))
  add(query_580337, "projection", newJString(projection))
  add(query_580337, "delimiter", newJString(delimiter))
  if resource != nil:
    body_580338 = resource
  add(query_580337, "prettyPrint", newJBool(prettyPrint))
  add(query_580337, "prefix", newJString(prefix))
  result = call_580335.call(path_580336, query_580337, nil, nil, body_580338)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_580316(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_580317, base: "/storage/v1beta2",
    url: url_StorageObjectsWatchAll_580318, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_580361 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsUpdate_580363(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsUpdate_580362(path: JsonNode; query: JsonNode;
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
  var valid_580364 = path.getOrDefault("bucket")
  valid_580364 = validateParameter(valid_580364, JString, required = true,
                                 default = nil)
  if valid_580364 != nil:
    section.add "bucket", valid_580364
  var valid_580365 = path.getOrDefault("object")
  valid_580365 = validateParameter(valid_580365, JString, required = true,
                                 default = nil)
  if valid_580365 != nil:
    section.add "object", valid_580365
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  section = newJObject()
  var valid_580366 = query.getOrDefault("ifGenerationMatch")
  valid_580366 = validateParameter(valid_580366, JString, required = false,
                                 default = nil)
  if valid_580366 != nil:
    section.add "ifGenerationMatch", valid_580366
  var valid_580367 = query.getOrDefault("fields")
  valid_580367 = validateParameter(valid_580367, JString, required = false,
                                 default = nil)
  if valid_580367 != nil:
    section.add "fields", valid_580367
  var valid_580368 = query.getOrDefault("quotaUser")
  valid_580368 = validateParameter(valid_580368, JString, required = false,
                                 default = nil)
  if valid_580368 != nil:
    section.add "quotaUser", valid_580368
  var valid_580369 = query.getOrDefault("alt")
  valid_580369 = validateParameter(valid_580369, JString, required = false,
                                 default = newJString("json"))
  if valid_580369 != nil:
    section.add "alt", valid_580369
  var valid_580370 = query.getOrDefault("ifGenerationNotMatch")
  valid_580370 = validateParameter(valid_580370, JString, required = false,
                                 default = nil)
  if valid_580370 != nil:
    section.add "ifGenerationNotMatch", valid_580370
  var valid_580371 = query.getOrDefault("oauth_token")
  valid_580371 = validateParameter(valid_580371, JString, required = false,
                                 default = nil)
  if valid_580371 != nil:
    section.add "oauth_token", valid_580371
  var valid_580372 = query.getOrDefault("userIp")
  valid_580372 = validateParameter(valid_580372, JString, required = false,
                                 default = nil)
  if valid_580372 != nil:
    section.add "userIp", valid_580372
  var valid_580373 = query.getOrDefault("key")
  valid_580373 = validateParameter(valid_580373, JString, required = false,
                                 default = nil)
  if valid_580373 != nil:
    section.add "key", valid_580373
  var valid_580374 = query.getOrDefault("projection")
  valid_580374 = validateParameter(valid_580374, JString, required = false,
                                 default = newJString("full"))
  if valid_580374 != nil:
    section.add "projection", valid_580374
  var valid_580375 = query.getOrDefault("ifMetagenerationMatch")
  valid_580375 = validateParameter(valid_580375, JString, required = false,
                                 default = nil)
  if valid_580375 != nil:
    section.add "ifMetagenerationMatch", valid_580375
  var valid_580376 = query.getOrDefault("generation")
  valid_580376 = validateParameter(valid_580376, JString, required = false,
                                 default = nil)
  if valid_580376 != nil:
    section.add "generation", valid_580376
  var valid_580377 = query.getOrDefault("prettyPrint")
  valid_580377 = validateParameter(valid_580377, JBool, required = false,
                                 default = newJBool(true))
  if valid_580377 != nil:
    section.add "prettyPrint", valid_580377
  var valid_580378 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580378 = validateParameter(valid_580378, JString, required = false,
                                 default = nil)
  if valid_580378 != nil:
    section.add "ifMetagenerationNotMatch", valid_580378
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

proc call*(call_580380: Call_StorageObjectsUpdate_580361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata.
  ## 
  let valid = call_580380.validator(path, query, header, formData, body)
  let scheme = call_580380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580380.url(scheme.get, call_580380.host, call_580380.base,
                         call_580380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580380, url, valid)

proc call*(call_580381: Call_StorageObjectsUpdate_580361; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates a data blob's associated metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580382 = newJObject()
  var query_580383 = newJObject()
  var body_580384 = newJObject()
  add(query_580383, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580382, "bucket", newJString(bucket))
  add(query_580383, "fields", newJString(fields))
  add(query_580383, "quotaUser", newJString(quotaUser))
  add(query_580383, "alt", newJString(alt))
  add(query_580383, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580383, "oauth_token", newJString(oauthToken))
  add(query_580383, "userIp", newJString(userIp))
  add(query_580383, "key", newJString(key))
  add(query_580383, "projection", newJString(projection))
  add(query_580383, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580383, "generation", newJString(generation))
  if body != nil:
    body_580384 = body
  add(query_580383, "prettyPrint", newJBool(prettyPrint))
  add(query_580383, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580382, "object", newJString(`object`))
  result = call_580381.call(path_580382, query_580383, nil, nil, body_580384)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_580361(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_580362, base: "/storage/v1beta2",
    url: url_StorageObjectsUpdate_580363, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_580339 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsGet_580341(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsGet_580340(path: JsonNode; query: JsonNode;
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
  var valid_580342 = path.getOrDefault("bucket")
  valid_580342 = validateParameter(valid_580342, JString, required = true,
                                 default = nil)
  if valid_580342 != nil:
    section.add "bucket", valid_580342
  var valid_580343 = path.getOrDefault("object")
  valid_580343 = validateParameter(valid_580343, JString, required = true,
                                 default = nil)
  if valid_580343 != nil:
    section.add "object", valid_580343
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's generation does not match the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  section = newJObject()
  var valid_580344 = query.getOrDefault("ifGenerationMatch")
  valid_580344 = validateParameter(valid_580344, JString, required = false,
                                 default = nil)
  if valid_580344 != nil:
    section.add "ifGenerationMatch", valid_580344
  var valid_580345 = query.getOrDefault("fields")
  valid_580345 = validateParameter(valid_580345, JString, required = false,
                                 default = nil)
  if valid_580345 != nil:
    section.add "fields", valid_580345
  var valid_580346 = query.getOrDefault("quotaUser")
  valid_580346 = validateParameter(valid_580346, JString, required = false,
                                 default = nil)
  if valid_580346 != nil:
    section.add "quotaUser", valid_580346
  var valid_580347 = query.getOrDefault("alt")
  valid_580347 = validateParameter(valid_580347, JString, required = false,
                                 default = newJString("json"))
  if valid_580347 != nil:
    section.add "alt", valid_580347
  var valid_580348 = query.getOrDefault("ifGenerationNotMatch")
  valid_580348 = validateParameter(valid_580348, JString, required = false,
                                 default = nil)
  if valid_580348 != nil:
    section.add "ifGenerationNotMatch", valid_580348
  var valid_580349 = query.getOrDefault("oauth_token")
  valid_580349 = validateParameter(valid_580349, JString, required = false,
                                 default = nil)
  if valid_580349 != nil:
    section.add "oauth_token", valid_580349
  var valid_580350 = query.getOrDefault("userIp")
  valid_580350 = validateParameter(valid_580350, JString, required = false,
                                 default = nil)
  if valid_580350 != nil:
    section.add "userIp", valid_580350
  var valid_580351 = query.getOrDefault("key")
  valid_580351 = validateParameter(valid_580351, JString, required = false,
                                 default = nil)
  if valid_580351 != nil:
    section.add "key", valid_580351
  var valid_580352 = query.getOrDefault("projection")
  valid_580352 = validateParameter(valid_580352, JString, required = false,
                                 default = newJString("full"))
  if valid_580352 != nil:
    section.add "projection", valid_580352
  var valid_580353 = query.getOrDefault("ifMetagenerationMatch")
  valid_580353 = validateParameter(valid_580353, JString, required = false,
                                 default = nil)
  if valid_580353 != nil:
    section.add "ifMetagenerationMatch", valid_580353
  var valid_580354 = query.getOrDefault("generation")
  valid_580354 = validateParameter(valid_580354, JString, required = false,
                                 default = nil)
  if valid_580354 != nil:
    section.add "generation", valid_580354
  var valid_580355 = query.getOrDefault("prettyPrint")
  valid_580355 = validateParameter(valid_580355, JBool, required = false,
                                 default = newJBool(true))
  if valid_580355 != nil:
    section.add "prettyPrint", valid_580355
  var valid_580356 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580356 = validateParameter(valid_580356, JString, required = false,
                                 default = nil)
  if valid_580356 != nil:
    section.add "ifMetagenerationNotMatch", valid_580356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580357: Call_StorageObjectsGet_580339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves objects or their associated metadata.
  ## 
  let valid = call_580357.validator(path, query, header, formData, body)
  let scheme = call_580357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580357.url(scheme.get, call_580357.host, call_580357.base,
                         call_580357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580357, url, valid)

proc call*(call_580358: Call_StorageObjectsGet_580339; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; generation: string = "";
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves objects or their associated metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's generation matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's generation does not match the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580359 = newJObject()
  var query_580360 = newJObject()
  add(query_580360, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580359, "bucket", newJString(bucket))
  add(query_580360, "fields", newJString(fields))
  add(query_580360, "quotaUser", newJString(quotaUser))
  add(query_580360, "alt", newJString(alt))
  add(query_580360, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580360, "oauth_token", newJString(oauthToken))
  add(query_580360, "userIp", newJString(userIp))
  add(query_580360, "key", newJString(key))
  add(query_580360, "projection", newJString(projection))
  add(query_580360, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580360, "generation", newJString(generation))
  add(query_580360, "prettyPrint", newJBool(prettyPrint))
  add(query_580360, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580359, "object", newJString(`object`))
  result = call_580358.call(path_580359, query_580360, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_580339(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_580340,
    base: "/storage/v1beta2", url: url_StorageObjectsGet_580341,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_580406 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsPatch_580408(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsPatch_580407(path: JsonNode; query: JsonNode;
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
  var valid_580409 = path.getOrDefault("bucket")
  valid_580409 = validateParameter(valid_580409, JString, required = true,
                                 default = nil)
  if valid_580409 != nil:
    section.add "bucket", valid_580409
  var valid_580410 = path.getOrDefault("object")
  valid_580410 = validateParameter(valid_580410, JString, required = true,
                                 default = nil)
  if valid_580410 != nil:
    section.add "object", valid_580410
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  section = newJObject()
  var valid_580411 = query.getOrDefault("ifGenerationMatch")
  valid_580411 = validateParameter(valid_580411, JString, required = false,
                                 default = nil)
  if valid_580411 != nil:
    section.add "ifGenerationMatch", valid_580411
  var valid_580412 = query.getOrDefault("fields")
  valid_580412 = validateParameter(valid_580412, JString, required = false,
                                 default = nil)
  if valid_580412 != nil:
    section.add "fields", valid_580412
  var valid_580413 = query.getOrDefault("quotaUser")
  valid_580413 = validateParameter(valid_580413, JString, required = false,
                                 default = nil)
  if valid_580413 != nil:
    section.add "quotaUser", valid_580413
  var valid_580414 = query.getOrDefault("alt")
  valid_580414 = validateParameter(valid_580414, JString, required = false,
                                 default = newJString("json"))
  if valid_580414 != nil:
    section.add "alt", valid_580414
  var valid_580415 = query.getOrDefault("ifGenerationNotMatch")
  valid_580415 = validateParameter(valid_580415, JString, required = false,
                                 default = nil)
  if valid_580415 != nil:
    section.add "ifGenerationNotMatch", valid_580415
  var valid_580416 = query.getOrDefault("oauth_token")
  valid_580416 = validateParameter(valid_580416, JString, required = false,
                                 default = nil)
  if valid_580416 != nil:
    section.add "oauth_token", valid_580416
  var valid_580417 = query.getOrDefault("userIp")
  valid_580417 = validateParameter(valid_580417, JString, required = false,
                                 default = nil)
  if valid_580417 != nil:
    section.add "userIp", valid_580417
  var valid_580418 = query.getOrDefault("key")
  valid_580418 = validateParameter(valid_580418, JString, required = false,
                                 default = nil)
  if valid_580418 != nil:
    section.add "key", valid_580418
  var valid_580419 = query.getOrDefault("projection")
  valid_580419 = validateParameter(valid_580419, JString, required = false,
                                 default = newJString("full"))
  if valid_580419 != nil:
    section.add "projection", valid_580419
  var valid_580420 = query.getOrDefault("ifMetagenerationMatch")
  valid_580420 = validateParameter(valid_580420, JString, required = false,
                                 default = nil)
  if valid_580420 != nil:
    section.add "ifMetagenerationMatch", valid_580420
  var valid_580421 = query.getOrDefault("generation")
  valid_580421 = validateParameter(valid_580421, JString, required = false,
                                 default = nil)
  if valid_580421 != nil:
    section.add "generation", valid_580421
  var valid_580422 = query.getOrDefault("prettyPrint")
  valid_580422 = validateParameter(valid_580422, JBool, required = false,
                                 default = newJBool(true))
  if valid_580422 != nil:
    section.add "prettyPrint", valid_580422
  var valid_580423 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580423 = validateParameter(valid_580423, JString, required = false,
                                 default = nil)
  if valid_580423 != nil:
    section.add "ifMetagenerationNotMatch", valid_580423
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

proc call*(call_580425: Call_StorageObjectsPatch_580406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  let valid = call_580425.validator(path, query, header, formData, body)
  let scheme = call_580425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580425.url(scheme.get, call_580425.host, call_580425.base,
                         call_580425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580425, url, valid)

proc call*(call_580426: Call_StorageObjectsPatch_580406; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageObjectsPatch
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580427 = newJObject()
  var query_580428 = newJObject()
  var body_580429 = newJObject()
  add(query_580428, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580427, "bucket", newJString(bucket))
  add(query_580428, "fields", newJString(fields))
  add(query_580428, "quotaUser", newJString(quotaUser))
  add(query_580428, "alt", newJString(alt))
  add(query_580428, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580428, "oauth_token", newJString(oauthToken))
  add(query_580428, "userIp", newJString(userIp))
  add(query_580428, "key", newJString(key))
  add(query_580428, "projection", newJString(projection))
  add(query_580428, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580428, "generation", newJString(generation))
  if body != nil:
    body_580429 = body
  add(query_580428, "prettyPrint", newJBool(prettyPrint))
  add(query_580428, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580427, "object", newJString(`object`))
  result = call_580426.call(path_580427, query_580428, nil, nil, body_580429)

var storageObjectsPatch* = Call_StorageObjectsPatch_580406(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_580407, base: "/storage/v1beta2",
    url: url_StorageObjectsPatch_580408, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_580385 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsDelete_580387(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsDelete_580386(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
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
  var valid_580388 = path.getOrDefault("bucket")
  valid_580388 = validateParameter(valid_580388, JString, required = true,
                                 default = nil)
  if valid_580388 != nil:
    section.add "bucket", valid_580388
  var valid_580389 = path.getOrDefault("object")
  valid_580389 = validateParameter(valid_580389, JString, required = true,
                                 default = nil)
  if valid_580389 != nil:
    section.add "object", valid_580389
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: JString
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  section = newJObject()
  var valid_580390 = query.getOrDefault("ifGenerationMatch")
  valid_580390 = validateParameter(valid_580390, JString, required = false,
                                 default = nil)
  if valid_580390 != nil:
    section.add "ifGenerationMatch", valid_580390
  var valid_580391 = query.getOrDefault("fields")
  valid_580391 = validateParameter(valid_580391, JString, required = false,
                                 default = nil)
  if valid_580391 != nil:
    section.add "fields", valid_580391
  var valid_580392 = query.getOrDefault("quotaUser")
  valid_580392 = validateParameter(valid_580392, JString, required = false,
                                 default = nil)
  if valid_580392 != nil:
    section.add "quotaUser", valid_580392
  var valid_580393 = query.getOrDefault("alt")
  valid_580393 = validateParameter(valid_580393, JString, required = false,
                                 default = newJString("json"))
  if valid_580393 != nil:
    section.add "alt", valid_580393
  var valid_580394 = query.getOrDefault("ifGenerationNotMatch")
  valid_580394 = validateParameter(valid_580394, JString, required = false,
                                 default = nil)
  if valid_580394 != nil:
    section.add "ifGenerationNotMatch", valid_580394
  var valid_580395 = query.getOrDefault("oauth_token")
  valid_580395 = validateParameter(valid_580395, JString, required = false,
                                 default = nil)
  if valid_580395 != nil:
    section.add "oauth_token", valid_580395
  var valid_580396 = query.getOrDefault("userIp")
  valid_580396 = validateParameter(valid_580396, JString, required = false,
                                 default = nil)
  if valid_580396 != nil:
    section.add "userIp", valid_580396
  var valid_580397 = query.getOrDefault("key")
  valid_580397 = validateParameter(valid_580397, JString, required = false,
                                 default = nil)
  if valid_580397 != nil:
    section.add "key", valid_580397
  var valid_580398 = query.getOrDefault("ifMetagenerationMatch")
  valid_580398 = validateParameter(valid_580398, JString, required = false,
                                 default = nil)
  if valid_580398 != nil:
    section.add "ifMetagenerationMatch", valid_580398
  var valid_580399 = query.getOrDefault("generation")
  valid_580399 = validateParameter(valid_580399, JString, required = false,
                                 default = nil)
  if valid_580399 != nil:
    section.add "generation", valid_580399
  var valid_580400 = query.getOrDefault("prettyPrint")
  valid_580400 = validateParameter(valid_580400, JBool, required = false,
                                 default = newJBool(true))
  if valid_580400 != nil:
    section.add "prettyPrint", valid_580400
  var valid_580401 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580401 = validateParameter(valid_580401, JString, required = false,
                                 default = nil)
  if valid_580401 != nil:
    section.add "ifMetagenerationNotMatch", valid_580401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580402: Call_StorageObjectsDelete_580385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_580402.validator(path, query, header, formData, body)
  let scheme = call_580402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580402.url(scheme.get, call_580402.host, call_580402.base,
                         call_580402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580402, url, valid)

proc call*(call_580403: Call_StorageObjectsDelete_580385; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; key: string = ""; ifMetagenerationMatch: string = "";
          generation: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   generation: string
  ##             : If present, permanently deletes a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580404 = newJObject()
  var query_580405 = newJObject()
  add(query_580405, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_580404, "bucket", newJString(bucket))
  add(query_580405, "fields", newJString(fields))
  add(query_580405, "quotaUser", newJString(quotaUser))
  add(query_580405, "alt", newJString(alt))
  add(query_580405, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580405, "oauth_token", newJString(oauthToken))
  add(query_580405, "userIp", newJString(userIp))
  add(query_580405, "key", newJString(key))
  add(query_580405, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580405, "generation", newJString(generation))
  add(query_580405, "prettyPrint", newJBool(prettyPrint))
  add(query_580405, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_580404, "object", newJString(`object`))
  result = call_580403.call(path_580404, query_580405, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_580385(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_580386, base: "/storage/v1beta2",
    url: url_StorageObjectsDelete_580387, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_580447 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsInsert_580449(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsInsert_580448(path: JsonNode;
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
  var valid_580450 = path.getOrDefault("bucket")
  valid_580450 = validateParameter(valid_580450, JString, required = true,
                                 default = nil)
  if valid_580450 != nil:
    section.add "bucket", valid_580450
  var valid_580451 = path.getOrDefault("object")
  valid_580451 = validateParameter(valid_580451, JString, required = true,
                                 default = nil)
  if valid_580451 != nil:
    section.add "object", valid_580451
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
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580452 = query.getOrDefault("fields")
  valid_580452 = validateParameter(valid_580452, JString, required = false,
                                 default = nil)
  if valid_580452 != nil:
    section.add "fields", valid_580452
  var valid_580453 = query.getOrDefault("quotaUser")
  valid_580453 = validateParameter(valid_580453, JString, required = false,
                                 default = nil)
  if valid_580453 != nil:
    section.add "quotaUser", valid_580453
  var valid_580454 = query.getOrDefault("alt")
  valid_580454 = validateParameter(valid_580454, JString, required = false,
                                 default = newJString("json"))
  if valid_580454 != nil:
    section.add "alt", valid_580454
  var valid_580455 = query.getOrDefault("oauth_token")
  valid_580455 = validateParameter(valid_580455, JString, required = false,
                                 default = nil)
  if valid_580455 != nil:
    section.add "oauth_token", valid_580455
  var valid_580456 = query.getOrDefault("userIp")
  valid_580456 = validateParameter(valid_580456, JString, required = false,
                                 default = nil)
  if valid_580456 != nil:
    section.add "userIp", valid_580456
  var valid_580457 = query.getOrDefault("key")
  valid_580457 = validateParameter(valid_580457, JString, required = false,
                                 default = nil)
  if valid_580457 != nil:
    section.add "key", valid_580457
  var valid_580458 = query.getOrDefault("generation")
  valid_580458 = validateParameter(valid_580458, JString, required = false,
                                 default = nil)
  if valid_580458 != nil:
    section.add "generation", valid_580458
  var valid_580459 = query.getOrDefault("prettyPrint")
  valid_580459 = validateParameter(valid_580459, JBool, required = false,
                                 default = newJBool(true))
  if valid_580459 != nil:
    section.add "prettyPrint", valid_580459
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

proc call*(call_580461: Call_StorageObjectAccessControlsInsert_580447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_580461.validator(path, query, header, formData, body)
  let scheme = call_580461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580461.url(scheme.get, call_580461.host, call_580461.base,
                         call_580461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580461, url, valid)

proc call*(call_580462: Call_StorageObjectAccessControlsInsert_580447;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; generation: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
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
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580463 = newJObject()
  var query_580464 = newJObject()
  var body_580465 = newJObject()
  add(path_580463, "bucket", newJString(bucket))
  add(query_580464, "fields", newJString(fields))
  add(query_580464, "quotaUser", newJString(quotaUser))
  add(query_580464, "alt", newJString(alt))
  add(query_580464, "oauth_token", newJString(oauthToken))
  add(query_580464, "userIp", newJString(userIp))
  add(query_580464, "key", newJString(key))
  add(query_580464, "generation", newJString(generation))
  if body != nil:
    body_580465 = body
  add(query_580464, "prettyPrint", newJBool(prettyPrint))
  add(path_580463, "object", newJString(`object`))
  result = call_580462.call(path_580463, query_580464, nil, nil, body_580465)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_580447(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_580448,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsInsert_580449,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_580430 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsList_580432(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsList_580431(path: JsonNode;
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
  var valid_580433 = path.getOrDefault("bucket")
  valid_580433 = validateParameter(valid_580433, JString, required = true,
                                 default = nil)
  if valid_580433 != nil:
    section.add "bucket", valid_580433
  var valid_580434 = path.getOrDefault("object")
  valid_580434 = validateParameter(valid_580434, JString, required = true,
                                 default = nil)
  if valid_580434 != nil:
    section.add "object", valid_580434
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
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580435 = query.getOrDefault("fields")
  valid_580435 = validateParameter(valid_580435, JString, required = false,
                                 default = nil)
  if valid_580435 != nil:
    section.add "fields", valid_580435
  var valid_580436 = query.getOrDefault("quotaUser")
  valid_580436 = validateParameter(valid_580436, JString, required = false,
                                 default = nil)
  if valid_580436 != nil:
    section.add "quotaUser", valid_580436
  var valid_580437 = query.getOrDefault("alt")
  valid_580437 = validateParameter(valid_580437, JString, required = false,
                                 default = newJString("json"))
  if valid_580437 != nil:
    section.add "alt", valid_580437
  var valid_580438 = query.getOrDefault("oauth_token")
  valid_580438 = validateParameter(valid_580438, JString, required = false,
                                 default = nil)
  if valid_580438 != nil:
    section.add "oauth_token", valid_580438
  var valid_580439 = query.getOrDefault("userIp")
  valid_580439 = validateParameter(valid_580439, JString, required = false,
                                 default = nil)
  if valid_580439 != nil:
    section.add "userIp", valid_580439
  var valid_580440 = query.getOrDefault("key")
  valid_580440 = validateParameter(valid_580440, JString, required = false,
                                 default = nil)
  if valid_580440 != nil:
    section.add "key", valid_580440
  var valid_580441 = query.getOrDefault("generation")
  valid_580441 = validateParameter(valid_580441, JString, required = false,
                                 default = nil)
  if valid_580441 != nil:
    section.add "generation", valid_580441
  var valid_580442 = query.getOrDefault("prettyPrint")
  valid_580442 = validateParameter(valid_580442, JBool, required = false,
                                 default = newJBool(true))
  if valid_580442 != nil:
    section.add "prettyPrint", valid_580442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580443: Call_StorageObjectAccessControlsList_580430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_580443.validator(path, query, header, formData, body)
  let scheme = call_580443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580443.url(scheme.get, call_580443.host, call_580443.base,
                         call_580443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580443, url, valid)

proc call*(call_580444: Call_StorageObjectAccessControlsList_580430;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; generation: string = ""; prettyPrint: bool = true): Recallable =
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
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580445 = newJObject()
  var query_580446 = newJObject()
  add(path_580445, "bucket", newJString(bucket))
  add(query_580446, "fields", newJString(fields))
  add(query_580446, "quotaUser", newJString(quotaUser))
  add(query_580446, "alt", newJString(alt))
  add(query_580446, "oauth_token", newJString(oauthToken))
  add(query_580446, "userIp", newJString(userIp))
  add(query_580446, "key", newJString(key))
  add(query_580446, "generation", newJString(generation))
  add(query_580446, "prettyPrint", newJBool(prettyPrint))
  add(path_580445, "object", newJString(`object`))
  result = call_580444.call(path_580445, query_580446, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_580430(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_580431,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsList_580432,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_580484 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsUpdate_580486(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsUpdate_580485(path: JsonNode;
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
  var valid_580487 = path.getOrDefault("bucket")
  valid_580487 = validateParameter(valid_580487, JString, required = true,
                                 default = nil)
  if valid_580487 != nil:
    section.add "bucket", valid_580487
  var valid_580488 = path.getOrDefault("entity")
  valid_580488 = validateParameter(valid_580488, JString, required = true,
                                 default = nil)
  if valid_580488 != nil:
    section.add "entity", valid_580488
  var valid_580489 = path.getOrDefault("object")
  valid_580489 = validateParameter(valid_580489, JString, required = true,
                                 default = nil)
  if valid_580489 != nil:
    section.add "object", valid_580489
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
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580490 = query.getOrDefault("fields")
  valid_580490 = validateParameter(valid_580490, JString, required = false,
                                 default = nil)
  if valid_580490 != nil:
    section.add "fields", valid_580490
  var valid_580491 = query.getOrDefault("quotaUser")
  valid_580491 = validateParameter(valid_580491, JString, required = false,
                                 default = nil)
  if valid_580491 != nil:
    section.add "quotaUser", valid_580491
  var valid_580492 = query.getOrDefault("alt")
  valid_580492 = validateParameter(valid_580492, JString, required = false,
                                 default = newJString("json"))
  if valid_580492 != nil:
    section.add "alt", valid_580492
  var valid_580493 = query.getOrDefault("oauth_token")
  valid_580493 = validateParameter(valid_580493, JString, required = false,
                                 default = nil)
  if valid_580493 != nil:
    section.add "oauth_token", valid_580493
  var valid_580494 = query.getOrDefault("userIp")
  valid_580494 = validateParameter(valid_580494, JString, required = false,
                                 default = nil)
  if valid_580494 != nil:
    section.add "userIp", valid_580494
  var valid_580495 = query.getOrDefault("key")
  valid_580495 = validateParameter(valid_580495, JString, required = false,
                                 default = nil)
  if valid_580495 != nil:
    section.add "key", valid_580495
  var valid_580496 = query.getOrDefault("generation")
  valid_580496 = validateParameter(valid_580496, JString, required = false,
                                 default = nil)
  if valid_580496 != nil:
    section.add "generation", valid_580496
  var valid_580497 = query.getOrDefault("prettyPrint")
  valid_580497 = validateParameter(valid_580497, JBool, required = false,
                                 default = newJBool(true))
  if valid_580497 != nil:
    section.add "prettyPrint", valid_580497
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

proc call*(call_580499: Call_StorageObjectAccessControlsUpdate_580484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_580499.validator(path, query, header, formData, body)
  let scheme = call_580499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580499.url(scheme.get, call_580499.host, call_580499.base,
                         call_580499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580499, url, valid)

proc call*(call_580500: Call_StorageObjectAccessControlsUpdate_580484;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580501 = newJObject()
  var query_580502 = newJObject()
  var body_580503 = newJObject()
  add(path_580501, "bucket", newJString(bucket))
  add(query_580502, "fields", newJString(fields))
  add(query_580502, "quotaUser", newJString(quotaUser))
  add(query_580502, "alt", newJString(alt))
  add(query_580502, "oauth_token", newJString(oauthToken))
  add(query_580502, "userIp", newJString(userIp))
  add(query_580502, "key", newJString(key))
  add(query_580502, "generation", newJString(generation))
  if body != nil:
    body_580503 = body
  add(query_580502, "prettyPrint", newJBool(prettyPrint))
  add(path_580501, "entity", newJString(entity))
  add(path_580501, "object", newJString(`object`))
  result = call_580500.call(path_580501, query_580502, nil, nil, body_580503)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_580484(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_580485,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsUpdate_580486,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_580466 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsGet_580468(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsGet_580467(path: JsonNode;
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
  var valid_580469 = path.getOrDefault("bucket")
  valid_580469 = validateParameter(valid_580469, JString, required = true,
                                 default = nil)
  if valid_580469 != nil:
    section.add "bucket", valid_580469
  var valid_580470 = path.getOrDefault("entity")
  valid_580470 = validateParameter(valid_580470, JString, required = true,
                                 default = nil)
  if valid_580470 != nil:
    section.add "entity", valid_580470
  var valid_580471 = path.getOrDefault("object")
  valid_580471 = validateParameter(valid_580471, JString, required = true,
                                 default = nil)
  if valid_580471 != nil:
    section.add "object", valid_580471
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
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580472 = query.getOrDefault("fields")
  valid_580472 = validateParameter(valid_580472, JString, required = false,
                                 default = nil)
  if valid_580472 != nil:
    section.add "fields", valid_580472
  var valid_580473 = query.getOrDefault("quotaUser")
  valid_580473 = validateParameter(valid_580473, JString, required = false,
                                 default = nil)
  if valid_580473 != nil:
    section.add "quotaUser", valid_580473
  var valid_580474 = query.getOrDefault("alt")
  valid_580474 = validateParameter(valid_580474, JString, required = false,
                                 default = newJString("json"))
  if valid_580474 != nil:
    section.add "alt", valid_580474
  var valid_580475 = query.getOrDefault("oauth_token")
  valid_580475 = validateParameter(valid_580475, JString, required = false,
                                 default = nil)
  if valid_580475 != nil:
    section.add "oauth_token", valid_580475
  var valid_580476 = query.getOrDefault("userIp")
  valid_580476 = validateParameter(valid_580476, JString, required = false,
                                 default = nil)
  if valid_580476 != nil:
    section.add "userIp", valid_580476
  var valid_580477 = query.getOrDefault("key")
  valid_580477 = validateParameter(valid_580477, JString, required = false,
                                 default = nil)
  if valid_580477 != nil:
    section.add "key", valid_580477
  var valid_580478 = query.getOrDefault("generation")
  valid_580478 = validateParameter(valid_580478, JString, required = false,
                                 default = nil)
  if valid_580478 != nil:
    section.add "generation", valid_580478
  var valid_580479 = query.getOrDefault("prettyPrint")
  valid_580479 = validateParameter(valid_580479, JBool, required = false,
                                 default = newJBool(true))
  if valid_580479 != nil:
    section.add "prettyPrint", valid_580479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580480: Call_StorageObjectAccessControlsGet_580466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580480.validator(path, query, header, formData, body)
  let scheme = call_580480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580480.url(scheme.get, call_580480.host, call_580480.base,
                         call_580480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580480, url, valid)

proc call*(call_580481: Call_StorageObjectAccessControlsGet_580466; bucket: string;
          entity: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; generation: string = ""; prettyPrint: bool = true): Recallable =
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
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580482 = newJObject()
  var query_580483 = newJObject()
  add(path_580482, "bucket", newJString(bucket))
  add(query_580483, "fields", newJString(fields))
  add(query_580483, "quotaUser", newJString(quotaUser))
  add(query_580483, "alt", newJString(alt))
  add(query_580483, "oauth_token", newJString(oauthToken))
  add(query_580483, "userIp", newJString(userIp))
  add(query_580483, "key", newJString(key))
  add(query_580483, "generation", newJString(generation))
  add(query_580483, "prettyPrint", newJBool(prettyPrint))
  add(path_580482, "entity", newJString(entity))
  add(path_580482, "object", newJString(`object`))
  result = call_580481.call(path_580482, query_580483, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_580466(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_580467,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsGet_580468,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_580522 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsPatch_580524(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsPatch_580523(path: JsonNode;
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
  var valid_580525 = path.getOrDefault("bucket")
  valid_580525 = validateParameter(valid_580525, JString, required = true,
                                 default = nil)
  if valid_580525 != nil:
    section.add "bucket", valid_580525
  var valid_580526 = path.getOrDefault("entity")
  valid_580526 = validateParameter(valid_580526, JString, required = true,
                                 default = nil)
  if valid_580526 != nil:
    section.add "entity", valid_580526
  var valid_580527 = path.getOrDefault("object")
  valid_580527 = validateParameter(valid_580527, JString, required = true,
                                 default = nil)
  if valid_580527 != nil:
    section.add "object", valid_580527
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
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580528 = query.getOrDefault("fields")
  valid_580528 = validateParameter(valid_580528, JString, required = false,
                                 default = nil)
  if valid_580528 != nil:
    section.add "fields", valid_580528
  var valid_580529 = query.getOrDefault("quotaUser")
  valid_580529 = validateParameter(valid_580529, JString, required = false,
                                 default = nil)
  if valid_580529 != nil:
    section.add "quotaUser", valid_580529
  var valid_580530 = query.getOrDefault("alt")
  valid_580530 = validateParameter(valid_580530, JString, required = false,
                                 default = newJString("json"))
  if valid_580530 != nil:
    section.add "alt", valid_580530
  var valid_580531 = query.getOrDefault("oauth_token")
  valid_580531 = validateParameter(valid_580531, JString, required = false,
                                 default = nil)
  if valid_580531 != nil:
    section.add "oauth_token", valid_580531
  var valid_580532 = query.getOrDefault("userIp")
  valid_580532 = validateParameter(valid_580532, JString, required = false,
                                 default = nil)
  if valid_580532 != nil:
    section.add "userIp", valid_580532
  var valid_580533 = query.getOrDefault("key")
  valid_580533 = validateParameter(valid_580533, JString, required = false,
                                 default = nil)
  if valid_580533 != nil:
    section.add "key", valid_580533
  var valid_580534 = query.getOrDefault("generation")
  valid_580534 = validateParameter(valid_580534, JString, required = false,
                                 default = nil)
  if valid_580534 != nil:
    section.add "generation", valid_580534
  var valid_580535 = query.getOrDefault("prettyPrint")
  valid_580535 = validateParameter(valid_580535, JBool, required = false,
                                 default = newJBool(true))
  if valid_580535 != nil:
    section.add "prettyPrint", valid_580535
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

proc call*(call_580537: Call_StorageObjectAccessControlsPatch_580522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  let valid = call_580537.validator(path, query, header, formData, body)
  let scheme = call_580537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580537.url(scheme.get, call_580537.host, call_580537.base,
                         call_580537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580537, url, valid)

proc call*(call_580538: Call_StorageObjectAccessControlsPatch_580522;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
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
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580539 = newJObject()
  var query_580540 = newJObject()
  var body_580541 = newJObject()
  add(path_580539, "bucket", newJString(bucket))
  add(query_580540, "fields", newJString(fields))
  add(query_580540, "quotaUser", newJString(quotaUser))
  add(query_580540, "alt", newJString(alt))
  add(query_580540, "oauth_token", newJString(oauthToken))
  add(query_580540, "userIp", newJString(userIp))
  add(query_580540, "key", newJString(key))
  add(query_580540, "generation", newJString(generation))
  if body != nil:
    body_580541 = body
  add(query_580540, "prettyPrint", newJBool(prettyPrint))
  add(path_580539, "entity", newJString(entity))
  add(path_580539, "object", newJString(`object`))
  result = call_580538.call(path_580539, query_580540, nil, nil, body_580541)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_580522(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_580523,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsPatch_580524,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_580504 = ref object of OpenApiRestCall_579424
proc url_StorageObjectAccessControlsDelete_580506(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsDelete_580505(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
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
  var valid_580507 = path.getOrDefault("bucket")
  valid_580507 = validateParameter(valid_580507, JString, required = true,
                                 default = nil)
  if valid_580507 != nil:
    section.add "bucket", valid_580507
  var valid_580508 = path.getOrDefault("entity")
  valid_580508 = validateParameter(valid_580508, JString, required = true,
                                 default = nil)
  if valid_580508 != nil:
    section.add "entity", valid_580508
  var valid_580509 = path.getOrDefault("object")
  valid_580509 = validateParameter(valid_580509, JString, required = true,
                                 default = nil)
  if valid_580509 != nil:
    section.add "object", valid_580509
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
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580510 = query.getOrDefault("fields")
  valid_580510 = validateParameter(valid_580510, JString, required = false,
                                 default = nil)
  if valid_580510 != nil:
    section.add "fields", valid_580510
  var valid_580511 = query.getOrDefault("quotaUser")
  valid_580511 = validateParameter(valid_580511, JString, required = false,
                                 default = nil)
  if valid_580511 != nil:
    section.add "quotaUser", valid_580511
  var valid_580512 = query.getOrDefault("alt")
  valid_580512 = validateParameter(valid_580512, JString, required = false,
                                 default = newJString("json"))
  if valid_580512 != nil:
    section.add "alt", valid_580512
  var valid_580513 = query.getOrDefault("oauth_token")
  valid_580513 = validateParameter(valid_580513, JString, required = false,
                                 default = nil)
  if valid_580513 != nil:
    section.add "oauth_token", valid_580513
  var valid_580514 = query.getOrDefault("userIp")
  valid_580514 = validateParameter(valid_580514, JString, required = false,
                                 default = nil)
  if valid_580514 != nil:
    section.add "userIp", valid_580514
  var valid_580515 = query.getOrDefault("key")
  valid_580515 = validateParameter(valid_580515, JString, required = false,
                                 default = nil)
  if valid_580515 != nil:
    section.add "key", valid_580515
  var valid_580516 = query.getOrDefault("generation")
  valid_580516 = validateParameter(valid_580516, JString, required = false,
                                 default = nil)
  if valid_580516 != nil:
    section.add "generation", valid_580516
  var valid_580517 = query.getOrDefault("prettyPrint")
  valid_580517 = validateParameter(valid_580517, JBool, required = false,
                                 default = newJBool(true))
  if valid_580517 != nil:
    section.add "prettyPrint", valid_580517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_580518: Call_StorageObjectAccessControlsDelete_580504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_580518.validator(path, query, header, formData, body)
  let scheme = call_580518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580518.url(scheme.get, call_580518.host, call_580518.base,
                         call_580518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580518, url, valid)

proc call*(call_580519: Call_StorageObjectAccessControlsDelete_580504;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; generation: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageObjectAccessControlsDelete
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
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
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object.
  var path_580520 = newJObject()
  var query_580521 = newJObject()
  add(path_580520, "bucket", newJString(bucket))
  add(query_580521, "fields", newJString(fields))
  add(query_580521, "quotaUser", newJString(quotaUser))
  add(query_580521, "alt", newJString(alt))
  add(query_580521, "oauth_token", newJString(oauthToken))
  add(query_580521, "userIp", newJString(userIp))
  add(query_580521, "key", newJString(key))
  add(query_580521, "generation", newJString(generation))
  add(query_580521, "prettyPrint", newJBool(prettyPrint))
  add(path_580520, "entity", newJString(entity))
  add(path_580520, "object", newJString(`object`))
  result = call_580519.call(path_580520, query_580521, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_580504(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_580505,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsDelete_580506,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_580542 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsCompose_580544(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject"),
               (kind: ConstantSegment, value: "/compose")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsCompose_580543(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_580545 = path.getOrDefault("destinationBucket")
  valid_580545 = validateParameter(valid_580545, JString, required = true,
                                 default = nil)
  if valid_580545 != nil:
    section.add "destinationBucket", valid_580545
  var valid_580546 = path.getOrDefault("destinationObject")
  valid_580546 = validateParameter(valid_580546, JString, required = true,
                                 default = nil)
  if valid_580546 != nil:
    section.add "destinationObject", valid_580546
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
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
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580547 = query.getOrDefault("ifGenerationMatch")
  valid_580547 = validateParameter(valid_580547, JString, required = false,
                                 default = nil)
  if valid_580547 != nil:
    section.add "ifGenerationMatch", valid_580547
  var valid_580548 = query.getOrDefault("fields")
  valid_580548 = validateParameter(valid_580548, JString, required = false,
                                 default = nil)
  if valid_580548 != nil:
    section.add "fields", valid_580548
  var valid_580549 = query.getOrDefault("quotaUser")
  valid_580549 = validateParameter(valid_580549, JString, required = false,
                                 default = nil)
  if valid_580549 != nil:
    section.add "quotaUser", valid_580549
  var valid_580550 = query.getOrDefault("alt")
  valid_580550 = validateParameter(valid_580550, JString, required = false,
                                 default = newJString("json"))
  if valid_580550 != nil:
    section.add "alt", valid_580550
  var valid_580551 = query.getOrDefault("oauth_token")
  valid_580551 = validateParameter(valid_580551, JString, required = false,
                                 default = nil)
  if valid_580551 != nil:
    section.add "oauth_token", valid_580551
  var valid_580552 = query.getOrDefault("userIp")
  valid_580552 = validateParameter(valid_580552, JString, required = false,
                                 default = nil)
  if valid_580552 != nil:
    section.add "userIp", valid_580552
  var valid_580553 = query.getOrDefault("key")
  valid_580553 = validateParameter(valid_580553, JString, required = false,
                                 default = nil)
  if valid_580553 != nil:
    section.add "key", valid_580553
  var valid_580554 = query.getOrDefault("ifMetagenerationMatch")
  valid_580554 = validateParameter(valid_580554, JString, required = false,
                                 default = nil)
  if valid_580554 != nil:
    section.add "ifMetagenerationMatch", valid_580554
  var valid_580555 = query.getOrDefault("prettyPrint")
  valid_580555 = validateParameter(valid_580555, JBool, required = false,
                                 default = newJBool(true))
  if valid_580555 != nil:
    section.add "prettyPrint", valid_580555
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

proc call*(call_580557: Call_StorageObjectsCompose_580542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_580557.validator(path, query, header, formData, body)
  let scheme = call_580557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580557.url(scheme.get, call_580557.host, call_580557.base,
                         call_580557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580557, url, valid)

proc call*(call_580558: Call_StorageObjectsCompose_580542;
          destinationBucket: string; destinationObject: string;
          ifGenerationMatch: string = ""; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          key: string = ""; ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storageObjectsCompose
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationObject: string (required)
  ##                    : Name of the new object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_580559 = newJObject()
  var query_580560 = newJObject()
  var body_580561 = newJObject()
  add(query_580560, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580560, "fields", newJString(fields))
  add(query_580560, "quotaUser", newJString(quotaUser))
  add(query_580560, "alt", newJString(alt))
  add(query_580560, "oauth_token", newJString(oauthToken))
  add(path_580559, "destinationBucket", newJString(destinationBucket))
  add(query_580560, "userIp", newJString(userIp))
  add(path_580559, "destinationObject", newJString(destinationObject))
  add(query_580560, "key", newJString(key))
  add(query_580560, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_580561 = body
  add(query_580560, "prettyPrint", newJBool(prettyPrint))
  result = call_580558.call(path_580559, query_580560, nil, nil, body_580561)

var storageObjectsCompose* = Call_StorageObjectsCompose_580542(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_580543, base: "/storage/v1beta2",
    url: url_StorageObjectsCompose_580544, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_580562 = ref object of OpenApiRestCall_579424
proc url_StorageObjectsCopy_580564(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  assert path != nil, "path is required to populate template"
  assert "sourceBucket" in path, "`sourceBucket` is a required path parameter"
  assert "sourceObject" in path, "`sourceObject` is a required path parameter"
  assert "destinationBucket" in path,
        "`destinationBucket` is a required path parameter"
  assert "destinationObject" in path,
        "`destinationObject` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "sourceBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "sourceObject"),
               (kind: ConstantSegment, value: "/copyTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsCopy_580563(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  ##   sourceObject: JString (required)
  ##               : Name of the source object.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_580565 = path.getOrDefault("destinationBucket")
  valid_580565 = validateParameter(valid_580565, JString, required = true,
                                 default = nil)
  if valid_580565 != nil:
    section.add "destinationBucket", valid_580565
  var valid_580566 = path.getOrDefault("destinationObject")
  valid_580566 = validateParameter(valid_580566, JString, required = true,
                                 default = nil)
  if valid_580566 != nil:
    section.add "destinationObject", valid_580566
  var valid_580567 = path.getOrDefault("sourceBucket")
  valid_580567 = validateParameter(valid_580567, JString, required = true,
                                 default = nil)
  if valid_580567 != nil:
    section.add "sourceBucket", valid_580567
  var valid_580568 = path.getOrDefault("sourceObject")
  valid_580568 = validateParameter(valid_580568, JString, required = true,
                                 default = nil)
  if valid_580568 != nil:
    section.add "sourceObject", valid_580568
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value.
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's generation does not match the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  section = newJObject()
  var valid_580569 = query.getOrDefault("ifGenerationMatch")
  valid_580569 = validateParameter(valid_580569, JString, required = false,
                                 default = nil)
  if valid_580569 != nil:
    section.add "ifGenerationMatch", valid_580569
  var valid_580570 = query.getOrDefault("ifSourceGenerationMatch")
  valid_580570 = validateParameter(valid_580570, JString, required = false,
                                 default = nil)
  if valid_580570 != nil:
    section.add "ifSourceGenerationMatch", valid_580570
  var valid_580571 = query.getOrDefault("fields")
  valid_580571 = validateParameter(valid_580571, JString, required = false,
                                 default = nil)
  if valid_580571 != nil:
    section.add "fields", valid_580571
  var valid_580572 = query.getOrDefault("quotaUser")
  valid_580572 = validateParameter(valid_580572, JString, required = false,
                                 default = nil)
  if valid_580572 != nil:
    section.add "quotaUser", valid_580572
  var valid_580573 = query.getOrDefault("alt")
  valid_580573 = validateParameter(valid_580573, JString, required = false,
                                 default = newJString("json"))
  if valid_580573 != nil:
    section.add "alt", valid_580573
  var valid_580574 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_580574 = validateParameter(valid_580574, JString, required = false,
                                 default = nil)
  if valid_580574 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_580574
  var valid_580575 = query.getOrDefault("ifGenerationNotMatch")
  valid_580575 = validateParameter(valid_580575, JString, required = false,
                                 default = nil)
  if valid_580575 != nil:
    section.add "ifGenerationNotMatch", valid_580575
  var valid_580576 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_580576 = validateParameter(valid_580576, JString, required = false,
                                 default = nil)
  if valid_580576 != nil:
    section.add "ifSourceMetagenerationMatch", valid_580576
  var valid_580577 = query.getOrDefault("oauth_token")
  valid_580577 = validateParameter(valid_580577, JString, required = false,
                                 default = nil)
  if valid_580577 != nil:
    section.add "oauth_token", valid_580577
  var valid_580578 = query.getOrDefault("sourceGeneration")
  valid_580578 = validateParameter(valid_580578, JString, required = false,
                                 default = nil)
  if valid_580578 != nil:
    section.add "sourceGeneration", valid_580578
  var valid_580579 = query.getOrDefault("userIp")
  valid_580579 = validateParameter(valid_580579, JString, required = false,
                                 default = nil)
  if valid_580579 != nil:
    section.add "userIp", valid_580579
  var valid_580580 = query.getOrDefault("key")
  valid_580580 = validateParameter(valid_580580, JString, required = false,
                                 default = nil)
  if valid_580580 != nil:
    section.add "key", valid_580580
  var valid_580581 = query.getOrDefault("projection")
  valid_580581 = validateParameter(valid_580581, JString, required = false,
                                 default = newJString("full"))
  if valid_580581 != nil:
    section.add "projection", valid_580581
  var valid_580582 = query.getOrDefault("ifMetagenerationMatch")
  valid_580582 = validateParameter(valid_580582, JString, required = false,
                                 default = nil)
  if valid_580582 != nil:
    section.add "ifMetagenerationMatch", valid_580582
  var valid_580583 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_580583 = validateParameter(valid_580583, JString, required = false,
                                 default = nil)
  if valid_580583 != nil:
    section.add "ifSourceGenerationNotMatch", valid_580583
  var valid_580584 = query.getOrDefault("prettyPrint")
  valid_580584 = validateParameter(valid_580584, JBool, required = false,
                                 default = newJBool(true))
  if valid_580584 != nil:
    section.add "prettyPrint", valid_580584
  var valid_580585 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_580585 = validateParameter(valid_580585, JString, required = false,
                                 default = nil)
  if valid_580585 != nil:
    section.add "ifMetagenerationNotMatch", valid_580585
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

proc call*(call_580587: Call_StorageObjectsCopy_580562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ## 
  let valid = call_580587.validator(path, query, header, formData, body)
  let scheme = call_580587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580587.url(scheme.get, call_580587.host, call_580587.base,
                         call_580587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580587, url, valid)

proc call*(call_580588: Call_StorageObjectsCopy_580562; destinationBucket: string;
          destinationObject: string; sourceBucket: string; sourceObject: string;
          ifGenerationMatch: string = ""; ifSourceGenerationMatch: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ifSourceMetagenerationNotMatch: string = "";
          ifGenerationNotMatch: string = "";
          ifSourceMetagenerationMatch: string = ""; oauthToken: string = "";
          sourceGeneration: string = ""; userIp: string = ""; key: string = "";
          projection: string = "full"; ifMetagenerationMatch: string = "";
          ifSourceGenerationNotMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = ""): Recallable =
  ## storageObjectsCopy
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's generation matches the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value.
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sourceObject: string (required)
  ##               : Name of the source object.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's generation does not match the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  var path_580589 = newJObject()
  var query_580590 = newJObject()
  var body_580591 = newJObject()
  add(query_580590, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_580590, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_580590, "fields", newJString(fields))
  add(query_580590, "quotaUser", newJString(quotaUser))
  add(query_580590, "alt", newJString(alt))
  add(query_580590, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_580590, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_580590, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_580590, "oauth_token", newJString(oauthToken))
  add(query_580590, "sourceGeneration", newJString(sourceGeneration))
  add(path_580589, "destinationBucket", newJString(destinationBucket))
  add(query_580590, "userIp", newJString(userIp))
  add(path_580589, "destinationObject", newJString(destinationObject))
  add(path_580589, "sourceBucket", newJString(sourceBucket))
  add(query_580590, "key", newJString(key))
  add(path_580589, "sourceObject", newJString(sourceObject))
  add(query_580590, "projection", newJString(projection))
  add(query_580590, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_580590, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_580591 = body
  add(query_580590, "prettyPrint", newJBool(prettyPrint))
  add(query_580590, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_580588.call(path_580589, query_580590, nil, nil, body_580591)

var storageObjectsCopy* = Call_StorageObjectsCopy_580562(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_580563, base: "/storage/v1beta2",
    url: url_StorageObjectsCopy_580564, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_580592 = ref object of OpenApiRestCall_579424
proc url_StorageChannelsStop_580594(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageChannelsStop_580593(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Stop watching resources through this channel
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
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_580595 = query.getOrDefault("fields")
  valid_580595 = validateParameter(valid_580595, JString, required = false,
                                 default = nil)
  if valid_580595 != nil:
    section.add "fields", valid_580595
  var valid_580596 = query.getOrDefault("quotaUser")
  valid_580596 = validateParameter(valid_580596, JString, required = false,
                                 default = nil)
  if valid_580596 != nil:
    section.add "quotaUser", valid_580596
  var valid_580597 = query.getOrDefault("alt")
  valid_580597 = validateParameter(valid_580597, JString, required = false,
                                 default = newJString("json"))
  if valid_580597 != nil:
    section.add "alt", valid_580597
  var valid_580598 = query.getOrDefault("oauth_token")
  valid_580598 = validateParameter(valid_580598, JString, required = false,
                                 default = nil)
  if valid_580598 != nil:
    section.add "oauth_token", valid_580598
  var valid_580599 = query.getOrDefault("userIp")
  valid_580599 = validateParameter(valid_580599, JString, required = false,
                                 default = nil)
  if valid_580599 != nil:
    section.add "userIp", valid_580599
  var valid_580600 = query.getOrDefault("key")
  valid_580600 = validateParameter(valid_580600, JString, required = false,
                                 default = nil)
  if valid_580600 != nil:
    section.add "key", valid_580600
  var valid_580601 = query.getOrDefault("prettyPrint")
  valid_580601 = validateParameter(valid_580601, JBool, required = false,
                                 default = newJBool(true))
  if valid_580601 != nil:
    section.add "prettyPrint", valid_580601
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  ## parameters in `body` object:
  ##   resource: JObject
  section = validateParameter(body, JObject, required = false, default = nil)
  if body != nil:
    result.add "body", body

proc call*(call_580603: Call_StorageChannelsStop_580592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_580603.validator(path, query, header, formData, body)
  let scheme = call_580603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_580603.url(scheme.get, call_580603.host, call_580603.base,
                         call_580603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_580603, url, valid)

proc call*(call_580604: Call_StorageChannelsStop_580592; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; key: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true): Recallable =
  ## storageChannelsStop
  ## Stop watching resources through this channel
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
  ##   resource: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var query_580605 = newJObject()
  var body_580606 = newJObject()
  add(query_580605, "fields", newJString(fields))
  add(query_580605, "quotaUser", newJString(quotaUser))
  add(query_580605, "alt", newJString(alt))
  add(query_580605, "oauth_token", newJString(oauthToken))
  add(query_580605, "userIp", newJString(userIp))
  add(query_580605, "key", newJString(key))
  if resource != nil:
    body_580606 = resource
  add(query_580605, "prettyPrint", newJBool(prettyPrint))
  result = call_580604.call(nil, query_580605, nil, nil, body_580606)

var storageChannelsStop* = Call_StorageChannelsStop_580592(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_580593, base: "/storage/v1beta2",
    url: url_StorageChannelsStop_580594, schemes: {Scheme.Https})
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
