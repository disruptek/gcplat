
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

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

  OpenApiRestCall_593424 = ref object of OpenApiRestCall
proc hash(scheme: Scheme): Hash {.used.} =
  result = hash(ord(scheme))

proc clone[T: OpenApiRestCall_593424](t: T): T {.used.} =
  result = T(name: t.name, meth: t.meth, host: t.host, base: t.base, route: t.route,
           schemes: t.schemes, validator: t.validator, url: t.url)

proc pickScheme(t: OpenApiRestCall_593424): Option[Scheme] {.used.} =
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
method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.}
type
  Call_StorageBucketsInsert_593964 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsInsert_593966(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_593965(path: JsonNode; query: JsonNode;
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
  var valid_593967 = query.getOrDefault("fields")
  valid_593967 = validateParameter(valid_593967, JString, required = false,
                                 default = nil)
  if valid_593967 != nil:
    section.add "fields", valid_593967
  var valid_593968 = query.getOrDefault("quotaUser")
  valid_593968 = validateParameter(valid_593968, JString, required = false,
                                 default = nil)
  if valid_593968 != nil:
    section.add "quotaUser", valid_593968
  var valid_593969 = query.getOrDefault("alt")
  valid_593969 = validateParameter(valid_593969, JString, required = false,
                                 default = newJString("json"))
  if valid_593969 != nil:
    section.add "alt", valid_593969
  var valid_593970 = query.getOrDefault("oauth_token")
  valid_593970 = validateParameter(valid_593970, JString, required = false,
                                 default = nil)
  if valid_593970 != nil:
    section.add "oauth_token", valid_593970
  var valid_593971 = query.getOrDefault("userIp")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "userIp", valid_593971
  var valid_593972 = query.getOrDefault("key")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "key", valid_593972
  var valid_593973 = query.getOrDefault("projection")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = newJString("full"))
  if valid_593973 != nil:
    section.add "projection", valid_593973
  var valid_593974 = query.getOrDefault("prettyPrint")
  valid_593974 = validateParameter(valid_593974, JBool, required = false,
                                 default = newJBool(true))
  if valid_593974 != nil:
    section.add "prettyPrint", valid_593974
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_593975 = query.getOrDefault("project")
  valid_593975 = validateParameter(valid_593975, JString, required = true,
                                 default = nil)
  if valid_593975 != nil:
    section.add "project", valid_593975
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

proc call*(call_593977: Call_StorageBucketsInsert_593964; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_593977.validator(path, query, header, formData, body)
  let scheme = call_593977.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593977.url(scheme.get, call_593977.host, call_593977.base,
                         call_593977.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593977, url, valid)

proc call*(call_593978: Call_StorageBucketsInsert_593964; project: string;
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
  var query_593979 = newJObject()
  var body_593980 = newJObject()
  add(query_593979, "fields", newJString(fields))
  add(query_593979, "quotaUser", newJString(quotaUser))
  add(query_593979, "alt", newJString(alt))
  add(query_593979, "oauth_token", newJString(oauthToken))
  add(query_593979, "userIp", newJString(userIp))
  add(query_593979, "key", newJString(key))
  add(query_593979, "projection", newJString(projection))
  if body != nil:
    body_593980 = body
  add(query_593979, "prettyPrint", newJBool(prettyPrint))
  add(query_593979, "project", newJString(project))
  result = call_593978.call(nil, query_593979, nil, nil, body_593980)

var storageBucketsInsert* = Call_StorageBucketsInsert_593964(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_593965, base: "/storage/v1beta2",
    url: url_StorageBucketsInsert_593966, schemes: {Scheme.Https})
type
  Call_StorageBucketsList_593692 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsList_593694(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StorageBucketsList_593693(path: JsonNode; query: JsonNode;
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
  var valid_593806 = query.getOrDefault("fields")
  valid_593806 = validateParameter(valid_593806, JString, required = false,
                                 default = nil)
  if valid_593806 != nil:
    section.add "fields", valid_593806
  var valid_593807 = query.getOrDefault("pageToken")
  valid_593807 = validateParameter(valid_593807, JString, required = false,
                                 default = nil)
  if valid_593807 != nil:
    section.add "pageToken", valid_593807
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
  var valid_593824 = query.getOrDefault("userIp")
  valid_593824 = validateParameter(valid_593824, JString, required = false,
                                 default = nil)
  if valid_593824 != nil:
    section.add "userIp", valid_593824
  var valid_593825 = query.getOrDefault("maxResults")
  valid_593825 = validateParameter(valid_593825, JInt, required = false, default = nil)
  if valid_593825 != nil:
    section.add "maxResults", valid_593825
  var valid_593826 = query.getOrDefault("key")
  valid_593826 = validateParameter(valid_593826, JString, required = false,
                                 default = nil)
  if valid_593826 != nil:
    section.add "key", valid_593826
  var valid_593827 = query.getOrDefault("projection")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = newJString("full"))
  if valid_593827 != nil:
    section.add "projection", valid_593827
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_593828 = query.getOrDefault("project")
  valid_593828 = validateParameter(valid_593828, JString, required = true,
                                 default = nil)
  if valid_593828 != nil:
    section.add "project", valid_593828
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

proc call*(call_593852: Call_StorageBucketsList_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_593852.validator(path, query, header, formData, body)
  let scheme = call_593852.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593852.url(scheme.get, call_593852.host, call_593852.base,
                         call_593852.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593852, url, valid)

proc call*(call_593923: Call_StorageBucketsList_593692; project: string;
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
  var query_593924 = newJObject()
  add(query_593924, "fields", newJString(fields))
  add(query_593924, "pageToken", newJString(pageToken))
  add(query_593924, "quotaUser", newJString(quotaUser))
  add(query_593924, "alt", newJString(alt))
  add(query_593924, "oauth_token", newJString(oauthToken))
  add(query_593924, "userIp", newJString(userIp))
  add(query_593924, "maxResults", newJInt(maxResults))
  add(query_593924, "key", newJString(key))
  add(query_593924, "projection", newJString(projection))
  add(query_593924, "project", newJString(project))
  add(query_593924, "prettyPrint", newJBool(prettyPrint))
  result = call_593923.call(nil, query_593924, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_593692(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b",
    validator: validate_StorageBucketsList_593693, base: "/storage/v1beta2",
    url: url_StorageBucketsList_593694, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_594013 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsUpdate_594015(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsUpdate_594014(path: JsonNode; query: JsonNode;
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
  var valid_594016 = path.getOrDefault("bucket")
  valid_594016 = validateParameter(valid_594016, JString, required = true,
                                 default = nil)
  if valid_594016 != nil:
    section.add "bucket", valid_594016
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
  var valid_594017 = query.getOrDefault("fields")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "fields", valid_594017
  var valid_594018 = query.getOrDefault("quotaUser")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "quotaUser", valid_594018
  var valid_594019 = query.getOrDefault("alt")
  valid_594019 = validateParameter(valid_594019, JString, required = false,
                                 default = newJString("json"))
  if valid_594019 != nil:
    section.add "alt", valid_594019
  var valid_594020 = query.getOrDefault("oauth_token")
  valid_594020 = validateParameter(valid_594020, JString, required = false,
                                 default = nil)
  if valid_594020 != nil:
    section.add "oauth_token", valid_594020
  var valid_594021 = query.getOrDefault("userIp")
  valid_594021 = validateParameter(valid_594021, JString, required = false,
                                 default = nil)
  if valid_594021 != nil:
    section.add "userIp", valid_594021
  var valid_594022 = query.getOrDefault("key")
  valid_594022 = validateParameter(valid_594022, JString, required = false,
                                 default = nil)
  if valid_594022 != nil:
    section.add "key", valid_594022
  var valid_594023 = query.getOrDefault("projection")
  valid_594023 = validateParameter(valid_594023, JString, required = false,
                                 default = newJString("full"))
  if valid_594023 != nil:
    section.add "projection", valid_594023
  var valid_594024 = query.getOrDefault("ifMetagenerationMatch")
  valid_594024 = validateParameter(valid_594024, JString, required = false,
                                 default = nil)
  if valid_594024 != nil:
    section.add "ifMetagenerationMatch", valid_594024
  var valid_594025 = query.getOrDefault("prettyPrint")
  valid_594025 = validateParameter(valid_594025, JBool, required = false,
                                 default = newJBool(true))
  if valid_594025 != nil:
    section.add "prettyPrint", valid_594025
  var valid_594026 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594026 = validateParameter(valid_594026, JString, required = false,
                                 default = nil)
  if valid_594026 != nil:
    section.add "ifMetagenerationNotMatch", valid_594026
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

proc call*(call_594028: Call_StorageBucketsUpdate_594013; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket.
  ## 
  let valid = call_594028.validator(path, query, header, formData, body)
  let scheme = call_594028.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594028.url(scheme.get, call_594028.host, call_594028.base,
                         call_594028.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594028, url, valid)

proc call*(call_594029: Call_StorageBucketsUpdate_594013; bucket: string;
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
  var path_594030 = newJObject()
  var query_594031 = newJObject()
  var body_594032 = newJObject()
  add(path_594030, "bucket", newJString(bucket))
  add(query_594031, "fields", newJString(fields))
  add(query_594031, "quotaUser", newJString(quotaUser))
  add(query_594031, "alt", newJString(alt))
  add(query_594031, "oauth_token", newJString(oauthToken))
  add(query_594031, "userIp", newJString(userIp))
  add(query_594031, "key", newJString(key))
  add(query_594031, "projection", newJString(projection))
  add(query_594031, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594032 = body
  add(query_594031, "prettyPrint", newJBool(prettyPrint))
  add(query_594031, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_594029.call(path_594030, query_594031, nil, nil, body_594032)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_594013(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_594014, base: "/storage/v1beta2",
    url: url_StorageBucketsUpdate_594015, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_593981 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsGet_593983(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsGet_593982(path: JsonNode; query: JsonNode;
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
  var valid_593998 = path.getOrDefault("bucket")
  valid_593998 = validateParameter(valid_593998, JString, required = true,
                                 default = nil)
  if valid_593998 != nil:
    section.add "bucket", valid_593998
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
  var valid_593999 = query.getOrDefault("fields")
  valid_593999 = validateParameter(valid_593999, JString, required = false,
                                 default = nil)
  if valid_593999 != nil:
    section.add "fields", valid_593999
  var valid_594000 = query.getOrDefault("quotaUser")
  valid_594000 = validateParameter(valid_594000, JString, required = false,
                                 default = nil)
  if valid_594000 != nil:
    section.add "quotaUser", valid_594000
  var valid_594001 = query.getOrDefault("alt")
  valid_594001 = validateParameter(valid_594001, JString, required = false,
                                 default = newJString("json"))
  if valid_594001 != nil:
    section.add "alt", valid_594001
  var valid_594002 = query.getOrDefault("oauth_token")
  valid_594002 = validateParameter(valid_594002, JString, required = false,
                                 default = nil)
  if valid_594002 != nil:
    section.add "oauth_token", valid_594002
  var valid_594003 = query.getOrDefault("userIp")
  valid_594003 = validateParameter(valid_594003, JString, required = false,
                                 default = nil)
  if valid_594003 != nil:
    section.add "userIp", valid_594003
  var valid_594004 = query.getOrDefault("key")
  valid_594004 = validateParameter(valid_594004, JString, required = false,
                                 default = nil)
  if valid_594004 != nil:
    section.add "key", valid_594004
  var valid_594005 = query.getOrDefault("projection")
  valid_594005 = validateParameter(valid_594005, JString, required = false,
                                 default = newJString("full"))
  if valid_594005 != nil:
    section.add "projection", valid_594005
  var valid_594006 = query.getOrDefault("ifMetagenerationMatch")
  valid_594006 = validateParameter(valid_594006, JString, required = false,
                                 default = nil)
  if valid_594006 != nil:
    section.add "ifMetagenerationMatch", valid_594006
  var valid_594007 = query.getOrDefault("prettyPrint")
  valid_594007 = validateParameter(valid_594007, JBool, required = false,
                                 default = newJBool(true))
  if valid_594007 != nil:
    section.add "prettyPrint", valid_594007
  var valid_594008 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "ifMetagenerationNotMatch", valid_594008
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594009: Call_StorageBucketsGet_593981; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_594009.validator(path, query, header, formData, body)
  let scheme = call_594009.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594009.url(scheme.get, call_594009.host, call_594009.base,
                         call_594009.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594009, url, valid)

proc call*(call_594010: Call_StorageBucketsGet_593981; bucket: string;
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
  var path_594011 = newJObject()
  var query_594012 = newJObject()
  add(path_594011, "bucket", newJString(bucket))
  add(query_594012, "fields", newJString(fields))
  add(query_594012, "quotaUser", newJString(quotaUser))
  add(query_594012, "alt", newJString(alt))
  add(query_594012, "oauth_token", newJString(oauthToken))
  add(query_594012, "userIp", newJString(userIp))
  add(query_594012, "key", newJString(key))
  add(query_594012, "projection", newJString(projection))
  add(query_594012, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594012, "prettyPrint", newJBool(prettyPrint))
  add(query_594012, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_594010.call(path_594011, query_594012, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_593981(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_593982, base: "/storage/v1beta2",
    url: url_StorageBucketsGet_593983, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_594050 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsPatch_594052(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsPatch_594051(path: JsonNode; query: JsonNode;
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
  var valid_594053 = path.getOrDefault("bucket")
  valid_594053 = validateParameter(valid_594053, JString, required = true,
                                 default = nil)
  if valid_594053 != nil:
    section.add "bucket", valid_594053
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
  var valid_594054 = query.getOrDefault("fields")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "fields", valid_594054
  var valid_594055 = query.getOrDefault("quotaUser")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "quotaUser", valid_594055
  var valid_594056 = query.getOrDefault("alt")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = newJString("json"))
  if valid_594056 != nil:
    section.add "alt", valid_594056
  var valid_594057 = query.getOrDefault("oauth_token")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "oauth_token", valid_594057
  var valid_594058 = query.getOrDefault("userIp")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "userIp", valid_594058
  var valid_594059 = query.getOrDefault("key")
  valid_594059 = validateParameter(valid_594059, JString, required = false,
                                 default = nil)
  if valid_594059 != nil:
    section.add "key", valid_594059
  var valid_594060 = query.getOrDefault("projection")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = newJString("full"))
  if valid_594060 != nil:
    section.add "projection", valid_594060
  var valid_594061 = query.getOrDefault("ifMetagenerationMatch")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "ifMetagenerationMatch", valid_594061
  var valid_594062 = query.getOrDefault("prettyPrint")
  valid_594062 = validateParameter(valid_594062, JBool, required = false,
                                 default = newJBool(true))
  if valid_594062 != nil:
    section.add "prettyPrint", valid_594062
  var valid_594063 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594063 = validateParameter(valid_594063, JString, required = false,
                                 default = nil)
  if valid_594063 != nil:
    section.add "ifMetagenerationNotMatch", valid_594063
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

proc call*(call_594065: Call_StorageBucketsPatch_594050; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. This method supports patch semantics.
  ## 
  let valid = call_594065.validator(path, query, header, formData, body)
  let scheme = call_594065.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594065.url(scheme.get, call_594065.host, call_594065.base,
                         call_594065.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594065, url, valid)

proc call*(call_594066: Call_StorageBucketsPatch_594050; bucket: string;
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
  var path_594067 = newJObject()
  var query_594068 = newJObject()
  var body_594069 = newJObject()
  add(path_594067, "bucket", newJString(bucket))
  add(query_594068, "fields", newJString(fields))
  add(query_594068, "quotaUser", newJString(quotaUser))
  add(query_594068, "alt", newJString(alt))
  add(query_594068, "oauth_token", newJString(oauthToken))
  add(query_594068, "userIp", newJString(userIp))
  add(query_594068, "key", newJString(key))
  add(query_594068, "projection", newJString(projection))
  add(query_594068, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594069 = body
  add(query_594068, "prettyPrint", newJBool(prettyPrint))
  add(query_594068, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_594066.call(path_594067, query_594068, nil, nil, body_594069)

var storageBucketsPatch* = Call_StorageBucketsPatch_594050(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_594051, base: "/storage/v1beta2",
    url: url_StorageBucketsPatch_594052, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_594033 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsDelete_594035(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsDelete_594034(path: JsonNode; query: JsonNode;
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
  var valid_594036 = path.getOrDefault("bucket")
  valid_594036 = validateParameter(valid_594036, JString, required = true,
                                 default = nil)
  if valid_594036 != nil:
    section.add "bucket", valid_594036
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
  var valid_594037 = query.getOrDefault("fields")
  valid_594037 = validateParameter(valid_594037, JString, required = false,
                                 default = nil)
  if valid_594037 != nil:
    section.add "fields", valid_594037
  var valid_594038 = query.getOrDefault("quotaUser")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "quotaUser", valid_594038
  var valid_594039 = query.getOrDefault("alt")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("json"))
  if valid_594039 != nil:
    section.add "alt", valid_594039
  var valid_594040 = query.getOrDefault("oauth_token")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "oauth_token", valid_594040
  var valid_594041 = query.getOrDefault("userIp")
  valid_594041 = validateParameter(valid_594041, JString, required = false,
                                 default = nil)
  if valid_594041 != nil:
    section.add "userIp", valid_594041
  var valid_594042 = query.getOrDefault("key")
  valid_594042 = validateParameter(valid_594042, JString, required = false,
                                 default = nil)
  if valid_594042 != nil:
    section.add "key", valid_594042
  var valid_594043 = query.getOrDefault("ifMetagenerationMatch")
  valid_594043 = validateParameter(valid_594043, JString, required = false,
                                 default = nil)
  if valid_594043 != nil:
    section.add "ifMetagenerationMatch", valid_594043
  var valid_594044 = query.getOrDefault("prettyPrint")
  valid_594044 = validateParameter(valid_594044, JBool, required = false,
                                 default = newJBool(true))
  if valid_594044 != nil:
    section.add "prettyPrint", valid_594044
  var valid_594045 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594045 = validateParameter(valid_594045, JString, required = false,
                                 default = nil)
  if valid_594045 != nil:
    section.add "ifMetagenerationNotMatch", valid_594045
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594046: Call_StorageBucketsDelete_594033; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_594046.validator(path, query, header, formData, body)
  let scheme = call_594046.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594046.url(scheme.get, call_594046.host, call_594046.base,
                         call_594046.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594046, url, valid)

proc call*(call_594047: Call_StorageBucketsDelete_594033; bucket: string;
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
  var path_594048 = newJObject()
  var query_594049 = newJObject()
  add(path_594048, "bucket", newJString(bucket))
  add(query_594049, "fields", newJString(fields))
  add(query_594049, "quotaUser", newJString(quotaUser))
  add(query_594049, "alt", newJString(alt))
  add(query_594049, "oauth_token", newJString(oauthToken))
  add(query_594049, "userIp", newJString(userIp))
  add(query_594049, "key", newJString(key))
  add(query_594049, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594049, "prettyPrint", newJBool(prettyPrint))
  add(query_594049, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_594047.call(path_594048, query_594049, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_594033(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_594034, base: "/storage/v1beta2",
    url: url_StorageBucketsDelete_594035, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_594085 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsInsert_594087(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageBucketAccessControlsInsert_594086(path: JsonNode;
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
  var valid_594088 = path.getOrDefault("bucket")
  valid_594088 = validateParameter(valid_594088, JString, required = true,
                                 default = nil)
  if valid_594088 != nil:
    section.add "bucket", valid_594088
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
  var valid_594089 = query.getOrDefault("fields")
  valid_594089 = validateParameter(valid_594089, JString, required = false,
                                 default = nil)
  if valid_594089 != nil:
    section.add "fields", valid_594089
  var valid_594090 = query.getOrDefault("quotaUser")
  valid_594090 = validateParameter(valid_594090, JString, required = false,
                                 default = nil)
  if valid_594090 != nil:
    section.add "quotaUser", valid_594090
  var valid_594091 = query.getOrDefault("alt")
  valid_594091 = validateParameter(valid_594091, JString, required = false,
                                 default = newJString("json"))
  if valid_594091 != nil:
    section.add "alt", valid_594091
  var valid_594092 = query.getOrDefault("oauth_token")
  valid_594092 = validateParameter(valid_594092, JString, required = false,
                                 default = nil)
  if valid_594092 != nil:
    section.add "oauth_token", valid_594092
  var valid_594093 = query.getOrDefault("userIp")
  valid_594093 = validateParameter(valid_594093, JString, required = false,
                                 default = nil)
  if valid_594093 != nil:
    section.add "userIp", valid_594093
  var valid_594094 = query.getOrDefault("key")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "key", valid_594094
  var valid_594095 = query.getOrDefault("prettyPrint")
  valid_594095 = validateParameter(valid_594095, JBool, required = false,
                                 default = newJBool(true))
  if valid_594095 != nil:
    section.add "prettyPrint", valid_594095
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

proc call*(call_594097: Call_StorageBucketAccessControlsInsert_594085;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_594097.validator(path, query, header, formData, body)
  let scheme = call_594097.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594097.url(scheme.get, call_594097.host, call_594097.base,
                         call_594097.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594097, url, valid)

proc call*(call_594098: Call_StorageBucketAccessControlsInsert_594085;
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
  var path_594099 = newJObject()
  var query_594100 = newJObject()
  var body_594101 = newJObject()
  add(path_594099, "bucket", newJString(bucket))
  add(query_594100, "fields", newJString(fields))
  add(query_594100, "quotaUser", newJString(quotaUser))
  add(query_594100, "alt", newJString(alt))
  add(query_594100, "oauth_token", newJString(oauthToken))
  add(query_594100, "userIp", newJString(userIp))
  add(query_594100, "key", newJString(key))
  if body != nil:
    body_594101 = body
  add(query_594100, "prettyPrint", newJBool(prettyPrint))
  result = call_594098.call(path_594099, query_594100, nil, nil, body_594101)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_594085(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_594086,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsInsert_594087,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_594070 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsList_594072(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageBucketAccessControlsList_594071(path: JsonNode;
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
  var valid_594073 = path.getOrDefault("bucket")
  valid_594073 = validateParameter(valid_594073, JString, required = true,
                                 default = nil)
  if valid_594073 != nil:
    section.add "bucket", valid_594073
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
  var valid_594078 = query.getOrDefault("userIp")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = nil)
  if valid_594078 != nil:
    section.add "userIp", valid_594078
  var valid_594079 = query.getOrDefault("key")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "key", valid_594079
  var valid_594080 = query.getOrDefault("prettyPrint")
  valid_594080 = validateParameter(valid_594080, JBool, required = false,
                                 default = newJBool(true))
  if valid_594080 != nil:
    section.add "prettyPrint", valid_594080
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594081: Call_StorageBucketAccessControlsList_594070;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_594081.validator(path, query, header, formData, body)
  let scheme = call_594081.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594081.url(scheme.get, call_594081.host, call_594081.base,
                         call_594081.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594081, url, valid)

proc call*(call_594082: Call_StorageBucketAccessControlsList_594070;
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
  var path_594083 = newJObject()
  var query_594084 = newJObject()
  add(path_594083, "bucket", newJString(bucket))
  add(query_594084, "fields", newJString(fields))
  add(query_594084, "quotaUser", newJString(quotaUser))
  add(query_594084, "alt", newJString(alt))
  add(query_594084, "oauth_token", newJString(oauthToken))
  add(query_594084, "userIp", newJString(userIp))
  add(query_594084, "key", newJString(key))
  add(query_594084, "prettyPrint", newJBool(prettyPrint))
  result = call_594082.call(path_594083, query_594084, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_594070(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_594071,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsList_594072,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_594118 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsUpdate_594120(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageBucketAccessControlsUpdate_594119(path: JsonNode;
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
  var valid_594121 = path.getOrDefault("bucket")
  valid_594121 = validateParameter(valid_594121, JString, required = true,
                                 default = nil)
  if valid_594121 != nil:
    section.add "bucket", valid_594121
  var valid_594122 = path.getOrDefault("entity")
  valid_594122 = validateParameter(valid_594122, JString, required = true,
                                 default = nil)
  if valid_594122 != nil:
    section.add "entity", valid_594122
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
  var valid_594123 = query.getOrDefault("fields")
  valid_594123 = validateParameter(valid_594123, JString, required = false,
                                 default = nil)
  if valid_594123 != nil:
    section.add "fields", valid_594123
  var valid_594124 = query.getOrDefault("quotaUser")
  valid_594124 = validateParameter(valid_594124, JString, required = false,
                                 default = nil)
  if valid_594124 != nil:
    section.add "quotaUser", valid_594124
  var valid_594125 = query.getOrDefault("alt")
  valid_594125 = validateParameter(valid_594125, JString, required = false,
                                 default = newJString("json"))
  if valid_594125 != nil:
    section.add "alt", valid_594125
  var valid_594126 = query.getOrDefault("oauth_token")
  valid_594126 = validateParameter(valid_594126, JString, required = false,
                                 default = nil)
  if valid_594126 != nil:
    section.add "oauth_token", valid_594126
  var valid_594127 = query.getOrDefault("userIp")
  valid_594127 = validateParameter(valid_594127, JString, required = false,
                                 default = nil)
  if valid_594127 != nil:
    section.add "userIp", valid_594127
  var valid_594128 = query.getOrDefault("key")
  valid_594128 = validateParameter(valid_594128, JString, required = false,
                                 default = nil)
  if valid_594128 != nil:
    section.add "key", valid_594128
  var valid_594129 = query.getOrDefault("prettyPrint")
  valid_594129 = validateParameter(valid_594129, JBool, required = false,
                                 default = newJBool(true))
  if valid_594129 != nil:
    section.add "prettyPrint", valid_594129
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

proc call*(call_594131: Call_StorageBucketAccessControlsUpdate_594118;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_594131.validator(path, query, header, formData, body)
  let scheme = call_594131.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594131.url(scheme.get, call_594131.host, call_594131.base,
                         call_594131.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594131, url, valid)

proc call*(call_594132: Call_StorageBucketAccessControlsUpdate_594118;
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
  var path_594133 = newJObject()
  var query_594134 = newJObject()
  var body_594135 = newJObject()
  add(path_594133, "bucket", newJString(bucket))
  add(query_594134, "fields", newJString(fields))
  add(query_594134, "quotaUser", newJString(quotaUser))
  add(query_594134, "alt", newJString(alt))
  add(query_594134, "oauth_token", newJString(oauthToken))
  add(query_594134, "userIp", newJString(userIp))
  add(query_594134, "key", newJString(key))
  if body != nil:
    body_594135 = body
  add(query_594134, "prettyPrint", newJBool(prettyPrint))
  add(path_594133, "entity", newJString(entity))
  result = call_594132.call(path_594133, query_594134, nil, nil, body_594135)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_594118(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_594119,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsUpdate_594120,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_594102 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsGet_594104(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageBucketAccessControlsGet_594103(path: JsonNode;
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
  var valid_594105 = path.getOrDefault("bucket")
  valid_594105 = validateParameter(valid_594105, JString, required = true,
                                 default = nil)
  if valid_594105 != nil:
    section.add "bucket", valid_594105
  var valid_594106 = path.getOrDefault("entity")
  valid_594106 = validateParameter(valid_594106, JString, required = true,
                                 default = nil)
  if valid_594106 != nil:
    section.add "entity", valid_594106
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
  var valid_594107 = query.getOrDefault("fields")
  valid_594107 = validateParameter(valid_594107, JString, required = false,
                                 default = nil)
  if valid_594107 != nil:
    section.add "fields", valid_594107
  var valid_594108 = query.getOrDefault("quotaUser")
  valid_594108 = validateParameter(valid_594108, JString, required = false,
                                 default = nil)
  if valid_594108 != nil:
    section.add "quotaUser", valid_594108
  var valid_594109 = query.getOrDefault("alt")
  valid_594109 = validateParameter(valid_594109, JString, required = false,
                                 default = newJString("json"))
  if valid_594109 != nil:
    section.add "alt", valid_594109
  var valid_594110 = query.getOrDefault("oauth_token")
  valid_594110 = validateParameter(valid_594110, JString, required = false,
                                 default = nil)
  if valid_594110 != nil:
    section.add "oauth_token", valid_594110
  var valid_594111 = query.getOrDefault("userIp")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "userIp", valid_594111
  var valid_594112 = query.getOrDefault("key")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "key", valid_594112
  var valid_594113 = query.getOrDefault("prettyPrint")
  valid_594113 = validateParameter(valid_594113, JBool, required = false,
                                 default = newJBool(true))
  if valid_594113 != nil:
    section.add "prettyPrint", valid_594113
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594114: Call_StorageBucketAccessControlsGet_594102; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594114.validator(path, query, header, formData, body)
  let scheme = call_594114.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594114.url(scheme.get, call_594114.host, call_594114.base,
                         call_594114.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594114, url, valid)

proc call*(call_594115: Call_StorageBucketAccessControlsGet_594102; bucket: string;
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
  var path_594116 = newJObject()
  var query_594117 = newJObject()
  add(path_594116, "bucket", newJString(bucket))
  add(query_594117, "fields", newJString(fields))
  add(query_594117, "quotaUser", newJString(quotaUser))
  add(query_594117, "alt", newJString(alt))
  add(query_594117, "oauth_token", newJString(oauthToken))
  add(query_594117, "userIp", newJString(userIp))
  add(query_594117, "key", newJString(key))
  add(query_594117, "prettyPrint", newJBool(prettyPrint))
  add(path_594116, "entity", newJString(entity))
  result = call_594115.call(path_594116, query_594117, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_594102(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_594103,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsGet_594104,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_594152 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsPatch_594154(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageBucketAccessControlsPatch_594153(path: JsonNode;
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
  var valid_594155 = path.getOrDefault("bucket")
  valid_594155 = validateParameter(valid_594155, JString, required = true,
                                 default = nil)
  if valid_594155 != nil:
    section.add "bucket", valid_594155
  var valid_594156 = path.getOrDefault("entity")
  valid_594156 = validateParameter(valid_594156, JString, required = true,
                                 default = nil)
  if valid_594156 != nil:
    section.add "entity", valid_594156
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
  var valid_594157 = query.getOrDefault("fields")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "fields", valid_594157
  var valid_594158 = query.getOrDefault("quotaUser")
  valid_594158 = validateParameter(valid_594158, JString, required = false,
                                 default = nil)
  if valid_594158 != nil:
    section.add "quotaUser", valid_594158
  var valid_594159 = query.getOrDefault("alt")
  valid_594159 = validateParameter(valid_594159, JString, required = false,
                                 default = newJString("json"))
  if valid_594159 != nil:
    section.add "alt", valid_594159
  var valid_594160 = query.getOrDefault("oauth_token")
  valid_594160 = validateParameter(valid_594160, JString, required = false,
                                 default = nil)
  if valid_594160 != nil:
    section.add "oauth_token", valid_594160
  var valid_594161 = query.getOrDefault("userIp")
  valid_594161 = validateParameter(valid_594161, JString, required = false,
                                 default = nil)
  if valid_594161 != nil:
    section.add "userIp", valid_594161
  var valid_594162 = query.getOrDefault("key")
  valid_594162 = validateParameter(valid_594162, JString, required = false,
                                 default = nil)
  if valid_594162 != nil:
    section.add "key", valid_594162
  var valid_594163 = query.getOrDefault("prettyPrint")
  valid_594163 = validateParameter(valid_594163, JBool, required = false,
                                 default = newJBool(true))
  if valid_594163 != nil:
    section.add "prettyPrint", valid_594163
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

proc call*(call_594165: Call_StorageBucketAccessControlsPatch_594152;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_594165.validator(path, query, header, formData, body)
  let scheme = call_594165.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594165.url(scheme.get, call_594165.host, call_594165.base,
                         call_594165.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594165, url, valid)

proc call*(call_594166: Call_StorageBucketAccessControlsPatch_594152;
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
  var path_594167 = newJObject()
  var query_594168 = newJObject()
  var body_594169 = newJObject()
  add(path_594167, "bucket", newJString(bucket))
  add(query_594168, "fields", newJString(fields))
  add(query_594168, "quotaUser", newJString(quotaUser))
  add(query_594168, "alt", newJString(alt))
  add(query_594168, "oauth_token", newJString(oauthToken))
  add(query_594168, "userIp", newJString(userIp))
  add(query_594168, "key", newJString(key))
  if body != nil:
    body_594169 = body
  add(query_594168, "prettyPrint", newJBool(prettyPrint))
  add(path_594167, "entity", newJString(entity))
  result = call_594166.call(path_594167, query_594168, nil, nil, body_594169)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_594152(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_594153,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsPatch_594154,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_594136 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsDelete_594138(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageBucketAccessControlsDelete_594137(path: JsonNode;
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
  var valid_594139 = path.getOrDefault("bucket")
  valid_594139 = validateParameter(valid_594139, JString, required = true,
                                 default = nil)
  if valid_594139 != nil:
    section.add "bucket", valid_594139
  var valid_594140 = path.getOrDefault("entity")
  valid_594140 = validateParameter(valid_594140, JString, required = true,
                                 default = nil)
  if valid_594140 != nil:
    section.add "entity", valid_594140
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
  var valid_594141 = query.getOrDefault("fields")
  valid_594141 = validateParameter(valid_594141, JString, required = false,
                                 default = nil)
  if valid_594141 != nil:
    section.add "fields", valid_594141
  var valid_594142 = query.getOrDefault("quotaUser")
  valid_594142 = validateParameter(valid_594142, JString, required = false,
                                 default = nil)
  if valid_594142 != nil:
    section.add "quotaUser", valid_594142
  var valid_594143 = query.getOrDefault("alt")
  valid_594143 = validateParameter(valid_594143, JString, required = false,
                                 default = newJString("json"))
  if valid_594143 != nil:
    section.add "alt", valid_594143
  var valid_594144 = query.getOrDefault("oauth_token")
  valid_594144 = validateParameter(valid_594144, JString, required = false,
                                 default = nil)
  if valid_594144 != nil:
    section.add "oauth_token", valid_594144
  var valid_594145 = query.getOrDefault("userIp")
  valid_594145 = validateParameter(valid_594145, JString, required = false,
                                 default = nil)
  if valid_594145 != nil:
    section.add "userIp", valid_594145
  var valid_594146 = query.getOrDefault("key")
  valid_594146 = validateParameter(valid_594146, JString, required = false,
                                 default = nil)
  if valid_594146 != nil:
    section.add "key", valid_594146
  var valid_594147 = query.getOrDefault("prettyPrint")
  valid_594147 = validateParameter(valid_594147, JBool, required = false,
                                 default = newJBool(true))
  if valid_594147 != nil:
    section.add "prettyPrint", valid_594147
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594148: Call_StorageBucketAccessControlsDelete_594136;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594148.validator(path, query, header, formData, body)
  let scheme = call_594148.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594148.url(scheme.get, call_594148.host, call_594148.base,
                         call_594148.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594148, url, valid)

proc call*(call_594149: Call_StorageBucketAccessControlsDelete_594136;
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
  var path_594150 = newJObject()
  var query_594151 = newJObject()
  add(path_594150, "bucket", newJString(bucket))
  add(query_594151, "fields", newJString(fields))
  add(query_594151, "quotaUser", newJString(quotaUser))
  add(query_594151, "alt", newJString(alt))
  add(query_594151, "oauth_token", newJString(oauthToken))
  add(query_594151, "userIp", newJString(userIp))
  add(query_594151, "key", newJString(key))
  add(query_594151, "prettyPrint", newJBool(prettyPrint))
  add(path_594150, "entity", newJString(entity))
  result = call_594149.call(path_594150, query_594151, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_594136(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_594137,
    base: "/storage/v1beta2", url: url_StorageBucketAccessControlsDelete_594138,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_594187 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsInsert_594189(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageDefaultObjectAccessControlsInsert_594188(path: JsonNode;
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
  var valid_594190 = path.getOrDefault("bucket")
  valid_594190 = validateParameter(valid_594190, JString, required = true,
                                 default = nil)
  if valid_594190 != nil:
    section.add "bucket", valid_594190
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
  var valid_594191 = query.getOrDefault("fields")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "fields", valid_594191
  var valid_594192 = query.getOrDefault("quotaUser")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "quotaUser", valid_594192
  var valid_594193 = query.getOrDefault("alt")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = newJString("json"))
  if valid_594193 != nil:
    section.add "alt", valid_594193
  var valid_594194 = query.getOrDefault("oauth_token")
  valid_594194 = validateParameter(valid_594194, JString, required = false,
                                 default = nil)
  if valid_594194 != nil:
    section.add "oauth_token", valid_594194
  var valid_594195 = query.getOrDefault("userIp")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "userIp", valid_594195
  var valid_594196 = query.getOrDefault("key")
  valid_594196 = validateParameter(valid_594196, JString, required = false,
                                 default = nil)
  if valid_594196 != nil:
    section.add "key", valid_594196
  var valid_594197 = query.getOrDefault("prettyPrint")
  valid_594197 = validateParameter(valid_594197, JBool, required = false,
                                 default = newJBool(true))
  if valid_594197 != nil:
    section.add "prettyPrint", valid_594197
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

proc call*(call_594199: Call_StorageDefaultObjectAccessControlsInsert_594187;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_594199.validator(path, query, header, formData, body)
  let scheme = call_594199.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594199.url(scheme.get, call_594199.host, call_594199.base,
                         call_594199.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594199, url, valid)

proc call*(call_594200: Call_StorageDefaultObjectAccessControlsInsert_594187;
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
  var path_594201 = newJObject()
  var query_594202 = newJObject()
  var body_594203 = newJObject()
  add(path_594201, "bucket", newJString(bucket))
  add(query_594202, "fields", newJString(fields))
  add(query_594202, "quotaUser", newJString(quotaUser))
  add(query_594202, "alt", newJString(alt))
  add(query_594202, "oauth_token", newJString(oauthToken))
  add(query_594202, "userIp", newJString(userIp))
  add(query_594202, "key", newJString(key))
  if body != nil:
    body_594203 = body
  add(query_594202, "prettyPrint", newJBool(prettyPrint))
  result = call_594200.call(path_594201, query_594202, nil, nil, body_594203)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_594187(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_594188,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsInsert_594189,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_594170 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsList_594172(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageDefaultObjectAccessControlsList_594171(path: JsonNode;
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
  var valid_594173 = path.getOrDefault("bucket")
  valid_594173 = validateParameter(valid_594173, JString, required = true,
                                 default = nil)
  if valid_594173 != nil:
    section.add "bucket", valid_594173
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
  var valid_594174 = query.getOrDefault("fields")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "fields", valid_594174
  var valid_594175 = query.getOrDefault("quotaUser")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "quotaUser", valid_594175
  var valid_594176 = query.getOrDefault("alt")
  valid_594176 = validateParameter(valid_594176, JString, required = false,
                                 default = newJString("json"))
  if valid_594176 != nil:
    section.add "alt", valid_594176
  var valid_594177 = query.getOrDefault("oauth_token")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "oauth_token", valid_594177
  var valid_594178 = query.getOrDefault("userIp")
  valid_594178 = validateParameter(valid_594178, JString, required = false,
                                 default = nil)
  if valid_594178 != nil:
    section.add "userIp", valid_594178
  var valid_594179 = query.getOrDefault("key")
  valid_594179 = validateParameter(valid_594179, JString, required = false,
                                 default = nil)
  if valid_594179 != nil:
    section.add "key", valid_594179
  var valid_594180 = query.getOrDefault("ifMetagenerationMatch")
  valid_594180 = validateParameter(valid_594180, JString, required = false,
                                 default = nil)
  if valid_594180 != nil:
    section.add "ifMetagenerationMatch", valid_594180
  var valid_594181 = query.getOrDefault("prettyPrint")
  valid_594181 = validateParameter(valid_594181, JBool, required = false,
                                 default = newJBool(true))
  if valid_594181 != nil:
    section.add "prettyPrint", valid_594181
  var valid_594182 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594182 = validateParameter(valid_594182, JString, required = false,
                                 default = nil)
  if valid_594182 != nil:
    section.add "ifMetagenerationNotMatch", valid_594182
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594183: Call_StorageDefaultObjectAccessControlsList_594170;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_594183.validator(path, query, header, formData, body)
  let scheme = call_594183.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594183.url(scheme.get, call_594183.host, call_594183.base,
                         call_594183.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594183, url, valid)

proc call*(call_594184: Call_StorageDefaultObjectAccessControlsList_594170;
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
  var path_594185 = newJObject()
  var query_594186 = newJObject()
  add(path_594185, "bucket", newJString(bucket))
  add(query_594186, "fields", newJString(fields))
  add(query_594186, "quotaUser", newJString(quotaUser))
  add(query_594186, "alt", newJString(alt))
  add(query_594186, "oauth_token", newJString(oauthToken))
  add(query_594186, "userIp", newJString(userIp))
  add(query_594186, "key", newJString(key))
  add(query_594186, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594186, "prettyPrint", newJBool(prettyPrint))
  add(query_594186, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_594184.call(path_594185, query_594186, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_594170(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_594171,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsList_594172,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_594220 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsUpdate_594222(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageDefaultObjectAccessControlsUpdate_594221(path: JsonNode;
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
  var valid_594223 = path.getOrDefault("bucket")
  valid_594223 = validateParameter(valid_594223, JString, required = true,
                                 default = nil)
  if valid_594223 != nil:
    section.add "bucket", valid_594223
  var valid_594224 = path.getOrDefault("entity")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "entity", valid_594224
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
  var valid_594225 = query.getOrDefault("fields")
  valid_594225 = validateParameter(valid_594225, JString, required = false,
                                 default = nil)
  if valid_594225 != nil:
    section.add "fields", valid_594225
  var valid_594226 = query.getOrDefault("quotaUser")
  valid_594226 = validateParameter(valid_594226, JString, required = false,
                                 default = nil)
  if valid_594226 != nil:
    section.add "quotaUser", valid_594226
  var valid_594227 = query.getOrDefault("alt")
  valid_594227 = validateParameter(valid_594227, JString, required = false,
                                 default = newJString("json"))
  if valid_594227 != nil:
    section.add "alt", valid_594227
  var valid_594228 = query.getOrDefault("oauth_token")
  valid_594228 = validateParameter(valid_594228, JString, required = false,
                                 default = nil)
  if valid_594228 != nil:
    section.add "oauth_token", valid_594228
  var valid_594229 = query.getOrDefault("userIp")
  valid_594229 = validateParameter(valid_594229, JString, required = false,
                                 default = nil)
  if valid_594229 != nil:
    section.add "userIp", valid_594229
  var valid_594230 = query.getOrDefault("key")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "key", valid_594230
  var valid_594231 = query.getOrDefault("prettyPrint")
  valid_594231 = validateParameter(valid_594231, JBool, required = false,
                                 default = newJBool(true))
  if valid_594231 != nil:
    section.add "prettyPrint", valid_594231
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

proc call*(call_594233: Call_StorageDefaultObjectAccessControlsUpdate_594220;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_594233.validator(path, query, header, formData, body)
  let scheme = call_594233.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594233.url(scheme.get, call_594233.host, call_594233.base,
                         call_594233.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594233, url, valid)

proc call*(call_594234: Call_StorageDefaultObjectAccessControlsUpdate_594220;
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
  var path_594235 = newJObject()
  var query_594236 = newJObject()
  var body_594237 = newJObject()
  add(path_594235, "bucket", newJString(bucket))
  add(query_594236, "fields", newJString(fields))
  add(query_594236, "quotaUser", newJString(quotaUser))
  add(query_594236, "alt", newJString(alt))
  add(query_594236, "oauth_token", newJString(oauthToken))
  add(query_594236, "userIp", newJString(userIp))
  add(query_594236, "key", newJString(key))
  if body != nil:
    body_594237 = body
  add(query_594236, "prettyPrint", newJBool(prettyPrint))
  add(path_594235, "entity", newJString(entity))
  result = call_594234.call(path_594235, query_594236, nil, nil, body_594237)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_594220(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_594221,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsUpdate_594222,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_594204 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsGet_594206(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageDefaultObjectAccessControlsGet_594205(path: JsonNode;
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
  var valid_594207 = path.getOrDefault("bucket")
  valid_594207 = validateParameter(valid_594207, JString, required = true,
                                 default = nil)
  if valid_594207 != nil:
    section.add "bucket", valid_594207
  var valid_594208 = path.getOrDefault("entity")
  valid_594208 = validateParameter(valid_594208, JString, required = true,
                                 default = nil)
  if valid_594208 != nil:
    section.add "entity", valid_594208
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
  var valid_594209 = query.getOrDefault("fields")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "fields", valid_594209
  var valid_594210 = query.getOrDefault("quotaUser")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "quotaUser", valid_594210
  var valid_594211 = query.getOrDefault("alt")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = newJString("json"))
  if valid_594211 != nil:
    section.add "alt", valid_594211
  var valid_594212 = query.getOrDefault("oauth_token")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "oauth_token", valid_594212
  var valid_594213 = query.getOrDefault("userIp")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "userIp", valid_594213
  var valid_594214 = query.getOrDefault("key")
  valid_594214 = validateParameter(valid_594214, JString, required = false,
                                 default = nil)
  if valid_594214 != nil:
    section.add "key", valid_594214
  var valid_594215 = query.getOrDefault("prettyPrint")
  valid_594215 = validateParameter(valid_594215, JBool, required = false,
                                 default = newJBool(true))
  if valid_594215 != nil:
    section.add "prettyPrint", valid_594215
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594216: Call_StorageDefaultObjectAccessControlsGet_594204;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594216.validator(path, query, header, formData, body)
  let scheme = call_594216.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594216.url(scheme.get, call_594216.host, call_594216.base,
                         call_594216.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594216, url, valid)

proc call*(call_594217: Call_StorageDefaultObjectAccessControlsGet_594204;
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
  var path_594218 = newJObject()
  var query_594219 = newJObject()
  add(path_594218, "bucket", newJString(bucket))
  add(query_594219, "fields", newJString(fields))
  add(query_594219, "quotaUser", newJString(quotaUser))
  add(query_594219, "alt", newJString(alt))
  add(query_594219, "oauth_token", newJString(oauthToken))
  add(query_594219, "userIp", newJString(userIp))
  add(query_594219, "key", newJString(key))
  add(query_594219, "prettyPrint", newJBool(prettyPrint))
  add(path_594218, "entity", newJString(entity))
  result = call_594217.call(path_594218, query_594219, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_594204(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_594205,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsGet_594206,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_594254 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsPatch_594256(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageDefaultObjectAccessControlsPatch_594255(path: JsonNode;
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
  var valid_594257 = path.getOrDefault("bucket")
  valid_594257 = validateParameter(valid_594257, JString, required = true,
                                 default = nil)
  if valid_594257 != nil:
    section.add "bucket", valid_594257
  var valid_594258 = path.getOrDefault("entity")
  valid_594258 = validateParameter(valid_594258, JString, required = true,
                                 default = nil)
  if valid_594258 != nil:
    section.add "entity", valid_594258
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
  var valid_594259 = query.getOrDefault("fields")
  valid_594259 = validateParameter(valid_594259, JString, required = false,
                                 default = nil)
  if valid_594259 != nil:
    section.add "fields", valid_594259
  var valid_594260 = query.getOrDefault("quotaUser")
  valid_594260 = validateParameter(valid_594260, JString, required = false,
                                 default = nil)
  if valid_594260 != nil:
    section.add "quotaUser", valid_594260
  var valid_594261 = query.getOrDefault("alt")
  valid_594261 = validateParameter(valid_594261, JString, required = false,
                                 default = newJString("json"))
  if valid_594261 != nil:
    section.add "alt", valid_594261
  var valid_594262 = query.getOrDefault("oauth_token")
  valid_594262 = validateParameter(valid_594262, JString, required = false,
                                 default = nil)
  if valid_594262 != nil:
    section.add "oauth_token", valid_594262
  var valid_594263 = query.getOrDefault("userIp")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "userIp", valid_594263
  var valid_594264 = query.getOrDefault("key")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "key", valid_594264
  var valid_594265 = query.getOrDefault("prettyPrint")
  valid_594265 = validateParameter(valid_594265, JBool, required = false,
                                 default = newJBool(true))
  if valid_594265 != nil:
    section.add "prettyPrint", valid_594265
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

proc call*(call_594267: Call_StorageDefaultObjectAccessControlsPatch_594254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket. This method supports patch semantics.
  ## 
  let valid = call_594267.validator(path, query, header, formData, body)
  let scheme = call_594267.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594267.url(scheme.get, call_594267.host, call_594267.base,
                         call_594267.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594267, url, valid)

proc call*(call_594268: Call_StorageDefaultObjectAccessControlsPatch_594254;
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
  var path_594269 = newJObject()
  var query_594270 = newJObject()
  var body_594271 = newJObject()
  add(path_594269, "bucket", newJString(bucket))
  add(query_594270, "fields", newJString(fields))
  add(query_594270, "quotaUser", newJString(quotaUser))
  add(query_594270, "alt", newJString(alt))
  add(query_594270, "oauth_token", newJString(oauthToken))
  add(query_594270, "userIp", newJString(userIp))
  add(query_594270, "key", newJString(key))
  if body != nil:
    body_594271 = body
  add(query_594270, "prettyPrint", newJBool(prettyPrint))
  add(path_594269, "entity", newJString(entity))
  result = call_594268.call(path_594269, query_594270, nil, nil, body_594271)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_594254(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_594255,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsPatch_594256,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_594238 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsDelete_594240(protocol: Scheme;
    host: string; base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageDefaultObjectAccessControlsDelete_594239(path: JsonNode;
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
  var valid_594241 = path.getOrDefault("bucket")
  valid_594241 = validateParameter(valid_594241, JString, required = true,
                                 default = nil)
  if valid_594241 != nil:
    section.add "bucket", valid_594241
  var valid_594242 = path.getOrDefault("entity")
  valid_594242 = validateParameter(valid_594242, JString, required = true,
                                 default = nil)
  if valid_594242 != nil:
    section.add "entity", valid_594242
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
  var valid_594243 = query.getOrDefault("fields")
  valid_594243 = validateParameter(valid_594243, JString, required = false,
                                 default = nil)
  if valid_594243 != nil:
    section.add "fields", valid_594243
  var valid_594244 = query.getOrDefault("quotaUser")
  valid_594244 = validateParameter(valid_594244, JString, required = false,
                                 default = nil)
  if valid_594244 != nil:
    section.add "quotaUser", valid_594244
  var valid_594245 = query.getOrDefault("alt")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = newJString("json"))
  if valid_594245 != nil:
    section.add "alt", valid_594245
  var valid_594246 = query.getOrDefault("oauth_token")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "oauth_token", valid_594246
  var valid_594247 = query.getOrDefault("userIp")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = nil)
  if valid_594247 != nil:
    section.add "userIp", valid_594247
  var valid_594248 = query.getOrDefault("key")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "key", valid_594248
  var valid_594249 = query.getOrDefault("prettyPrint")
  valid_594249 = validateParameter(valid_594249, JBool, required = false,
                                 default = newJBool(true))
  if valid_594249 != nil:
    section.add "prettyPrint", valid_594249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594250: Call_StorageDefaultObjectAccessControlsDelete_594238;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594250.validator(path, query, header, formData, body)
  let scheme = call_594250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594250.url(scheme.get, call_594250.host, call_594250.base,
                         call_594250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594250, url, valid)

proc call*(call_594251: Call_StorageDefaultObjectAccessControlsDelete_594238;
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
  var path_594252 = newJObject()
  var query_594253 = newJObject()
  add(path_594252, "bucket", newJString(bucket))
  add(query_594253, "fields", newJString(fields))
  add(query_594253, "quotaUser", newJString(quotaUser))
  add(query_594253, "alt", newJString(alt))
  add(query_594253, "oauth_token", newJString(oauthToken))
  add(query_594253, "userIp", newJString(userIp))
  add(query_594253, "key", newJString(key))
  add(query_594253, "prettyPrint", newJBool(prettyPrint))
  add(path_594252, "entity", newJString(entity))
  result = call_594251.call(path_594252, query_594253, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_594238(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com",
    route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_594239,
    base: "/storage/v1beta2", url: url_StorageDefaultObjectAccessControlsDelete_594240,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_594293 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsInsert_594295(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsInsert_594294(path: JsonNode; query: JsonNode;
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
  var valid_594296 = path.getOrDefault("bucket")
  valid_594296 = validateParameter(valid_594296, JString, required = true,
                                 default = nil)
  if valid_594296 != nil:
    section.add "bucket", valid_594296
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
  var valid_594297 = query.getOrDefault("ifGenerationMatch")
  valid_594297 = validateParameter(valid_594297, JString, required = false,
                                 default = nil)
  if valid_594297 != nil:
    section.add "ifGenerationMatch", valid_594297
  var valid_594298 = query.getOrDefault("fields")
  valid_594298 = validateParameter(valid_594298, JString, required = false,
                                 default = nil)
  if valid_594298 != nil:
    section.add "fields", valid_594298
  var valid_594299 = query.getOrDefault("quotaUser")
  valid_594299 = validateParameter(valid_594299, JString, required = false,
                                 default = nil)
  if valid_594299 != nil:
    section.add "quotaUser", valid_594299
  var valid_594300 = query.getOrDefault("alt")
  valid_594300 = validateParameter(valid_594300, JString, required = false,
                                 default = newJString("json"))
  if valid_594300 != nil:
    section.add "alt", valid_594300
  var valid_594301 = query.getOrDefault("ifGenerationNotMatch")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "ifGenerationNotMatch", valid_594301
  var valid_594302 = query.getOrDefault("oauth_token")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "oauth_token", valid_594302
  var valid_594303 = query.getOrDefault("userIp")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = nil)
  if valid_594303 != nil:
    section.add "userIp", valid_594303
  var valid_594304 = query.getOrDefault("key")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "key", valid_594304
  var valid_594305 = query.getOrDefault("name")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "name", valid_594305
  var valid_594306 = query.getOrDefault("projection")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = newJString("full"))
  if valid_594306 != nil:
    section.add "projection", valid_594306
  var valid_594307 = query.getOrDefault("ifMetagenerationMatch")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "ifMetagenerationMatch", valid_594307
  var valid_594308 = query.getOrDefault("prettyPrint")
  valid_594308 = validateParameter(valid_594308, JBool, required = false,
                                 default = newJBool(true))
  if valid_594308 != nil:
    section.add "prettyPrint", valid_594308
  var valid_594309 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "ifMetagenerationNotMatch", valid_594309
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

proc call*(call_594311: Call_StorageObjectsInsert_594293; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores new data blobs and associated metadata.
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_StorageObjectsInsert_594293; bucket: string;
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
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  var body_594315 = newJObject()
  add(query_594314, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594313, "bucket", newJString(bucket))
  add(query_594314, "fields", newJString(fields))
  add(query_594314, "quotaUser", newJString(quotaUser))
  add(query_594314, "alt", newJString(alt))
  add(query_594314, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594314, "oauth_token", newJString(oauthToken))
  add(query_594314, "userIp", newJString(userIp))
  add(query_594314, "key", newJString(key))
  add(query_594314, "name", newJString(name))
  add(query_594314, "projection", newJString(projection))
  add(query_594314, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594315 = body
  add(query_594314, "prettyPrint", newJBool(prettyPrint))
  add(query_594314, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_594312.call(path_594313, query_594314, nil, nil, body_594315)

var storageObjectsInsert* = Call_StorageObjectsInsert_594293(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_594294, base: "/storage/v1beta2",
    url: url_StorageObjectsInsert_594295, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_594272 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsList_594274(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsList_594273(path: JsonNode; query: JsonNode;
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
  var valid_594275 = path.getOrDefault("bucket")
  valid_594275 = validateParameter(valid_594275, JString, required = true,
                                 default = nil)
  if valid_594275 != nil:
    section.add "bucket", valid_594275
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
  var valid_594276 = query.getOrDefault("fields")
  valid_594276 = validateParameter(valid_594276, JString, required = false,
                                 default = nil)
  if valid_594276 != nil:
    section.add "fields", valid_594276
  var valid_594277 = query.getOrDefault("pageToken")
  valid_594277 = validateParameter(valid_594277, JString, required = false,
                                 default = nil)
  if valid_594277 != nil:
    section.add "pageToken", valid_594277
  var valid_594278 = query.getOrDefault("quotaUser")
  valid_594278 = validateParameter(valid_594278, JString, required = false,
                                 default = nil)
  if valid_594278 != nil:
    section.add "quotaUser", valid_594278
  var valid_594279 = query.getOrDefault("alt")
  valid_594279 = validateParameter(valid_594279, JString, required = false,
                                 default = newJString("json"))
  if valid_594279 != nil:
    section.add "alt", valid_594279
  var valid_594280 = query.getOrDefault("oauth_token")
  valid_594280 = validateParameter(valid_594280, JString, required = false,
                                 default = nil)
  if valid_594280 != nil:
    section.add "oauth_token", valid_594280
  var valid_594281 = query.getOrDefault("versions")
  valid_594281 = validateParameter(valid_594281, JBool, required = false, default = nil)
  if valid_594281 != nil:
    section.add "versions", valid_594281
  var valid_594282 = query.getOrDefault("userIp")
  valid_594282 = validateParameter(valid_594282, JString, required = false,
                                 default = nil)
  if valid_594282 != nil:
    section.add "userIp", valid_594282
  var valid_594283 = query.getOrDefault("maxResults")
  valid_594283 = validateParameter(valid_594283, JInt, required = false, default = nil)
  if valid_594283 != nil:
    section.add "maxResults", valid_594283
  var valid_594284 = query.getOrDefault("key")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "key", valid_594284
  var valid_594285 = query.getOrDefault("projection")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = newJString("full"))
  if valid_594285 != nil:
    section.add "projection", valid_594285
  var valid_594286 = query.getOrDefault("delimiter")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "delimiter", valid_594286
  var valid_594287 = query.getOrDefault("prettyPrint")
  valid_594287 = validateParameter(valid_594287, JBool, required = false,
                                 default = newJBool(true))
  if valid_594287 != nil:
    section.add "prettyPrint", valid_594287
  var valid_594288 = query.getOrDefault("prefix")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "prefix", valid_594288
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594289: Call_StorageObjectsList_594272; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_594289.validator(path, query, header, formData, body)
  let scheme = call_594289.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594289.url(scheme.get, call_594289.host, call_594289.base,
                         call_594289.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594289, url, valid)

proc call*(call_594290: Call_StorageObjectsList_594272; bucket: string;
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
  var path_594291 = newJObject()
  var query_594292 = newJObject()
  add(path_594291, "bucket", newJString(bucket))
  add(query_594292, "fields", newJString(fields))
  add(query_594292, "pageToken", newJString(pageToken))
  add(query_594292, "quotaUser", newJString(quotaUser))
  add(query_594292, "alt", newJString(alt))
  add(query_594292, "oauth_token", newJString(oauthToken))
  add(query_594292, "versions", newJBool(versions))
  add(query_594292, "userIp", newJString(userIp))
  add(query_594292, "maxResults", newJInt(maxResults))
  add(query_594292, "key", newJString(key))
  add(query_594292, "projection", newJString(projection))
  add(query_594292, "delimiter", newJString(delimiter))
  add(query_594292, "prettyPrint", newJBool(prettyPrint))
  add(query_594292, "prefix", newJString(prefix))
  result = call_594290.call(path_594291, query_594292, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_594272(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_594273, base: "/storage/v1beta2",
    url: url_StorageObjectsList_594274, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_594316 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsWatchAll_594318(protocol: Scheme; host: string; base: string;
                                      route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsWatchAll_594317(path: JsonNode; query: JsonNode;
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
  var valid_594319 = path.getOrDefault("bucket")
  valid_594319 = validateParameter(valid_594319, JString, required = true,
                                 default = nil)
  if valid_594319 != nil:
    section.add "bucket", valid_594319
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
  var valid_594320 = query.getOrDefault("fields")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "fields", valid_594320
  var valid_594321 = query.getOrDefault("pageToken")
  valid_594321 = validateParameter(valid_594321, JString, required = false,
                                 default = nil)
  if valid_594321 != nil:
    section.add "pageToken", valid_594321
  var valid_594322 = query.getOrDefault("quotaUser")
  valid_594322 = validateParameter(valid_594322, JString, required = false,
                                 default = nil)
  if valid_594322 != nil:
    section.add "quotaUser", valid_594322
  var valid_594323 = query.getOrDefault("alt")
  valid_594323 = validateParameter(valid_594323, JString, required = false,
                                 default = newJString("json"))
  if valid_594323 != nil:
    section.add "alt", valid_594323
  var valid_594324 = query.getOrDefault("oauth_token")
  valid_594324 = validateParameter(valid_594324, JString, required = false,
                                 default = nil)
  if valid_594324 != nil:
    section.add "oauth_token", valid_594324
  var valid_594325 = query.getOrDefault("versions")
  valid_594325 = validateParameter(valid_594325, JBool, required = false, default = nil)
  if valid_594325 != nil:
    section.add "versions", valid_594325
  var valid_594326 = query.getOrDefault("userIp")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "userIp", valid_594326
  var valid_594327 = query.getOrDefault("maxResults")
  valid_594327 = validateParameter(valid_594327, JInt, required = false, default = nil)
  if valid_594327 != nil:
    section.add "maxResults", valid_594327
  var valid_594328 = query.getOrDefault("key")
  valid_594328 = validateParameter(valid_594328, JString, required = false,
                                 default = nil)
  if valid_594328 != nil:
    section.add "key", valid_594328
  var valid_594329 = query.getOrDefault("projection")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = newJString("full"))
  if valid_594329 != nil:
    section.add "projection", valid_594329
  var valid_594330 = query.getOrDefault("delimiter")
  valid_594330 = validateParameter(valid_594330, JString, required = false,
                                 default = nil)
  if valid_594330 != nil:
    section.add "delimiter", valid_594330
  var valid_594331 = query.getOrDefault("prettyPrint")
  valid_594331 = validateParameter(valid_594331, JBool, required = false,
                                 default = newJBool(true))
  if valid_594331 != nil:
    section.add "prettyPrint", valid_594331
  var valid_594332 = query.getOrDefault("prefix")
  valid_594332 = validateParameter(valid_594332, JString, required = false,
                                 default = nil)
  if valid_594332 != nil:
    section.add "prefix", valid_594332
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

proc call*(call_594334: Call_StorageObjectsWatchAll_594316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_594334.validator(path, query, header, formData, body)
  let scheme = call_594334.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594334.url(scheme.get, call_594334.host, call_594334.base,
                         call_594334.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594334, url, valid)

proc call*(call_594335: Call_StorageObjectsWatchAll_594316; bucket: string;
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
  var path_594336 = newJObject()
  var query_594337 = newJObject()
  var body_594338 = newJObject()
  add(path_594336, "bucket", newJString(bucket))
  add(query_594337, "fields", newJString(fields))
  add(query_594337, "pageToken", newJString(pageToken))
  add(query_594337, "quotaUser", newJString(quotaUser))
  add(query_594337, "alt", newJString(alt))
  add(query_594337, "oauth_token", newJString(oauthToken))
  add(query_594337, "versions", newJBool(versions))
  add(query_594337, "userIp", newJString(userIp))
  add(query_594337, "maxResults", newJInt(maxResults))
  add(query_594337, "key", newJString(key))
  add(query_594337, "projection", newJString(projection))
  add(query_594337, "delimiter", newJString(delimiter))
  if resource != nil:
    body_594338 = resource
  add(query_594337, "prettyPrint", newJBool(prettyPrint))
  add(query_594337, "prefix", newJString(prefix))
  result = call_594335.call(path_594336, query_594337, nil, nil, body_594338)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_594316(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_594317, base: "/storage/v1beta2",
    url: url_StorageObjectsWatchAll_594318, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_594361 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsUpdate_594363(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsUpdate_594362(path: JsonNode; query: JsonNode;
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
  var valid_594364 = path.getOrDefault("bucket")
  valid_594364 = validateParameter(valid_594364, JString, required = true,
                                 default = nil)
  if valid_594364 != nil:
    section.add "bucket", valid_594364
  var valid_594365 = path.getOrDefault("object")
  valid_594365 = validateParameter(valid_594365, JString, required = true,
                                 default = nil)
  if valid_594365 != nil:
    section.add "object", valid_594365
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
  var valid_594366 = query.getOrDefault("ifGenerationMatch")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "ifGenerationMatch", valid_594366
  var valid_594367 = query.getOrDefault("fields")
  valid_594367 = validateParameter(valid_594367, JString, required = false,
                                 default = nil)
  if valid_594367 != nil:
    section.add "fields", valid_594367
  var valid_594368 = query.getOrDefault("quotaUser")
  valid_594368 = validateParameter(valid_594368, JString, required = false,
                                 default = nil)
  if valid_594368 != nil:
    section.add "quotaUser", valid_594368
  var valid_594369 = query.getOrDefault("alt")
  valid_594369 = validateParameter(valid_594369, JString, required = false,
                                 default = newJString("json"))
  if valid_594369 != nil:
    section.add "alt", valid_594369
  var valid_594370 = query.getOrDefault("ifGenerationNotMatch")
  valid_594370 = validateParameter(valid_594370, JString, required = false,
                                 default = nil)
  if valid_594370 != nil:
    section.add "ifGenerationNotMatch", valid_594370
  var valid_594371 = query.getOrDefault("oauth_token")
  valid_594371 = validateParameter(valid_594371, JString, required = false,
                                 default = nil)
  if valid_594371 != nil:
    section.add "oauth_token", valid_594371
  var valid_594372 = query.getOrDefault("userIp")
  valid_594372 = validateParameter(valid_594372, JString, required = false,
                                 default = nil)
  if valid_594372 != nil:
    section.add "userIp", valid_594372
  var valid_594373 = query.getOrDefault("key")
  valid_594373 = validateParameter(valid_594373, JString, required = false,
                                 default = nil)
  if valid_594373 != nil:
    section.add "key", valid_594373
  var valid_594374 = query.getOrDefault("projection")
  valid_594374 = validateParameter(valid_594374, JString, required = false,
                                 default = newJString("full"))
  if valid_594374 != nil:
    section.add "projection", valid_594374
  var valid_594375 = query.getOrDefault("ifMetagenerationMatch")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "ifMetagenerationMatch", valid_594375
  var valid_594376 = query.getOrDefault("generation")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "generation", valid_594376
  var valid_594377 = query.getOrDefault("prettyPrint")
  valid_594377 = validateParameter(valid_594377, JBool, required = false,
                                 default = newJBool(true))
  if valid_594377 != nil:
    section.add "prettyPrint", valid_594377
  var valid_594378 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "ifMetagenerationNotMatch", valid_594378
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

proc call*(call_594380: Call_StorageObjectsUpdate_594361; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata.
  ## 
  let valid = call_594380.validator(path, query, header, formData, body)
  let scheme = call_594380.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594380.url(scheme.get, call_594380.host, call_594380.base,
                         call_594380.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594380, url, valid)

proc call*(call_594381: Call_StorageObjectsUpdate_594361; bucket: string;
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
  var path_594382 = newJObject()
  var query_594383 = newJObject()
  var body_594384 = newJObject()
  add(query_594383, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594382, "bucket", newJString(bucket))
  add(query_594383, "fields", newJString(fields))
  add(query_594383, "quotaUser", newJString(quotaUser))
  add(query_594383, "alt", newJString(alt))
  add(query_594383, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594383, "oauth_token", newJString(oauthToken))
  add(query_594383, "userIp", newJString(userIp))
  add(query_594383, "key", newJString(key))
  add(query_594383, "projection", newJString(projection))
  add(query_594383, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594383, "generation", newJString(generation))
  if body != nil:
    body_594384 = body
  add(query_594383, "prettyPrint", newJBool(prettyPrint))
  add(query_594383, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594382, "object", newJString(`object`))
  result = call_594381.call(path_594382, query_594383, nil, nil, body_594384)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_594361(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_594362, base: "/storage/v1beta2",
    url: url_StorageObjectsUpdate_594363, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_594339 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsGet_594341(protocol: Scheme; host: string; base: string;
                                 route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsGet_594340(path: JsonNode; query: JsonNode;
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
  var valid_594342 = path.getOrDefault("bucket")
  valid_594342 = validateParameter(valid_594342, JString, required = true,
                                 default = nil)
  if valid_594342 != nil:
    section.add "bucket", valid_594342
  var valid_594343 = path.getOrDefault("object")
  valid_594343 = validateParameter(valid_594343, JString, required = true,
                                 default = nil)
  if valid_594343 != nil:
    section.add "object", valid_594343
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
  var valid_594344 = query.getOrDefault("ifGenerationMatch")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "ifGenerationMatch", valid_594344
  var valid_594345 = query.getOrDefault("fields")
  valid_594345 = validateParameter(valid_594345, JString, required = false,
                                 default = nil)
  if valid_594345 != nil:
    section.add "fields", valid_594345
  var valid_594346 = query.getOrDefault("quotaUser")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "quotaUser", valid_594346
  var valid_594347 = query.getOrDefault("alt")
  valid_594347 = validateParameter(valid_594347, JString, required = false,
                                 default = newJString("json"))
  if valid_594347 != nil:
    section.add "alt", valid_594347
  var valid_594348 = query.getOrDefault("ifGenerationNotMatch")
  valid_594348 = validateParameter(valid_594348, JString, required = false,
                                 default = nil)
  if valid_594348 != nil:
    section.add "ifGenerationNotMatch", valid_594348
  var valid_594349 = query.getOrDefault("oauth_token")
  valid_594349 = validateParameter(valid_594349, JString, required = false,
                                 default = nil)
  if valid_594349 != nil:
    section.add "oauth_token", valid_594349
  var valid_594350 = query.getOrDefault("userIp")
  valid_594350 = validateParameter(valid_594350, JString, required = false,
                                 default = nil)
  if valid_594350 != nil:
    section.add "userIp", valid_594350
  var valid_594351 = query.getOrDefault("key")
  valid_594351 = validateParameter(valid_594351, JString, required = false,
                                 default = nil)
  if valid_594351 != nil:
    section.add "key", valid_594351
  var valid_594352 = query.getOrDefault("projection")
  valid_594352 = validateParameter(valid_594352, JString, required = false,
                                 default = newJString("full"))
  if valid_594352 != nil:
    section.add "projection", valid_594352
  var valid_594353 = query.getOrDefault("ifMetagenerationMatch")
  valid_594353 = validateParameter(valid_594353, JString, required = false,
                                 default = nil)
  if valid_594353 != nil:
    section.add "ifMetagenerationMatch", valid_594353
  var valid_594354 = query.getOrDefault("generation")
  valid_594354 = validateParameter(valid_594354, JString, required = false,
                                 default = nil)
  if valid_594354 != nil:
    section.add "generation", valid_594354
  var valid_594355 = query.getOrDefault("prettyPrint")
  valid_594355 = validateParameter(valid_594355, JBool, required = false,
                                 default = newJBool(true))
  if valid_594355 != nil:
    section.add "prettyPrint", valid_594355
  var valid_594356 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594356 = validateParameter(valid_594356, JString, required = false,
                                 default = nil)
  if valid_594356 != nil:
    section.add "ifMetagenerationNotMatch", valid_594356
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594357: Call_StorageObjectsGet_594339; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves objects or their associated metadata.
  ## 
  let valid = call_594357.validator(path, query, header, formData, body)
  let scheme = call_594357.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594357.url(scheme.get, call_594357.host, call_594357.base,
                         call_594357.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594357, url, valid)

proc call*(call_594358: Call_StorageObjectsGet_594339; bucket: string;
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
  var path_594359 = newJObject()
  var query_594360 = newJObject()
  add(query_594360, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594359, "bucket", newJString(bucket))
  add(query_594360, "fields", newJString(fields))
  add(query_594360, "quotaUser", newJString(quotaUser))
  add(query_594360, "alt", newJString(alt))
  add(query_594360, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594360, "oauth_token", newJString(oauthToken))
  add(query_594360, "userIp", newJString(userIp))
  add(query_594360, "key", newJString(key))
  add(query_594360, "projection", newJString(projection))
  add(query_594360, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594360, "generation", newJString(generation))
  add(query_594360, "prettyPrint", newJBool(prettyPrint))
  add(query_594360, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594359, "object", newJString(`object`))
  result = call_594358.call(path_594359, query_594360, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_594339(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "storage.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_594340,
    base: "/storage/v1beta2", url: url_StorageObjectsGet_594341,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_594406 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsPatch_594408(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsPatch_594407(path: JsonNode; query: JsonNode;
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
  var valid_594409 = path.getOrDefault("bucket")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "bucket", valid_594409
  var valid_594410 = path.getOrDefault("object")
  valid_594410 = validateParameter(valid_594410, JString, required = true,
                                 default = nil)
  if valid_594410 != nil:
    section.add "object", valid_594410
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
  var valid_594411 = query.getOrDefault("ifGenerationMatch")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = nil)
  if valid_594411 != nil:
    section.add "ifGenerationMatch", valid_594411
  var valid_594412 = query.getOrDefault("fields")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = nil)
  if valid_594412 != nil:
    section.add "fields", valid_594412
  var valid_594413 = query.getOrDefault("quotaUser")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "quotaUser", valid_594413
  var valid_594414 = query.getOrDefault("alt")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = newJString("json"))
  if valid_594414 != nil:
    section.add "alt", valid_594414
  var valid_594415 = query.getOrDefault("ifGenerationNotMatch")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "ifGenerationNotMatch", valid_594415
  var valid_594416 = query.getOrDefault("oauth_token")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "oauth_token", valid_594416
  var valid_594417 = query.getOrDefault("userIp")
  valid_594417 = validateParameter(valid_594417, JString, required = false,
                                 default = nil)
  if valid_594417 != nil:
    section.add "userIp", valid_594417
  var valid_594418 = query.getOrDefault("key")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "key", valid_594418
  var valid_594419 = query.getOrDefault("projection")
  valid_594419 = validateParameter(valid_594419, JString, required = false,
                                 default = newJString("full"))
  if valid_594419 != nil:
    section.add "projection", valid_594419
  var valid_594420 = query.getOrDefault("ifMetagenerationMatch")
  valid_594420 = validateParameter(valid_594420, JString, required = false,
                                 default = nil)
  if valid_594420 != nil:
    section.add "ifMetagenerationMatch", valid_594420
  var valid_594421 = query.getOrDefault("generation")
  valid_594421 = validateParameter(valid_594421, JString, required = false,
                                 default = nil)
  if valid_594421 != nil:
    section.add "generation", valid_594421
  var valid_594422 = query.getOrDefault("prettyPrint")
  valid_594422 = validateParameter(valid_594422, JBool, required = false,
                                 default = newJBool(true))
  if valid_594422 != nil:
    section.add "prettyPrint", valid_594422
  var valid_594423 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594423 = validateParameter(valid_594423, JString, required = false,
                                 default = nil)
  if valid_594423 != nil:
    section.add "ifMetagenerationNotMatch", valid_594423
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

proc call*(call_594425: Call_StorageObjectsPatch_594406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a data blob's associated metadata. This method supports patch semantics.
  ## 
  let valid = call_594425.validator(path, query, header, formData, body)
  let scheme = call_594425.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594425.url(scheme.get, call_594425.host, call_594425.base,
                         call_594425.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594425, url, valid)

proc call*(call_594426: Call_StorageObjectsPatch_594406; bucket: string;
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
  var path_594427 = newJObject()
  var query_594428 = newJObject()
  var body_594429 = newJObject()
  add(query_594428, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594427, "bucket", newJString(bucket))
  add(query_594428, "fields", newJString(fields))
  add(query_594428, "quotaUser", newJString(quotaUser))
  add(query_594428, "alt", newJString(alt))
  add(query_594428, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594428, "oauth_token", newJString(oauthToken))
  add(query_594428, "userIp", newJString(userIp))
  add(query_594428, "key", newJString(key))
  add(query_594428, "projection", newJString(projection))
  add(query_594428, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594428, "generation", newJString(generation))
  if body != nil:
    body_594429 = body
  add(query_594428, "prettyPrint", newJBool(prettyPrint))
  add(query_594428, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594427, "object", newJString(`object`))
  result = call_594426.call(path_594427, query_594428, nil, nil, body_594429)

var storageObjectsPatch* = Call_StorageObjectsPatch_594406(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_594407, base: "/storage/v1beta2",
    url: url_StorageObjectsPatch_594408, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_594385 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsDelete_594387(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsDelete_594386(path: JsonNode; query: JsonNode;
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
  var valid_594388 = path.getOrDefault("bucket")
  valid_594388 = validateParameter(valid_594388, JString, required = true,
                                 default = nil)
  if valid_594388 != nil:
    section.add "bucket", valid_594388
  var valid_594389 = path.getOrDefault("object")
  valid_594389 = validateParameter(valid_594389, JString, required = true,
                                 default = nil)
  if valid_594389 != nil:
    section.add "object", valid_594389
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
  var valid_594390 = query.getOrDefault("ifGenerationMatch")
  valid_594390 = validateParameter(valid_594390, JString, required = false,
                                 default = nil)
  if valid_594390 != nil:
    section.add "ifGenerationMatch", valid_594390
  var valid_594391 = query.getOrDefault("fields")
  valid_594391 = validateParameter(valid_594391, JString, required = false,
                                 default = nil)
  if valid_594391 != nil:
    section.add "fields", valid_594391
  var valid_594392 = query.getOrDefault("quotaUser")
  valid_594392 = validateParameter(valid_594392, JString, required = false,
                                 default = nil)
  if valid_594392 != nil:
    section.add "quotaUser", valid_594392
  var valid_594393 = query.getOrDefault("alt")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = newJString("json"))
  if valid_594393 != nil:
    section.add "alt", valid_594393
  var valid_594394 = query.getOrDefault("ifGenerationNotMatch")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "ifGenerationNotMatch", valid_594394
  var valid_594395 = query.getOrDefault("oauth_token")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = nil)
  if valid_594395 != nil:
    section.add "oauth_token", valid_594395
  var valid_594396 = query.getOrDefault("userIp")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "userIp", valid_594396
  var valid_594397 = query.getOrDefault("key")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "key", valid_594397
  var valid_594398 = query.getOrDefault("ifMetagenerationMatch")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "ifMetagenerationMatch", valid_594398
  var valid_594399 = query.getOrDefault("generation")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "generation", valid_594399
  var valid_594400 = query.getOrDefault("prettyPrint")
  valid_594400 = validateParameter(valid_594400, JBool, required = false,
                                 default = newJBool(true))
  if valid_594400 != nil:
    section.add "prettyPrint", valid_594400
  var valid_594401 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "ifMetagenerationNotMatch", valid_594401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594402: Call_StorageObjectsDelete_594385; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes data blobs and associated metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_594402.validator(path, query, header, formData, body)
  let scheme = call_594402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594402.url(scheme.get, call_594402.host, call_594402.base,
                         call_594402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594402, url, valid)

proc call*(call_594403: Call_StorageObjectsDelete_594385; bucket: string;
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
  var path_594404 = newJObject()
  var query_594405 = newJObject()
  add(query_594405, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594404, "bucket", newJString(bucket))
  add(query_594405, "fields", newJString(fields))
  add(query_594405, "quotaUser", newJString(quotaUser))
  add(query_594405, "alt", newJString(alt))
  add(query_594405, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594405, "oauth_token", newJString(oauthToken))
  add(query_594405, "userIp", newJString(userIp))
  add(query_594405, "key", newJString(key))
  add(query_594405, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594405, "generation", newJString(generation))
  add(query_594405, "prettyPrint", newJBool(prettyPrint))
  add(query_594405, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594404, "object", newJString(`object`))
  result = call_594403.call(path_594404, query_594405, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_594385(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_594386, base: "/storage/v1beta2",
    url: url_StorageObjectsDelete_594387, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_594447 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsInsert_594449(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectAccessControlsInsert_594448(path: JsonNode;
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
  var valid_594450 = path.getOrDefault("bucket")
  valid_594450 = validateParameter(valid_594450, JString, required = true,
                                 default = nil)
  if valid_594450 != nil:
    section.add "bucket", valid_594450
  var valid_594451 = path.getOrDefault("object")
  valid_594451 = validateParameter(valid_594451, JString, required = true,
                                 default = nil)
  if valid_594451 != nil:
    section.add "object", valid_594451
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
  var valid_594452 = query.getOrDefault("fields")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "fields", valid_594452
  var valid_594453 = query.getOrDefault("quotaUser")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "quotaUser", valid_594453
  var valid_594454 = query.getOrDefault("alt")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = newJString("json"))
  if valid_594454 != nil:
    section.add "alt", valid_594454
  var valid_594455 = query.getOrDefault("oauth_token")
  valid_594455 = validateParameter(valid_594455, JString, required = false,
                                 default = nil)
  if valid_594455 != nil:
    section.add "oauth_token", valid_594455
  var valid_594456 = query.getOrDefault("userIp")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "userIp", valid_594456
  var valid_594457 = query.getOrDefault("key")
  valid_594457 = validateParameter(valid_594457, JString, required = false,
                                 default = nil)
  if valid_594457 != nil:
    section.add "key", valid_594457
  var valid_594458 = query.getOrDefault("generation")
  valid_594458 = validateParameter(valid_594458, JString, required = false,
                                 default = nil)
  if valid_594458 != nil:
    section.add "generation", valid_594458
  var valid_594459 = query.getOrDefault("prettyPrint")
  valid_594459 = validateParameter(valid_594459, JBool, required = false,
                                 default = newJBool(true))
  if valid_594459 != nil:
    section.add "prettyPrint", valid_594459
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

proc call*(call_594461: Call_StorageObjectAccessControlsInsert_594447;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_594461.validator(path, query, header, formData, body)
  let scheme = call_594461.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594461.url(scheme.get, call_594461.host, call_594461.base,
                         call_594461.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594461, url, valid)

proc call*(call_594462: Call_StorageObjectAccessControlsInsert_594447;
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
  var path_594463 = newJObject()
  var query_594464 = newJObject()
  var body_594465 = newJObject()
  add(path_594463, "bucket", newJString(bucket))
  add(query_594464, "fields", newJString(fields))
  add(query_594464, "quotaUser", newJString(quotaUser))
  add(query_594464, "alt", newJString(alt))
  add(query_594464, "oauth_token", newJString(oauthToken))
  add(query_594464, "userIp", newJString(userIp))
  add(query_594464, "key", newJString(key))
  add(query_594464, "generation", newJString(generation))
  if body != nil:
    body_594465 = body
  add(query_594464, "prettyPrint", newJBool(prettyPrint))
  add(path_594463, "object", newJString(`object`))
  result = call_594462.call(path_594463, query_594464, nil, nil, body_594465)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_594447(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_594448,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsInsert_594449,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_594430 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsList_594432(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectAccessControlsList_594431(path: JsonNode;
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
  var valid_594433 = path.getOrDefault("bucket")
  valid_594433 = validateParameter(valid_594433, JString, required = true,
                                 default = nil)
  if valid_594433 != nil:
    section.add "bucket", valid_594433
  var valid_594434 = path.getOrDefault("object")
  valid_594434 = validateParameter(valid_594434, JString, required = true,
                                 default = nil)
  if valid_594434 != nil:
    section.add "object", valid_594434
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
  var valid_594435 = query.getOrDefault("fields")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "fields", valid_594435
  var valid_594436 = query.getOrDefault("quotaUser")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "quotaUser", valid_594436
  var valid_594437 = query.getOrDefault("alt")
  valid_594437 = validateParameter(valid_594437, JString, required = false,
                                 default = newJString("json"))
  if valid_594437 != nil:
    section.add "alt", valid_594437
  var valid_594438 = query.getOrDefault("oauth_token")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "oauth_token", valid_594438
  var valid_594439 = query.getOrDefault("userIp")
  valid_594439 = validateParameter(valid_594439, JString, required = false,
                                 default = nil)
  if valid_594439 != nil:
    section.add "userIp", valid_594439
  var valid_594440 = query.getOrDefault("key")
  valid_594440 = validateParameter(valid_594440, JString, required = false,
                                 default = nil)
  if valid_594440 != nil:
    section.add "key", valid_594440
  var valid_594441 = query.getOrDefault("generation")
  valid_594441 = validateParameter(valid_594441, JString, required = false,
                                 default = nil)
  if valid_594441 != nil:
    section.add "generation", valid_594441
  var valid_594442 = query.getOrDefault("prettyPrint")
  valid_594442 = validateParameter(valid_594442, JBool, required = false,
                                 default = newJBool(true))
  if valid_594442 != nil:
    section.add "prettyPrint", valid_594442
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594443: Call_StorageObjectAccessControlsList_594430;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_594443.validator(path, query, header, formData, body)
  let scheme = call_594443.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594443.url(scheme.get, call_594443.host, call_594443.base,
                         call_594443.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594443, url, valid)

proc call*(call_594444: Call_StorageObjectAccessControlsList_594430;
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
  var path_594445 = newJObject()
  var query_594446 = newJObject()
  add(path_594445, "bucket", newJString(bucket))
  add(query_594446, "fields", newJString(fields))
  add(query_594446, "quotaUser", newJString(quotaUser))
  add(query_594446, "alt", newJString(alt))
  add(query_594446, "oauth_token", newJString(oauthToken))
  add(query_594446, "userIp", newJString(userIp))
  add(query_594446, "key", newJString(key))
  add(query_594446, "generation", newJString(generation))
  add(query_594446, "prettyPrint", newJBool(prettyPrint))
  add(path_594445, "object", newJString(`object`))
  result = call_594444.call(path_594445, query_594446, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_594430(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_594431,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsList_594432,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_594484 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsUpdate_594486(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectAccessControlsUpdate_594485(path: JsonNode;
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
  var valid_594487 = path.getOrDefault("bucket")
  valid_594487 = validateParameter(valid_594487, JString, required = true,
                                 default = nil)
  if valid_594487 != nil:
    section.add "bucket", valid_594487
  var valid_594488 = path.getOrDefault("entity")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "entity", valid_594488
  var valid_594489 = path.getOrDefault("object")
  valid_594489 = validateParameter(valid_594489, JString, required = true,
                                 default = nil)
  if valid_594489 != nil:
    section.add "object", valid_594489
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
  var valid_594490 = query.getOrDefault("fields")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "fields", valid_594490
  var valid_594491 = query.getOrDefault("quotaUser")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = nil)
  if valid_594491 != nil:
    section.add "quotaUser", valid_594491
  var valid_594492 = query.getOrDefault("alt")
  valid_594492 = validateParameter(valid_594492, JString, required = false,
                                 default = newJString("json"))
  if valid_594492 != nil:
    section.add "alt", valid_594492
  var valid_594493 = query.getOrDefault("oauth_token")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = nil)
  if valid_594493 != nil:
    section.add "oauth_token", valid_594493
  var valid_594494 = query.getOrDefault("userIp")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = nil)
  if valid_594494 != nil:
    section.add "userIp", valid_594494
  var valid_594495 = query.getOrDefault("key")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "key", valid_594495
  var valid_594496 = query.getOrDefault("generation")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = nil)
  if valid_594496 != nil:
    section.add "generation", valid_594496
  var valid_594497 = query.getOrDefault("prettyPrint")
  valid_594497 = validateParameter(valid_594497, JBool, required = false,
                                 default = newJBool(true))
  if valid_594497 != nil:
    section.add "prettyPrint", valid_594497
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

proc call*(call_594499: Call_StorageObjectAccessControlsUpdate_594484;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_594499.validator(path, query, header, formData, body)
  let scheme = call_594499.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594499.url(scheme.get, call_594499.host, call_594499.base,
                         call_594499.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594499, url, valid)

proc call*(call_594500: Call_StorageObjectAccessControlsUpdate_594484;
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
  var path_594501 = newJObject()
  var query_594502 = newJObject()
  var body_594503 = newJObject()
  add(path_594501, "bucket", newJString(bucket))
  add(query_594502, "fields", newJString(fields))
  add(query_594502, "quotaUser", newJString(quotaUser))
  add(query_594502, "alt", newJString(alt))
  add(query_594502, "oauth_token", newJString(oauthToken))
  add(query_594502, "userIp", newJString(userIp))
  add(query_594502, "key", newJString(key))
  add(query_594502, "generation", newJString(generation))
  if body != nil:
    body_594503 = body
  add(query_594502, "prettyPrint", newJBool(prettyPrint))
  add(path_594501, "entity", newJString(entity))
  add(path_594501, "object", newJString(`object`))
  result = call_594500.call(path_594501, query_594502, nil, nil, body_594503)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_594484(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_594485,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsUpdate_594486,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_594466 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsGet_594468(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectAccessControlsGet_594467(path: JsonNode;
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
  var valid_594469 = path.getOrDefault("bucket")
  valid_594469 = validateParameter(valid_594469, JString, required = true,
                                 default = nil)
  if valid_594469 != nil:
    section.add "bucket", valid_594469
  var valid_594470 = path.getOrDefault("entity")
  valid_594470 = validateParameter(valid_594470, JString, required = true,
                                 default = nil)
  if valid_594470 != nil:
    section.add "entity", valid_594470
  var valid_594471 = path.getOrDefault("object")
  valid_594471 = validateParameter(valid_594471, JString, required = true,
                                 default = nil)
  if valid_594471 != nil:
    section.add "object", valid_594471
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
  var valid_594472 = query.getOrDefault("fields")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "fields", valid_594472
  var valid_594473 = query.getOrDefault("quotaUser")
  valid_594473 = validateParameter(valid_594473, JString, required = false,
                                 default = nil)
  if valid_594473 != nil:
    section.add "quotaUser", valid_594473
  var valid_594474 = query.getOrDefault("alt")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = newJString("json"))
  if valid_594474 != nil:
    section.add "alt", valid_594474
  var valid_594475 = query.getOrDefault("oauth_token")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "oauth_token", valid_594475
  var valid_594476 = query.getOrDefault("userIp")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = nil)
  if valid_594476 != nil:
    section.add "userIp", valid_594476
  var valid_594477 = query.getOrDefault("key")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = nil)
  if valid_594477 != nil:
    section.add "key", valid_594477
  var valid_594478 = query.getOrDefault("generation")
  valid_594478 = validateParameter(valid_594478, JString, required = false,
                                 default = nil)
  if valid_594478 != nil:
    section.add "generation", valid_594478
  var valid_594479 = query.getOrDefault("prettyPrint")
  valid_594479 = validateParameter(valid_594479, JBool, required = false,
                                 default = newJBool(true))
  if valid_594479 != nil:
    section.add "prettyPrint", valid_594479
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594480: Call_StorageObjectAccessControlsGet_594466; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_594480.validator(path, query, header, formData, body)
  let scheme = call_594480.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594480.url(scheme.get, call_594480.host, call_594480.base,
                         call_594480.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594480, url, valid)

proc call*(call_594481: Call_StorageObjectAccessControlsGet_594466; bucket: string;
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
  var path_594482 = newJObject()
  var query_594483 = newJObject()
  add(path_594482, "bucket", newJString(bucket))
  add(query_594483, "fields", newJString(fields))
  add(query_594483, "quotaUser", newJString(quotaUser))
  add(query_594483, "alt", newJString(alt))
  add(query_594483, "oauth_token", newJString(oauthToken))
  add(query_594483, "userIp", newJString(userIp))
  add(query_594483, "key", newJString(key))
  add(query_594483, "generation", newJString(generation))
  add(query_594483, "prettyPrint", newJBool(prettyPrint))
  add(path_594482, "entity", newJString(entity))
  add(path_594482, "object", newJString(`object`))
  result = call_594481.call(path_594482, query_594483, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_594466(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_594467,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsGet_594468,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_594522 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsPatch_594524(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectAccessControlsPatch_594523(path: JsonNode;
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
  var valid_594525 = path.getOrDefault("bucket")
  valid_594525 = validateParameter(valid_594525, JString, required = true,
                                 default = nil)
  if valid_594525 != nil:
    section.add "bucket", valid_594525
  var valid_594526 = path.getOrDefault("entity")
  valid_594526 = validateParameter(valid_594526, JString, required = true,
                                 default = nil)
  if valid_594526 != nil:
    section.add "entity", valid_594526
  var valid_594527 = path.getOrDefault("object")
  valid_594527 = validateParameter(valid_594527, JString, required = true,
                                 default = nil)
  if valid_594527 != nil:
    section.add "object", valid_594527
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
  var valid_594528 = query.getOrDefault("fields")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = nil)
  if valid_594528 != nil:
    section.add "fields", valid_594528
  var valid_594529 = query.getOrDefault("quotaUser")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "quotaUser", valid_594529
  var valid_594530 = query.getOrDefault("alt")
  valid_594530 = validateParameter(valid_594530, JString, required = false,
                                 default = newJString("json"))
  if valid_594530 != nil:
    section.add "alt", valid_594530
  var valid_594531 = query.getOrDefault("oauth_token")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "oauth_token", valid_594531
  var valid_594532 = query.getOrDefault("userIp")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = nil)
  if valid_594532 != nil:
    section.add "userIp", valid_594532
  var valid_594533 = query.getOrDefault("key")
  valid_594533 = validateParameter(valid_594533, JString, required = false,
                                 default = nil)
  if valid_594533 != nil:
    section.add "key", valid_594533
  var valid_594534 = query.getOrDefault("generation")
  valid_594534 = validateParameter(valid_594534, JString, required = false,
                                 default = nil)
  if valid_594534 != nil:
    section.add "generation", valid_594534
  var valid_594535 = query.getOrDefault("prettyPrint")
  valid_594535 = validateParameter(valid_594535, JBool, required = false,
                                 default = newJBool(true))
  if valid_594535 != nil:
    section.add "prettyPrint", valid_594535
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

proc call*(call_594537: Call_StorageObjectAccessControlsPatch_594522;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object. This method supports patch semantics.
  ## 
  let valid = call_594537.validator(path, query, header, formData, body)
  let scheme = call_594537.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594537.url(scheme.get, call_594537.host, call_594537.base,
                         call_594537.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594537, url, valid)

proc call*(call_594538: Call_StorageObjectAccessControlsPatch_594522;
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
  var path_594539 = newJObject()
  var query_594540 = newJObject()
  var body_594541 = newJObject()
  add(path_594539, "bucket", newJString(bucket))
  add(query_594540, "fields", newJString(fields))
  add(query_594540, "quotaUser", newJString(quotaUser))
  add(query_594540, "alt", newJString(alt))
  add(query_594540, "oauth_token", newJString(oauthToken))
  add(query_594540, "userIp", newJString(userIp))
  add(query_594540, "key", newJString(key))
  add(query_594540, "generation", newJString(generation))
  if body != nil:
    body_594541 = body
  add(query_594540, "prettyPrint", newJBool(prettyPrint))
  add(path_594539, "entity", newJString(entity))
  add(path_594539, "object", newJString(`object`))
  result = call_594538.call(path_594539, query_594540, nil, nil, body_594541)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_594522(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_594523,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsPatch_594524,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_594504 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsDelete_594506(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectAccessControlsDelete_594505(path: JsonNode;
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
  var valid_594507 = path.getOrDefault("bucket")
  valid_594507 = validateParameter(valid_594507, JString, required = true,
                                 default = nil)
  if valid_594507 != nil:
    section.add "bucket", valid_594507
  var valid_594508 = path.getOrDefault("entity")
  valid_594508 = validateParameter(valid_594508, JString, required = true,
                                 default = nil)
  if valid_594508 != nil:
    section.add "entity", valid_594508
  var valid_594509 = path.getOrDefault("object")
  valid_594509 = validateParameter(valid_594509, JString, required = true,
                                 default = nil)
  if valid_594509 != nil:
    section.add "object", valid_594509
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
  var valid_594510 = query.getOrDefault("fields")
  valid_594510 = validateParameter(valid_594510, JString, required = false,
                                 default = nil)
  if valid_594510 != nil:
    section.add "fields", valid_594510
  var valid_594511 = query.getOrDefault("quotaUser")
  valid_594511 = validateParameter(valid_594511, JString, required = false,
                                 default = nil)
  if valid_594511 != nil:
    section.add "quotaUser", valid_594511
  var valid_594512 = query.getOrDefault("alt")
  valid_594512 = validateParameter(valid_594512, JString, required = false,
                                 default = newJString("json"))
  if valid_594512 != nil:
    section.add "alt", valid_594512
  var valid_594513 = query.getOrDefault("oauth_token")
  valid_594513 = validateParameter(valid_594513, JString, required = false,
                                 default = nil)
  if valid_594513 != nil:
    section.add "oauth_token", valid_594513
  var valid_594514 = query.getOrDefault("userIp")
  valid_594514 = validateParameter(valid_594514, JString, required = false,
                                 default = nil)
  if valid_594514 != nil:
    section.add "userIp", valid_594514
  var valid_594515 = query.getOrDefault("key")
  valid_594515 = validateParameter(valid_594515, JString, required = false,
                                 default = nil)
  if valid_594515 != nil:
    section.add "key", valid_594515
  var valid_594516 = query.getOrDefault("generation")
  valid_594516 = validateParameter(valid_594516, JString, required = false,
                                 default = nil)
  if valid_594516 != nil:
    section.add "generation", valid_594516
  var valid_594517 = query.getOrDefault("prettyPrint")
  valid_594517 = validateParameter(valid_594517, JBool, required = false,
                                 default = newJBool(true))
  if valid_594517 != nil:
    section.add "prettyPrint", valid_594517
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594518: Call_StorageObjectAccessControlsDelete_594504;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_594518.validator(path, query, header, formData, body)
  let scheme = call_594518.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594518.url(scheme.get, call_594518.host, call_594518.base,
                         call_594518.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594518, url, valid)

proc call*(call_594519: Call_StorageObjectAccessControlsDelete_594504;
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
  var path_594520 = newJObject()
  var query_594521 = newJObject()
  add(path_594520, "bucket", newJString(bucket))
  add(query_594521, "fields", newJString(fields))
  add(query_594521, "quotaUser", newJString(quotaUser))
  add(query_594521, "alt", newJString(alt))
  add(query_594521, "oauth_token", newJString(oauthToken))
  add(query_594521, "userIp", newJString(userIp))
  add(query_594521, "key", newJString(key))
  add(query_594521, "generation", newJString(generation))
  add(query_594521, "prettyPrint", newJBool(prettyPrint))
  add(path_594520, "entity", newJString(entity))
  add(path_594520, "object", newJString(`object`))
  result = call_594519.call(path_594520, query_594521, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_594504(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "storage.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_594505,
    base: "/storage/v1beta2", url: url_StorageObjectAccessControlsDelete_594506,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_594542 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsCompose_594544(protocol: Scheme; host: string; base: string;
                                     route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsCompose_594543(path: JsonNode; query: JsonNode;
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
  var valid_594545 = path.getOrDefault("destinationBucket")
  valid_594545 = validateParameter(valid_594545, JString, required = true,
                                 default = nil)
  if valid_594545 != nil:
    section.add "destinationBucket", valid_594545
  var valid_594546 = path.getOrDefault("destinationObject")
  valid_594546 = validateParameter(valid_594546, JString, required = true,
                                 default = nil)
  if valid_594546 != nil:
    section.add "destinationObject", valid_594546
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
  var valid_594547 = query.getOrDefault("ifGenerationMatch")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = nil)
  if valid_594547 != nil:
    section.add "ifGenerationMatch", valid_594547
  var valid_594548 = query.getOrDefault("fields")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = nil)
  if valid_594548 != nil:
    section.add "fields", valid_594548
  var valid_594549 = query.getOrDefault("quotaUser")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "quotaUser", valid_594549
  var valid_594550 = query.getOrDefault("alt")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = newJString("json"))
  if valid_594550 != nil:
    section.add "alt", valid_594550
  var valid_594551 = query.getOrDefault("oauth_token")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = nil)
  if valid_594551 != nil:
    section.add "oauth_token", valid_594551
  var valid_594552 = query.getOrDefault("userIp")
  valid_594552 = validateParameter(valid_594552, JString, required = false,
                                 default = nil)
  if valid_594552 != nil:
    section.add "userIp", valid_594552
  var valid_594553 = query.getOrDefault("key")
  valid_594553 = validateParameter(valid_594553, JString, required = false,
                                 default = nil)
  if valid_594553 != nil:
    section.add "key", valid_594553
  var valid_594554 = query.getOrDefault("ifMetagenerationMatch")
  valid_594554 = validateParameter(valid_594554, JString, required = false,
                                 default = nil)
  if valid_594554 != nil:
    section.add "ifMetagenerationMatch", valid_594554
  var valid_594555 = query.getOrDefault("prettyPrint")
  valid_594555 = validateParameter(valid_594555, JBool, required = false,
                                 default = newJBool(true))
  if valid_594555 != nil:
    section.add "prettyPrint", valid_594555
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

proc call*(call_594557: Call_StorageObjectsCompose_594542; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_594557.validator(path, query, header, formData, body)
  let scheme = call_594557.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594557.url(scheme.get, call_594557.host, call_594557.base,
                         call_594557.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594557, url, valid)

proc call*(call_594558: Call_StorageObjectsCompose_594542;
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
  var path_594559 = newJObject()
  var query_594560 = newJObject()
  var body_594561 = newJObject()
  add(query_594560, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_594560, "fields", newJString(fields))
  add(query_594560, "quotaUser", newJString(quotaUser))
  add(query_594560, "alt", newJString(alt))
  add(query_594560, "oauth_token", newJString(oauthToken))
  add(path_594559, "destinationBucket", newJString(destinationBucket))
  add(query_594560, "userIp", newJString(userIp))
  add(path_594559, "destinationObject", newJString(destinationObject))
  add(query_594560, "key", newJString(key))
  add(query_594560, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594561 = body
  add(query_594560, "prettyPrint", newJBool(prettyPrint))
  result = call_594558.call(path_594559, query_594560, nil, nil, body_594561)

var storageObjectsCompose* = Call_StorageObjectsCompose_594542(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_594543, base: "/storage/v1beta2",
    url: url_StorageObjectsCompose_594544, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_594562 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsCopy_594564(protocol: Scheme; host: string; base: string;
                                  route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
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

proc validate_StorageObjectsCopy_594563(path: JsonNode; query: JsonNode;
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
  var valid_594565 = path.getOrDefault("destinationBucket")
  valid_594565 = validateParameter(valid_594565, JString, required = true,
                                 default = nil)
  if valid_594565 != nil:
    section.add "destinationBucket", valid_594565
  var valid_594566 = path.getOrDefault("destinationObject")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "destinationObject", valid_594566
  var valid_594567 = path.getOrDefault("sourceBucket")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "sourceBucket", valid_594567
  var valid_594568 = path.getOrDefault("sourceObject")
  valid_594568 = validateParameter(valid_594568, JString, required = true,
                                 default = nil)
  if valid_594568 != nil:
    section.add "sourceObject", valid_594568
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
  var valid_594569 = query.getOrDefault("ifGenerationMatch")
  valid_594569 = validateParameter(valid_594569, JString, required = false,
                                 default = nil)
  if valid_594569 != nil:
    section.add "ifGenerationMatch", valid_594569
  var valid_594570 = query.getOrDefault("ifSourceGenerationMatch")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "ifSourceGenerationMatch", valid_594570
  var valid_594571 = query.getOrDefault("fields")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = nil)
  if valid_594571 != nil:
    section.add "fields", valid_594571
  var valid_594572 = query.getOrDefault("quotaUser")
  valid_594572 = validateParameter(valid_594572, JString, required = false,
                                 default = nil)
  if valid_594572 != nil:
    section.add "quotaUser", valid_594572
  var valid_594573 = query.getOrDefault("alt")
  valid_594573 = validateParameter(valid_594573, JString, required = false,
                                 default = newJString("json"))
  if valid_594573 != nil:
    section.add "alt", valid_594573
  var valid_594574 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_594574 = validateParameter(valid_594574, JString, required = false,
                                 default = nil)
  if valid_594574 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_594574
  var valid_594575 = query.getOrDefault("ifGenerationNotMatch")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = nil)
  if valid_594575 != nil:
    section.add "ifGenerationNotMatch", valid_594575
  var valid_594576 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = nil)
  if valid_594576 != nil:
    section.add "ifSourceMetagenerationMatch", valid_594576
  var valid_594577 = query.getOrDefault("oauth_token")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "oauth_token", valid_594577
  var valid_594578 = query.getOrDefault("sourceGeneration")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = nil)
  if valid_594578 != nil:
    section.add "sourceGeneration", valid_594578
  var valid_594579 = query.getOrDefault("userIp")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = nil)
  if valid_594579 != nil:
    section.add "userIp", valid_594579
  var valid_594580 = query.getOrDefault("key")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "key", valid_594580
  var valid_594581 = query.getOrDefault("projection")
  valid_594581 = validateParameter(valid_594581, JString, required = false,
                                 default = newJString("full"))
  if valid_594581 != nil:
    section.add "projection", valid_594581
  var valid_594582 = query.getOrDefault("ifMetagenerationMatch")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "ifMetagenerationMatch", valid_594582
  var valid_594583 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "ifSourceGenerationNotMatch", valid_594583
  var valid_594584 = query.getOrDefault("prettyPrint")
  valid_594584 = validateParameter(valid_594584, JBool, required = false,
                                 default = newJBool(true))
  if valid_594584 != nil:
    section.add "prettyPrint", valid_594584
  var valid_594585 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594585 = validateParameter(valid_594585, JString, required = false,
                                 default = nil)
  if valid_594585 != nil:
    section.add "ifMetagenerationNotMatch", valid_594585
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

proc call*(call_594587: Call_StorageObjectsCopy_594562; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies an object to a destination in the same location. Optionally overrides metadata.
  ## 
  let valid = call_594587.validator(path, query, header, formData, body)
  let scheme = call_594587.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594587.url(scheme.get, call_594587.host, call_594587.base,
                         call_594587.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594587, url, valid)

proc call*(call_594588: Call_StorageObjectsCopy_594562; destinationBucket: string;
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
  var path_594589 = newJObject()
  var query_594590 = newJObject()
  var body_594591 = newJObject()
  add(query_594590, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_594590, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_594590, "fields", newJString(fields))
  add(query_594590, "quotaUser", newJString(quotaUser))
  add(query_594590, "alt", newJString(alt))
  add(query_594590, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_594590, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594590, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_594590, "oauth_token", newJString(oauthToken))
  add(query_594590, "sourceGeneration", newJString(sourceGeneration))
  add(path_594589, "destinationBucket", newJString(destinationBucket))
  add(query_594590, "userIp", newJString(userIp))
  add(path_594589, "destinationObject", newJString(destinationObject))
  add(path_594589, "sourceBucket", newJString(sourceBucket))
  add(query_594590, "key", newJString(key))
  add(path_594589, "sourceObject", newJString(sourceObject))
  add(query_594590, "projection", newJString(projection))
  add(query_594590, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594590, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_594591 = body
  add(query_594590, "prettyPrint", newJBool(prettyPrint))
  add(query_594590, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  result = call_594588.call(path_594589, query_594590, nil, nil, body_594591)

var storageObjectsCopy* = Call_StorageObjectsCopy_594562(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_594563, base: "/storage/v1beta2",
    url: url_StorageObjectsCopy_594564, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_594592 = ref object of OpenApiRestCall_593424
proc url_StorageChannelsStop_594594(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StorageChannelsStop_594593(path: JsonNode; query: JsonNode;
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
  var valid_594595 = query.getOrDefault("fields")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "fields", valid_594595
  var valid_594596 = query.getOrDefault("quotaUser")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "quotaUser", valid_594596
  var valid_594597 = query.getOrDefault("alt")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = newJString("json"))
  if valid_594597 != nil:
    section.add "alt", valid_594597
  var valid_594598 = query.getOrDefault("oauth_token")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = nil)
  if valid_594598 != nil:
    section.add "oauth_token", valid_594598
  var valid_594599 = query.getOrDefault("userIp")
  valid_594599 = validateParameter(valid_594599, JString, required = false,
                                 default = nil)
  if valid_594599 != nil:
    section.add "userIp", valid_594599
  var valid_594600 = query.getOrDefault("key")
  valid_594600 = validateParameter(valid_594600, JString, required = false,
                                 default = nil)
  if valid_594600 != nil:
    section.add "key", valid_594600
  var valid_594601 = query.getOrDefault("prettyPrint")
  valid_594601 = validateParameter(valid_594601, JBool, required = false,
                                 default = newJBool(true))
  if valid_594601 != nil:
    section.add "prettyPrint", valid_594601
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

proc call*(call_594603: Call_StorageChannelsStop_594592; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_594603.validator(path, query, header, formData, body)
  let scheme = call_594603.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594603.url(scheme.get, call_594603.host, call_594603.base,
                         call_594603.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594603, url, valid)

proc call*(call_594604: Call_StorageChannelsStop_594592; fields: string = "";
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
  var query_594605 = newJObject()
  var body_594606 = newJObject()
  add(query_594605, "fields", newJString(fields))
  add(query_594605, "quotaUser", newJString(quotaUser))
  add(query_594605, "alt", newJString(alt))
  add(query_594605, "oauth_token", newJString(oauthToken))
  add(query_594605, "userIp", newJString(userIp))
  add(query_594605, "key", newJString(key))
  if resource != nil:
    body_594606 = resource
  add(query_594605, "prettyPrint", newJBool(prettyPrint))
  result = call_594604.call(nil, query_594605, nil, nil, body_594606)

var storageChannelsStop* = Call_StorageChannelsStop_594592(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "storage.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_594593, base: "/storage/v1beta2",
    url: url_StorageChannelsStop_594594, schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
