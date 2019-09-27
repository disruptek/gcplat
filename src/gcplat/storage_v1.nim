
import
  json, options, hashes, uri, openapi/rest, os, uri, strutils, httpcore

## auto-generated via openapi macro
## title: Cloud Storage
## version: v1
## termsOfService: https://developers.google.com/terms/
## license:
##     name: Creative Commons Attribution 3.0
##     url: http://creativecommons.org/licenses/by/3.0/
## 
## Stores and retrieves potentially large, immutable data objects.
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
  Call_StorageBucketsInsert_593968 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsInsert_593970(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_593969(path: JsonNode; query: JsonNode;
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
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_593971 = query.getOrDefault("fields")
  valid_593971 = validateParameter(valid_593971, JString, required = false,
                                 default = nil)
  if valid_593971 != nil:
    section.add "fields", valid_593971
  var valid_593972 = query.getOrDefault("quotaUser")
  valid_593972 = validateParameter(valid_593972, JString, required = false,
                                 default = nil)
  if valid_593972 != nil:
    section.add "quotaUser", valid_593972
  var valid_593973 = query.getOrDefault("alt")
  valid_593973 = validateParameter(valid_593973, JString, required = false,
                                 default = newJString("json"))
  if valid_593973 != nil:
    section.add "alt", valid_593973
  var valid_593974 = query.getOrDefault("oauth_token")
  valid_593974 = validateParameter(valid_593974, JString, required = false,
                                 default = nil)
  if valid_593974 != nil:
    section.add "oauth_token", valid_593974
  var valid_593975 = query.getOrDefault("userIp")
  valid_593975 = validateParameter(valid_593975, JString, required = false,
                                 default = nil)
  if valid_593975 != nil:
    section.add "userIp", valid_593975
  var valid_593976 = query.getOrDefault("predefinedAcl")
  valid_593976 = validateParameter(valid_593976, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_593976 != nil:
    section.add "predefinedAcl", valid_593976
  var valid_593977 = query.getOrDefault("userProject")
  valid_593977 = validateParameter(valid_593977, JString, required = false,
                                 default = nil)
  if valid_593977 != nil:
    section.add "userProject", valid_593977
  var valid_593978 = query.getOrDefault("key")
  valid_593978 = validateParameter(valid_593978, JString, required = false,
                                 default = nil)
  if valid_593978 != nil:
    section.add "key", valid_593978
  var valid_593979 = query.getOrDefault("projection")
  valid_593979 = validateParameter(valid_593979, JString, required = false,
                                 default = newJString("full"))
  if valid_593979 != nil:
    section.add "projection", valid_593979
  var valid_593980 = query.getOrDefault("prettyPrint")
  valid_593980 = validateParameter(valid_593980, JBool, required = false,
                                 default = newJBool(true))
  if valid_593980 != nil:
    section.add "prettyPrint", valid_593980
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_593981 = query.getOrDefault("project")
  valid_593981 = validateParameter(valid_593981, JString, required = true,
                                 default = nil)
  if valid_593981 != nil:
    section.add "project", valid_593981
  var valid_593982 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_593982 = validateParameter(valid_593982, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_593982 != nil:
    section.add "predefinedDefaultObjectAcl", valid_593982
  var valid_593983 = query.getOrDefault("provisionalUserProject")
  valid_593983 = validateParameter(valid_593983, JString, required = false,
                                 default = nil)
  if valid_593983 != nil:
    section.add "provisionalUserProject", valid_593983
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

proc call*(call_593985: Call_StorageBucketsInsert_593968; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_593985.validator(path, query, header, formData, body)
  let scheme = call_593985.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593985.url(scheme.get, call_593985.host, call_593985.base,
                         call_593985.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593985, url, valid)

proc call*(call_593986: Call_StorageBucketsInsert_593968; project: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; projection: string = "full"; body: JsonNode = nil;
          prettyPrint: bool = true;
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""): Recallable =
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
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the bucket resource specifies acl or defaultObjectAcl properties, when it defaults to full.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var query_593987 = newJObject()
  var body_593988 = newJObject()
  add(query_593987, "fields", newJString(fields))
  add(query_593987, "quotaUser", newJString(quotaUser))
  add(query_593987, "alt", newJString(alt))
  add(query_593987, "oauth_token", newJString(oauthToken))
  add(query_593987, "userIp", newJString(userIp))
  add(query_593987, "predefinedAcl", newJString(predefinedAcl))
  add(query_593987, "userProject", newJString(userProject))
  add(query_593987, "key", newJString(key))
  add(query_593987, "projection", newJString(projection))
  if body != nil:
    body_593988 = body
  add(query_593987, "prettyPrint", newJBool(prettyPrint))
  add(query_593987, "project", newJString(project))
  add(query_593987, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_593987, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_593986.call(nil, query_593987, nil, nil, body_593988)

var storageBucketsInsert* = Call_StorageBucketsInsert_593968(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_593969, base: "/storage/v1",
    url: url_StorageBucketsInsert_593970, schemes: {Scheme.Https})
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
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl.
  ##   project: JString (required)
  ##          : A valid API project identifier.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: JString
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
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
  var valid_593826 = query.getOrDefault("maxResults")
  valid_593826 = validateParameter(valid_593826, JInt, required = false,
                                 default = newJInt(1000))
  if valid_593826 != nil:
    section.add "maxResults", valid_593826
  var valid_593827 = query.getOrDefault("userProject")
  valid_593827 = validateParameter(valid_593827, JString, required = false,
                                 default = nil)
  if valid_593827 != nil:
    section.add "userProject", valid_593827
  var valid_593828 = query.getOrDefault("key")
  valid_593828 = validateParameter(valid_593828, JString, required = false,
                                 default = nil)
  if valid_593828 != nil:
    section.add "key", valid_593828
  var valid_593829 = query.getOrDefault("projection")
  valid_593829 = validateParameter(valid_593829, JString, required = false,
                                 default = newJString("full"))
  if valid_593829 != nil:
    section.add "projection", valid_593829
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_593830 = query.getOrDefault("project")
  valid_593830 = validateParameter(valid_593830, JString, required = true,
                                 default = nil)
  if valid_593830 != nil:
    section.add "project", valid_593830
  var valid_593831 = query.getOrDefault("prettyPrint")
  valid_593831 = validateParameter(valid_593831, JBool, required = false,
                                 default = newJBool(true))
  if valid_593831 != nil:
    section.add "prettyPrint", valid_593831
  var valid_593832 = query.getOrDefault("prefix")
  valid_593832 = validateParameter(valid_593832, JString, required = false,
                                 default = nil)
  if valid_593832 != nil:
    section.add "prefix", valid_593832
  var valid_593833 = query.getOrDefault("provisionalUserProject")
  valid_593833 = validateParameter(valid_593833, JString, required = false,
                                 default = nil)
  if valid_593833 != nil:
    section.add "provisionalUserProject", valid_593833
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_593856: Call_StorageBucketsList_593692; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_593856.validator(path, query, header, formData, body)
  let scheme = call_593856.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_593856.url(scheme.get, call_593856.host, call_593856.base,
                         call_593856.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_593856, url, valid)

proc call*(call_593927: Call_StorageBucketsList_593692; project: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 1000; userProject: string = ""; key: string = "";
          projection: string = "full"; prettyPrint: bool = true; prefix: string = "";
          provisionalUserProject: string = ""): Recallable =
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
  ##             : Maximum number of buckets to return in a single response. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl.
  ##   project: string (required)
  ##          : A valid API project identifier.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   prefix: string
  ##         : Filter results to buckets whose names begin with this prefix.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var query_593928 = newJObject()
  add(query_593928, "fields", newJString(fields))
  add(query_593928, "pageToken", newJString(pageToken))
  add(query_593928, "quotaUser", newJString(quotaUser))
  add(query_593928, "alt", newJString(alt))
  add(query_593928, "oauth_token", newJString(oauthToken))
  add(query_593928, "userIp", newJString(userIp))
  add(query_593928, "maxResults", newJInt(maxResults))
  add(query_593928, "userProject", newJString(userProject))
  add(query_593928, "key", newJString(key))
  add(query_593928, "projection", newJString(projection))
  add(query_593928, "project", newJString(project))
  add(query_593928, "prettyPrint", newJBool(prettyPrint))
  add(query_593928, "prefix", newJString(prefix))
  add(query_593928, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_593927.call(nil, query_593928, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_593692(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b", validator: validate_StorageBucketsList_593693,
    base: "/storage/v1", url: url_StorageBucketsList_593694, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_594023 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsUpdate_594025(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsUpdate_594024(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594026 = path.getOrDefault("bucket")
  valid_594026 = validateParameter(valid_594026, JString, required = true,
                                 default = nil)
  if valid_594026 != nil:
    section.add "bucket", valid_594026
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
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594027 = query.getOrDefault("fields")
  valid_594027 = validateParameter(valid_594027, JString, required = false,
                                 default = nil)
  if valid_594027 != nil:
    section.add "fields", valid_594027
  var valid_594028 = query.getOrDefault("quotaUser")
  valid_594028 = validateParameter(valid_594028, JString, required = false,
                                 default = nil)
  if valid_594028 != nil:
    section.add "quotaUser", valid_594028
  var valid_594029 = query.getOrDefault("alt")
  valid_594029 = validateParameter(valid_594029, JString, required = false,
                                 default = newJString("json"))
  if valid_594029 != nil:
    section.add "alt", valid_594029
  var valid_594030 = query.getOrDefault("oauth_token")
  valid_594030 = validateParameter(valid_594030, JString, required = false,
                                 default = nil)
  if valid_594030 != nil:
    section.add "oauth_token", valid_594030
  var valid_594031 = query.getOrDefault("userIp")
  valid_594031 = validateParameter(valid_594031, JString, required = false,
                                 default = nil)
  if valid_594031 != nil:
    section.add "userIp", valid_594031
  var valid_594032 = query.getOrDefault("predefinedAcl")
  valid_594032 = validateParameter(valid_594032, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594032 != nil:
    section.add "predefinedAcl", valid_594032
  var valid_594033 = query.getOrDefault("userProject")
  valid_594033 = validateParameter(valid_594033, JString, required = false,
                                 default = nil)
  if valid_594033 != nil:
    section.add "userProject", valid_594033
  var valid_594034 = query.getOrDefault("key")
  valid_594034 = validateParameter(valid_594034, JString, required = false,
                                 default = nil)
  if valid_594034 != nil:
    section.add "key", valid_594034
  var valid_594035 = query.getOrDefault("projection")
  valid_594035 = validateParameter(valid_594035, JString, required = false,
                                 default = newJString("full"))
  if valid_594035 != nil:
    section.add "projection", valid_594035
  var valid_594036 = query.getOrDefault("ifMetagenerationMatch")
  valid_594036 = validateParameter(valid_594036, JString, required = false,
                                 default = nil)
  if valid_594036 != nil:
    section.add "ifMetagenerationMatch", valid_594036
  var valid_594037 = query.getOrDefault("prettyPrint")
  valid_594037 = validateParameter(valid_594037, JBool, required = false,
                                 default = newJBool(true))
  if valid_594037 != nil:
    section.add "prettyPrint", valid_594037
  var valid_594038 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594038 = validateParameter(valid_594038, JString, required = false,
                                 default = nil)
  if valid_594038 != nil:
    section.add "ifMetagenerationNotMatch", valid_594038
  var valid_594039 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_594039 = validateParameter(valid_594039, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594039 != nil:
    section.add "predefinedDefaultObjectAcl", valid_594039
  var valid_594040 = query.getOrDefault("provisionalUserProject")
  valid_594040 = validateParameter(valid_594040, JString, required = false,
                                 default = nil)
  if valid_594040 != nil:
    section.add "provisionalUserProject", valid_594040
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

proc call*(call_594042: Call_StorageBucketsUpdate_594023; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_594042.validator(path, query, header, formData, body)
  let scheme = call_594042.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594042.url(scheme.get, call_594042.host, call_594042.base,
                         call_594042.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594042, url, valid)

proc call*(call_594043: Call_StorageBucketsUpdate_594023; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsUpdate
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
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
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594044 = newJObject()
  var query_594045 = newJObject()
  var body_594046 = newJObject()
  add(path_594044, "bucket", newJString(bucket))
  add(query_594045, "fields", newJString(fields))
  add(query_594045, "quotaUser", newJString(quotaUser))
  add(query_594045, "alt", newJString(alt))
  add(query_594045, "oauth_token", newJString(oauthToken))
  add(query_594045, "userIp", newJString(userIp))
  add(query_594045, "predefinedAcl", newJString(predefinedAcl))
  add(query_594045, "userProject", newJString(userProject))
  add(query_594045, "key", newJString(key))
  add(query_594045, "projection", newJString(projection))
  add(query_594045, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594046 = body
  add(query_594045, "prettyPrint", newJBool(prettyPrint))
  add(query_594045, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594045, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_594045, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594043.call(path_594044, query_594045, nil, nil, body_594046)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_594023(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_594024, base: "/storage/v1",
    url: url_StorageBucketsUpdate_594025, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_593989 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsGet_593991(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsGet_593990(path: JsonNode; query: JsonNode;
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
  var valid_594006 = path.getOrDefault("bucket")
  valid_594006 = validateParameter(valid_594006, JString, required = true,
                                 default = nil)
  if valid_594006 != nil:
    section.add "bucket", valid_594006
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594007 = query.getOrDefault("fields")
  valid_594007 = validateParameter(valid_594007, JString, required = false,
                                 default = nil)
  if valid_594007 != nil:
    section.add "fields", valid_594007
  var valid_594008 = query.getOrDefault("quotaUser")
  valid_594008 = validateParameter(valid_594008, JString, required = false,
                                 default = nil)
  if valid_594008 != nil:
    section.add "quotaUser", valid_594008
  var valid_594009 = query.getOrDefault("alt")
  valid_594009 = validateParameter(valid_594009, JString, required = false,
                                 default = newJString("json"))
  if valid_594009 != nil:
    section.add "alt", valid_594009
  var valid_594010 = query.getOrDefault("oauth_token")
  valid_594010 = validateParameter(valid_594010, JString, required = false,
                                 default = nil)
  if valid_594010 != nil:
    section.add "oauth_token", valid_594010
  var valid_594011 = query.getOrDefault("userIp")
  valid_594011 = validateParameter(valid_594011, JString, required = false,
                                 default = nil)
  if valid_594011 != nil:
    section.add "userIp", valid_594011
  var valid_594012 = query.getOrDefault("userProject")
  valid_594012 = validateParameter(valid_594012, JString, required = false,
                                 default = nil)
  if valid_594012 != nil:
    section.add "userProject", valid_594012
  var valid_594013 = query.getOrDefault("key")
  valid_594013 = validateParameter(valid_594013, JString, required = false,
                                 default = nil)
  if valid_594013 != nil:
    section.add "key", valid_594013
  var valid_594014 = query.getOrDefault("projection")
  valid_594014 = validateParameter(valid_594014, JString, required = false,
                                 default = newJString("full"))
  if valid_594014 != nil:
    section.add "projection", valid_594014
  var valid_594015 = query.getOrDefault("ifMetagenerationMatch")
  valid_594015 = validateParameter(valid_594015, JString, required = false,
                                 default = nil)
  if valid_594015 != nil:
    section.add "ifMetagenerationMatch", valid_594015
  var valid_594016 = query.getOrDefault("prettyPrint")
  valid_594016 = validateParameter(valid_594016, JBool, required = false,
                                 default = newJBool(true))
  if valid_594016 != nil:
    section.add "prettyPrint", valid_594016
  var valid_594017 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594017 = validateParameter(valid_594017, JString, required = false,
                                 default = nil)
  if valid_594017 != nil:
    section.add "ifMetagenerationNotMatch", valid_594017
  var valid_594018 = query.getOrDefault("provisionalUserProject")
  valid_594018 = validateParameter(valid_594018, JString, required = false,
                                 default = nil)
  if valid_594018 != nil:
    section.add "provisionalUserProject", valid_594018
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594019: Call_StorageBucketsGet_593989; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_594019.validator(path, query, header, formData, body)
  let scheme = call_594019.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594019.url(scheme.get, call_594019.host, call_594019.base,
                         call_594019.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594019, url, valid)

proc call*(call_594020: Call_StorageBucketsGet_593989; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594021 = newJObject()
  var query_594022 = newJObject()
  add(path_594021, "bucket", newJString(bucket))
  add(query_594022, "fields", newJString(fields))
  add(query_594022, "quotaUser", newJString(quotaUser))
  add(query_594022, "alt", newJString(alt))
  add(query_594022, "oauth_token", newJString(oauthToken))
  add(query_594022, "userIp", newJString(userIp))
  add(query_594022, "userProject", newJString(userProject))
  add(query_594022, "key", newJString(key))
  add(query_594022, "projection", newJString(projection))
  add(query_594022, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594022, "prettyPrint", newJBool(prettyPrint))
  add(query_594022, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594022, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594020.call(path_594021, query_594022, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_593989(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_593990, base: "/storage/v1",
    url: url_StorageBucketsGet_593991, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_594066 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsPatch_594068(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsPatch_594067(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594069 = path.getOrDefault("bucket")
  valid_594069 = validateParameter(valid_594069, JString, required = true,
                                 default = nil)
  if valid_594069 != nil:
    section.add "bucket", valid_594069
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
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   predefinedDefaultObjectAcl: JString
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594070 = query.getOrDefault("fields")
  valid_594070 = validateParameter(valid_594070, JString, required = false,
                                 default = nil)
  if valid_594070 != nil:
    section.add "fields", valid_594070
  var valid_594071 = query.getOrDefault("quotaUser")
  valid_594071 = validateParameter(valid_594071, JString, required = false,
                                 default = nil)
  if valid_594071 != nil:
    section.add "quotaUser", valid_594071
  var valid_594072 = query.getOrDefault("alt")
  valid_594072 = validateParameter(valid_594072, JString, required = false,
                                 default = newJString("json"))
  if valid_594072 != nil:
    section.add "alt", valid_594072
  var valid_594073 = query.getOrDefault("oauth_token")
  valid_594073 = validateParameter(valid_594073, JString, required = false,
                                 default = nil)
  if valid_594073 != nil:
    section.add "oauth_token", valid_594073
  var valid_594074 = query.getOrDefault("userIp")
  valid_594074 = validateParameter(valid_594074, JString, required = false,
                                 default = nil)
  if valid_594074 != nil:
    section.add "userIp", valid_594074
  var valid_594075 = query.getOrDefault("predefinedAcl")
  valid_594075 = validateParameter(valid_594075, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594075 != nil:
    section.add "predefinedAcl", valid_594075
  var valid_594076 = query.getOrDefault("userProject")
  valid_594076 = validateParameter(valid_594076, JString, required = false,
                                 default = nil)
  if valid_594076 != nil:
    section.add "userProject", valid_594076
  var valid_594077 = query.getOrDefault("key")
  valid_594077 = validateParameter(valid_594077, JString, required = false,
                                 default = nil)
  if valid_594077 != nil:
    section.add "key", valid_594077
  var valid_594078 = query.getOrDefault("projection")
  valid_594078 = validateParameter(valid_594078, JString, required = false,
                                 default = newJString("full"))
  if valid_594078 != nil:
    section.add "projection", valid_594078
  var valid_594079 = query.getOrDefault("ifMetagenerationMatch")
  valid_594079 = validateParameter(valid_594079, JString, required = false,
                                 default = nil)
  if valid_594079 != nil:
    section.add "ifMetagenerationMatch", valid_594079
  var valid_594080 = query.getOrDefault("prettyPrint")
  valid_594080 = validateParameter(valid_594080, JBool, required = false,
                                 default = newJBool(true))
  if valid_594080 != nil:
    section.add "prettyPrint", valid_594080
  var valid_594081 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594081 = validateParameter(valid_594081, JString, required = false,
                                 default = nil)
  if valid_594081 != nil:
    section.add "ifMetagenerationNotMatch", valid_594081
  var valid_594082 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_594082 = validateParameter(valid_594082, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594082 != nil:
    section.add "predefinedDefaultObjectAcl", valid_594082
  var valid_594083 = query.getOrDefault("provisionalUserProject")
  valid_594083 = validateParameter(valid_594083, JString, required = false,
                                 default = nil)
  if valid_594083 != nil:
    section.add "provisionalUserProject", valid_594083
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

proc call*(call_594085: Call_StorageBucketsPatch_594066; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_594085.validator(path, query, header, formData, body)
  let scheme = call_594085.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594085.url(scheme.get, call_594085.host, call_594085.base,
                         call_594085.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594085, url, valid)

proc call*(call_594086: Call_StorageBucketsPatch_594066; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          predefinedDefaultObjectAcl: string = "authenticatedRead";
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsPatch
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
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
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this bucket.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   predefinedDefaultObjectAcl: string
  ##                             : Apply a predefined set of default object access controls to this bucket.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594087 = newJObject()
  var query_594088 = newJObject()
  var body_594089 = newJObject()
  add(path_594087, "bucket", newJString(bucket))
  add(query_594088, "fields", newJString(fields))
  add(query_594088, "quotaUser", newJString(quotaUser))
  add(query_594088, "alt", newJString(alt))
  add(query_594088, "oauth_token", newJString(oauthToken))
  add(query_594088, "userIp", newJString(userIp))
  add(query_594088, "predefinedAcl", newJString(predefinedAcl))
  add(query_594088, "userProject", newJString(userProject))
  add(query_594088, "key", newJString(key))
  add(query_594088, "projection", newJString(projection))
  add(query_594088, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594089 = body
  add(query_594088, "prettyPrint", newJBool(prettyPrint))
  add(query_594088, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594088, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_594088, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594086.call(path_594087, query_594088, nil, nil, body_594089)

var storageBucketsPatch* = Call_StorageBucketsPatch_594066(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_594067, base: "/storage/v1",
    url: url_StorageBucketsPatch_594068, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_594047 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsDelete_594049(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsDelete_594048(path: JsonNode; query: JsonNode;
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
  var valid_594050 = path.getOrDefault("bucket")
  valid_594050 = validateParameter(valid_594050, JString, required = true,
                                 default = nil)
  if valid_594050 != nil:
    section.add "bucket", valid_594050
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594051 = query.getOrDefault("fields")
  valid_594051 = validateParameter(valid_594051, JString, required = false,
                                 default = nil)
  if valid_594051 != nil:
    section.add "fields", valid_594051
  var valid_594052 = query.getOrDefault("quotaUser")
  valid_594052 = validateParameter(valid_594052, JString, required = false,
                                 default = nil)
  if valid_594052 != nil:
    section.add "quotaUser", valid_594052
  var valid_594053 = query.getOrDefault("alt")
  valid_594053 = validateParameter(valid_594053, JString, required = false,
                                 default = newJString("json"))
  if valid_594053 != nil:
    section.add "alt", valid_594053
  var valid_594054 = query.getOrDefault("oauth_token")
  valid_594054 = validateParameter(valid_594054, JString, required = false,
                                 default = nil)
  if valid_594054 != nil:
    section.add "oauth_token", valid_594054
  var valid_594055 = query.getOrDefault("userIp")
  valid_594055 = validateParameter(valid_594055, JString, required = false,
                                 default = nil)
  if valid_594055 != nil:
    section.add "userIp", valid_594055
  var valid_594056 = query.getOrDefault("userProject")
  valid_594056 = validateParameter(valid_594056, JString, required = false,
                                 default = nil)
  if valid_594056 != nil:
    section.add "userProject", valid_594056
  var valid_594057 = query.getOrDefault("key")
  valid_594057 = validateParameter(valid_594057, JString, required = false,
                                 default = nil)
  if valid_594057 != nil:
    section.add "key", valid_594057
  var valid_594058 = query.getOrDefault("ifMetagenerationMatch")
  valid_594058 = validateParameter(valid_594058, JString, required = false,
                                 default = nil)
  if valid_594058 != nil:
    section.add "ifMetagenerationMatch", valid_594058
  var valid_594059 = query.getOrDefault("prettyPrint")
  valid_594059 = validateParameter(valid_594059, JBool, required = false,
                                 default = newJBool(true))
  if valid_594059 != nil:
    section.add "prettyPrint", valid_594059
  var valid_594060 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594060 = validateParameter(valid_594060, JString, required = false,
                                 default = nil)
  if valid_594060 != nil:
    section.add "ifMetagenerationNotMatch", valid_594060
  var valid_594061 = query.getOrDefault("provisionalUserProject")
  valid_594061 = validateParameter(valid_594061, JString, required = false,
                                 default = nil)
  if valid_594061 != nil:
    section.add "provisionalUserProject", valid_594061
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594062: Call_StorageBucketsDelete_594047; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_594062.validator(path, query, header, formData, body)
  let scheme = call_594062.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594062.url(scheme.get, call_594062.host, call_594062.base,
                         call_594062.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594062, url, valid)

proc call*(call_594063: Call_StorageBucketsDelete_594047; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; ifMetagenerationMatch: string = "";
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string
  ##                        : If set, only deletes the bucket if its metageneration matches this value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : If set, only deletes the bucket if its metageneration does not match this value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594064 = newJObject()
  var query_594065 = newJObject()
  add(path_594064, "bucket", newJString(bucket))
  add(query_594065, "fields", newJString(fields))
  add(query_594065, "quotaUser", newJString(quotaUser))
  add(query_594065, "alt", newJString(alt))
  add(query_594065, "oauth_token", newJString(oauthToken))
  add(query_594065, "userIp", newJString(userIp))
  add(query_594065, "userProject", newJString(userProject))
  add(query_594065, "key", newJString(key))
  add(query_594065, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594065, "prettyPrint", newJBool(prettyPrint))
  add(query_594065, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594065, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594063.call(path_594064, query_594065, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_594047(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_594048, base: "/storage/v1",
    url: url_StorageBucketsDelete_594049, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_594107 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsInsert_594109(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsInsert_594108(path: JsonNode;
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
  var valid_594110 = path.getOrDefault("bucket")
  valid_594110 = validateParameter(valid_594110, JString, required = true,
                                 default = nil)
  if valid_594110 != nil:
    section.add "bucket", valid_594110
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594111 = query.getOrDefault("fields")
  valid_594111 = validateParameter(valid_594111, JString, required = false,
                                 default = nil)
  if valid_594111 != nil:
    section.add "fields", valid_594111
  var valid_594112 = query.getOrDefault("quotaUser")
  valid_594112 = validateParameter(valid_594112, JString, required = false,
                                 default = nil)
  if valid_594112 != nil:
    section.add "quotaUser", valid_594112
  var valid_594113 = query.getOrDefault("alt")
  valid_594113 = validateParameter(valid_594113, JString, required = false,
                                 default = newJString("json"))
  if valid_594113 != nil:
    section.add "alt", valid_594113
  var valid_594114 = query.getOrDefault("oauth_token")
  valid_594114 = validateParameter(valid_594114, JString, required = false,
                                 default = nil)
  if valid_594114 != nil:
    section.add "oauth_token", valid_594114
  var valid_594115 = query.getOrDefault("userIp")
  valid_594115 = validateParameter(valid_594115, JString, required = false,
                                 default = nil)
  if valid_594115 != nil:
    section.add "userIp", valid_594115
  var valid_594116 = query.getOrDefault("userProject")
  valid_594116 = validateParameter(valid_594116, JString, required = false,
                                 default = nil)
  if valid_594116 != nil:
    section.add "userProject", valid_594116
  var valid_594117 = query.getOrDefault("key")
  valid_594117 = validateParameter(valid_594117, JString, required = false,
                                 default = nil)
  if valid_594117 != nil:
    section.add "key", valid_594117
  var valid_594118 = query.getOrDefault("prettyPrint")
  valid_594118 = validateParameter(valid_594118, JBool, required = false,
                                 default = newJBool(true))
  if valid_594118 != nil:
    section.add "prettyPrint", valid_594118
  var valid_594119 = query.getOrDefault("provisionalUserProject")
  valid_594119 = validateParameter(valid_594119, JString, required = false,
                                 default = nil)
  if valid_594119 != nil:
    section.add "provisionalUserProject", valid_594119
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

proc call*(call_594121: Call_StorageBucketAccessControlsInsert_594107;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_594121.validator(path, query, header, formData, body)
  let scheme = call_594121.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594121.url(scheme.get, call_594121.host, call_594121.base,
                         call_594121.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594121, url, valid)

proc call*(call_594122: Call_StorageBucketAccessControlsInsert_594107;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594123 = newJObject()
  var query_594124 = newJObject()
  var body_594125 = newJObject()
  add(path_594123, "bucket", newJString(bucket))
  add(query_594124, "fields", newJString(fields))
  add(query_594124, "quotaUser", newJString(quotaUser))
  add(query_594124, "alt", newJString(alt))
  add(query_594124, "oauth_token", newJString(oauthToken))
  add(query_594124, "userIp", newJString(userIp))
  add(query_594124, "userProject", newJString(userProject))
  add(query_594124, "key", newJString(key))
  if body != nil:
    body_594125 = body
  add(query_594124, "prettyPrint", newJBool(prettyPrint))
  add(query_594124, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594122.call(path_594123, query_594124, nil, nil, body_594125)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_594107(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_594108,
    base: "/storage/v1", url: url_StorageBucketAccessControlsInsert_594109,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_594090 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsList_594092(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsList_594091(path: JsonNode;
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
  var valid_594093 = path.getOrDefault("bucket")
  valid_594093 = validateParameter(valid_594093, JString, required = true,
                                 default = nil)
  if valid_594093 != nil:
    section.add "bucket", valid_594093
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594094 = query.getOrDefault("fields")
  valid_594094 = validateParameter(valid_594094, JString, required = false,
                                 default = nil)
  if valid_594094 != nil:
    section.add "fields", valid_594094
  var valid_594095 = query.getOrDefault("quotaUser")
  valid_594095 = validateParameter(valid_594095, JString, required = false,
                                 default = nil)
  if valid_594095 != nil:
    section.add "quotaUser", valid_594095
  var valid_594096 = query.getOrDefault("alt")
  valid_594096 = validateParameter(valid_594096, JString, required = false,
                                 default = newJString("json"))
  if valid_594096 != nil:
    section.add "alt", valid_594096
  var valid_594097 = query.getOrDefault("oauth_token")
  valid_594097 = validateParameter(valid_594097, JString, required = false,
                                 default = nil)
  if valid_594097 != nil:
    section.add "oauth_token", valid_594097
  var valid_594098 = query.getOrDefault("userIp")
  valid_594098 = validateParameter(valid_594098, JString, required = false,
                                 default = nil)
  if valid_594098 != nil:
    section.add "userIp", valid_594098
  var valid_594099 = query.getOrDefault("userProject")
  valid_594099 = validateParameter(valid_594099, JString, required = false,
                                 default = nil)
  if valid_594099 != nil:
    section.add "userProject", valid_594099
  var valid_594100 = query.getOrDefault("key")
  valid_594100 = validateParameter(valid_594100, JString, required = false,
                                 default = nil)
  if valid_594100 != nil:
    section.add "key", valid_594100
  var valid_594101 = query.getOrDefault("prettyPrint")
  valid_594101 = validateParameter(valid_594101, JBool, required = false,
                                 default = newJBool(true))
  if valid_594101 != nil:
    section.add "prettyPrint", valid_594101
  var valid_594102 = query.getOrDefault("provisionalUserProject")
  valid_594102 = validateParameter(valid_594102, JString, required = false,
                                 default = nil)
  if valid_594102 != nil:
    section.add "provisionalUserProject", valid_594102
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594103: Call_StorageBucketAccessControlsList_594090;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_594103.validator(path, query, header, formData, body)
  let scheme = call_594103.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594103.url(scheme.get, call_594103.host, call_594103.base,
                         call_594103.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594103, url, valid)

proc call*(call_594104: Call_StorageBucketAccessControlsList_594090;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594105 = newJObject()
  var query_594106 = newJObject()
  add(path_594105, "bucket", newJString(bucket))
  add(query_594106, "fields", newJString(fields))
  add(query_594106, "quotaUser", newJString(quotaUser))
  add(query_594106, "alt", newJString(alt))
  add(query_594106, "oauth_token", newJString(oauthToken))
  add(query_594106, "userIp", newJString(userIp))
  add(query_594106, "userProject", newJString(userProject))
  add(query_594106, "key", newJString(key))
  add(query_594106, "prettyPrint", newJBool(prettyPrint))
  add(query_594106, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594104.call(path_594105, query_594106, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_594090(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_594091,
    base: "/storage/v1", url: url_StorageBucketAccessControlsList_594092,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_594144 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsUpdate_594146(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsUpdate_594145(path: JsonNode;
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
  var valid_594147 = path.getOrDefault("bucket")
  valid_594147 = validateParameter(valid_594147, JString, required = true,
                                 default = nil)
  if valid_594147 != nil:
    section.add "bucket", valid_594147
  var valid_594148 = path.getOrDefault("entity")
  valid_594148 = validateParameter(valid_594148, JString, required = true,
                                 default = nil)
  if valid_594148 != nil:
    section.add "entity", valid_594148
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594149 = query.getOrDefault("fields")
  valid_594149 = validateParameter(valid_594149, JString, required = false,
                                 default = nil)
  if valid_594149 != nil:
    section.add "fields", valid_594149
  var valid_594150 = query.getOrDefault("quotaUser")
  valid_594150 = validateParameter(valid_594150, JString, required = false,
                                 default = nil)
  if valid_594150 != nil:
    section.add "quotaUser", valid_594150
  var valid_594151 = query.getOrDefault("alt")
  valid_594151 = validateParameter(valid_594151, JString, required = false,
                                 default = newJString("json"))
  if valid_594151 != nil:
    section.add "alt", valid_594151
  var valid_594152 = query.getOrDefault("oauth_token")
  valid_594152 = validateParameter(valid_594152, JString, required = false,
                                 default = nil)
  if valid_594152 != nil:
    section.add "oauth_token", valid_594152
  var valid_594153 = query.getOrDefault("userIp")
  valid_594153 = validateParameter(valid_594153, JString, required = false,
                                 default = nil)
  if valid_594153 != nil:
    section.add "userIp", valid_594153
  var valid_594154 = query.getOrDefault("userProject")
  valid_594154 = validateParameter(valid_594154, JString, required = false,
                                 default = nil)
  if valid_594154 != nil:
    section.add "userProject", valid_594154
  var valid_594155 = query.getOrDefault("key")
  valid_594155 = validateParameter(valid_594155, JString, required = false,
                                 default = nil)
  if valid_594155 != nil:
    section.add "key", valid_594155
  var valid_594156 = query.getOrDefault("prettyPrint")
  valid_594156 = validateParameter(valid_594156, JBool, required = false,
                                 default = newJBool(true))
  if valid_594156 != nil:
    section.add "prettyPrint", valid_594156
  var valid_594157 = query.getOrDefault("provisionalUserProject")
  valid_594157 = validateParameter(valid_594157, JString, required = false,
                                 default = nil)
  if valid_594157 != nil:
    section.add "provisionalUserProject", valid_594157
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

proc call*(call_594159: Call_StorageBucketAccessControlsUpdate_594144;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_594159.validator(path, query, header, formData, body)
  let scheme = call_594159.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594159.url(scheme.get, call_594159.host, call_594159.base,
                         call_594159.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594159, url, valid)

proc call*(call_594160: Call_StorageBucketAccessControlsUpdate_594144;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594161 = newJObject()
  var query_594162 = newJObject()
  var body_594163 = newJObject()
  add(path_594161, "bucket", newJString(bucket))
  add(query_594162, "fields", newJString(fields))
  add(query_594162, "quotaUser", newJString(quotaUser))
  add(query_594162, "alt", newJString(alt))
  add(query_594162, "oauth_token", newJString(oauthToken))
  add(query_594162, "userIp", newJString(userIp))
  add(query_594162, "userProject", newJString(userProject))
  add(query_594162, "key", newJString(key))
  if body != nil:
    body_594163 = body
  add(query_594162, "prettyPrint", newJBool(prettyPrint))
  add(path_594161, "entity", newJString(entity))
  add(query_594162, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594160.call(path_594161, query_594162, nil, nil, body_594163)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_594144(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_594145,
    base: "/storage/v1", url: url_StorageBucketAccessControlsUpdate_594146,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_594126 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsGet_594128(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsGet_594127(path: JsonNode;
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
  var valid_594129 = path.getOrDefault("bucket")
  valid_594129 = validateParameter(valid_594129, JString, required = true,
                                 default = nil)
  if valid_594129 != nil:
    section.add "bucket", valid_594129
  var valid_594130 = path.getOrDefault("entity")
  valid_594130 = validateParameter(valid_594130, JString, required = true,
                                 default = nil)
  if valid_594130 != nil:
    section.add "entity", valid_594130
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594131 = query.getOrDefault("fields")
  valid_594131 = validateParameter(valid_594131, JString, required = false,
                                 default = nil)
  if valid_594131 != nil:
    section.add "fields", valid_594131
  var valid_594132 = query.getOrDefault("quotaUser")
  valid_594132 = validateParameter(valid_594132, JString, required = false,
                                 default = nil)
  if valid_594132 != nil:
    section.add "quotaUser", valid_594132
  var valid_594133 = query.getOrDefault("alt")
  valid_594133 = validateParameter(valid_594133, JString, required = false,
                                 default = newJString("json"))
  if valid_594133 != nil:
    section.add "alt", valid_594133
  var valid_594134 = query.getOrDefault("oauth_token")
  valid_594134 = validateParameter(valid_594134, JString, required = false,
                                 default = nil)
  if valid_594134 != nil:
    section.add "oauth_token", valid_594134
  var valid_594135 = query.getOrDefault("userIp")
  valid_594135 = validateParameter(valid_594135, JString, required = false,
                                 default = nil)
  if valid_594135 != nil:
    section.add "userIp", valid_594135
  var valid_594136 = query.getOrDefault("userProject")
  valid_594136 = validateParameter(valid_594136, JString, required = false,
                                 default = nil)
  if valid_594136 != nil:
    section.add "userProject", valid_594136
  var valid_594137 = query.getOrDefault("key")
  valid_594137 = validateParameter(valid_594137, JString, required = false,
                                 default = nil)
  if valid_594137 != nil:
    section.add "key", valid_594137
  var valid_594138 = query.getOrDefault("prettyPrint")
  valid_594138 = validateParameter(valid_594138, JBool, required = false,
                                 default = newJBool(true))
  if valid_594138 != nil:
    section.add "prettyPrint", valid_594138
  var valid_594139 = query.getOrDefault("provisionalUserProject")
  valid_594139 = validateParameter(valid_594139, JString, required = false,
                                 default = nil)
  if valid_594139 != nil:
    section.add "provisionalUserProject", valid_594139
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594140: Call_StorageBucketAccessControlsGet_594126; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594140.validator(path, query, header, formData, body)
  let scheme = call_594140.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594140.url(scheme.get, call_594140.host, call_594140.base,
                         call_594140.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594140, url, valid)

proc call*(call_594141: Call_StorageBucketAccessControlsGet_594126; bucket: string;
          entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594142 = newJObject()
  var query_594143 = newJObject()
  add(path_594142, "bucket", newJString(bucket))
  add(query_594143, "fields", newJString(fields))
  add(query_594143, "quotaUser", newJString(quotaUser))
  add(query_594143, "alt", newJString(alt))
  add(query_594143, "oauth_token", newJString(oauthToken))
  add(query_594143, "userIp", newJString(userIp))
  add(query_594143, "userProject", newJString(userProject))
  add(query_594143, "key", newJString(key))
  add(query_594143, "prettyPrint", newJBool(prettyPrint))
  add(path_594142, "entity", newJString(entity))
  add(query_594143, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594141.call(path_594142, query_594143, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_594126(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_594127,
    base: "/storage/v1", url: url_StorageBucketAccessControlsGet_594128,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_594182 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsPatch_594184(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsPatch_594183(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified bucket.
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
  var valid_594185 = path.getOrDefault("bucket")
  valid_594185 = validateParameter(valid_594185, JString, required = true,
                                 default = nil)
  if valid_594185 != nil:
    section.add "bucket", valid_594185
  var valid_594186 = path.getOrDefault("entity")
  valid_594186 = validateParameter(valid_594186, JString, required = true,
                                 default = nil)
  if valid_594186 != nil:
    section.add "entity", valid_594186
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594187 = query.getOrDefault("fields")
  valid_594187 = validateParameter(valid_594187, JString, required = false,
                                 default = nil)
  if valid_594187 != nil:
    section.add "fields", valid_594187
  var valid_594188 = query.getOrDefault("quotaUser")
  valid_594188 = validateParameter(valid_594188, JString, required = false,
                                 default = nil)
  if valid_594188 != nil:
    section.add "quotaUser", valid_594188
  var valid_594189 = query.getOrDefault("alt")
  valid_594189 = validateParameter(valid_594189, JString, required = false,
                                 default = newJString("json"))
  if valid_594189 != nil:
    section.add "alt", valid_594189
  var valid_594190 = query.getOrDefault("oauth_token")
  valid_594190 = validateParameter(valid_594190, JString, required = false,
                                 default = nil)
  if valid_594190 != nil:
    section.add "oauth_token", valid_594190
  var valid_594191 = query.getOrDefault("userIp")
  valid_594191 = validateParameter(valid_594191, JString, required = false,
                                 default = nil)
  if valid_594191 != nil:
    section.add "userIp", valid_594191
  var valid_594192 = query.getOrDefault("userProject")
  valid_594192 = validateParameter(valid_594192, JString, required = false,
                                 default = nil)
  if valid_594192 != nil:
    section.add "userProject", valid_594192
  var valid_594193 = query.getOrDefault("key")
  valid_594193 = validateParameter(valid_594193, JString, required = false,
                                 default = nil)
  if valid_594193 != nil:
    section.add "key", valid_594193
  var valid_594194 = query.getOrDefault("prettyPrint")
  valid_594194 = validateParameter(valid_594194, JBool, required = false,
                                 default = newJBool(true))
  if valid_594194 != nil:
    section.add "prettyPrint", valid_594194
  var valid_594195 = query.getOrDefault("provisionalUserProject")
  valid_594195 = validateParameter(valid_594195, JString, required = false,
                                 default = nil)
  if valid_594195 != nil:
    section.add "provisionalUserProject", valid_594195
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

proc call*(call_594197: Call_StorageBucketAccessControlsPatch_594182;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified bucket.
  ## 
  let valid = call_594197.validator(path, query, header, formData, body)
  let scheme = call_594197.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594197.url(scheme.get, call_594197.host, call_594197.base,
                         call_594197.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594197, url, valid)

proc call*(call_594198: Call_StorageBucketAccessControlsPatch_594182;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketAccessControlsPatch
  ## Patches an ACL entry on the specified bucket.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594199 = newJObject()
  var query_594200 = newJObject()
  var body_594201 = newJObject()
  add(path_594199, "bucket", newJString(bucket))
  add(query_594200, "fields", newJString(fields))
  add(query_594200, "quotaUser", newJString(quotaUser))
  add(query_594200, "alt", newJString(alt))
  add(query_594200, "oauth_token", newJString(oauthToken))
  add(query_594200, "userIp", newJString(userIp))
  add(query_594200, "userProject", newJString(userProject))
  add(query_594200, "key", newJString(key))
  if body != nil:
    body_594201 = body
  add(query_594200, "prettyPrint", newJBool(prettyPrint))
  add(path_594199, "entity", newJString(entity))
  add(query_594200, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594198.call(path_594199, query_594200, nil, nil, body_594201)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_594182(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_594183,
    base: "/storage/v1", url: url_StorageBucketAccessControlsPatch_594184,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_594164 = ref object of OpenApiRestCall_593424
proc url_StorageBucketAccessControlsDelete_594166(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsDelete_594165(path: JsonNode;
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
  var valid_594167 = path.getOrDefault("bucket")
  valid_594167 = validateParameter(valid_594167, JString, required = true,
                                 default = nil)
  if valid_594167 != nil:
    section.add "bucket", valid_594167
  var valid_594168 = path.getOrDefault("entity")
  valid_594168 = validateParameter(valid_594168, JString, required = true,
                                 default = nil)
  if valid_594168 != nil:
    section.add "entity", valid_594168
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594169 = query.getOrDefault("fields")
  valid_594169 = validateParameter(valid_594169, JString, required = false,
                                 default = nil)
  if valid_594169 != nil:
    section.add "fields", valid_594169
  var valid_594170 = query.getOrDefault("quotaUser")
  valid_594170 = validateParameter(valid_594170, JString, required = false,
                                 default = nil)
  if valid_594170 != nil:
    section.add "quotaUser", valid_594170
  var valid_594171 = query.getOrDefault("alt")
  valid_594171 = validateParameter(valid_594171, JString, required = false,
                                 default = newJString("json"))
  if valid_594171 != nil:
    section.add "alt", valid_594171
  var valid_594172 = query.getOrDefault("oauth_token")
  valid_594172 = validateParameter(valid_594172, JString, required = false,
                                 default = nil)
  if valid_594172 != nil:
    section.add "oauth_token", valid_594172
  var valid_594173 = query.getOrDefault("userIp")
  valid_594173 = validateParameter(valid_594173, JString, required = false,
                                 default = nil)
  if valid_594173 != nil:
    section.add "userIp", valid_594173
  var valid_594174 = query.getOrDefault("userProject")
  valid_594174 = validateParameter(valid_594174, JString, required = false,
                                 default = nil)
  if valid_594174 != nil:
    section.add "userProject", valid_594174
  var valid_594175 = query.getOrDefault("key")
  valid_594175 = validateParameter(valid_594175, JString, required = false,
                                 default = nil)
  if valid_594175 != nil:
    section.add "key", valid_594175
  var valid_594176 = query.getOrDefault("prettyPrint")
  valid_594176 = validateParameter(valid_594176, JBool, required = false,
                                 default = newJBool(true))
  if valid_594176 != nil:
    section.add "prettyPrint", valid_594176
  var valid_594177 = query.getOrDefault("provisionalUserProject")
  valid_594177 = validateParameter(valid_594177, JString, required = false,
                                 default = nil)
  if valid_594177 != nil:
    section.add "provisionalUserProject", valid_594177
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594178: Call_StorageBucketAccessControlsDelete_594164;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594178.validator(path, query, header, formData, body)
  let scheme = call_594178.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594178.url(scheme.get, call_594178.host, call_594178.base,
                         call_594178.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594178, url, valid)

proc call*(call_594179: Call_StorageBucketAccessControlsDelete_594164;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594180 = newJObject()
  var query_594181 = newJObject()
  add(path_594180, "bucket", newJString(bucket))
  add(query_594181, "fields", newJString(fields))
  add(query_594181, "quotaUser", newJString(quotaUser))
  add(query_594181, "alt", newJString(alt))
  add(query_594181, "oauth_token", newJString(oauthToken))
  add(query_594181, "userIp", newJString(userIp))
  add(query_594181, "userProject", newJString(userProject))
  add(query_594181, "key", newJString(key))
  add(query_594181, "prettyPrint", newJBool(prettyPrint))
  add(path_594180, "entity", newJString(entity))
  add(query_594181, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594179.call(path_594180, query_594181, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_594164(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_594165,
    base: "/storage/v1", url: url_StorageBucketAccessControlsDelete_594166,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_594221 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsInsert_594223(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsInsert_594222(path: JsonNode;
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
  var valid_594224 = path.getOrDefault("bucket")
  valid_594224 = validateParameter(valid_594224, JString, required = true,
                                 default = nil)
  if valid_594224 != nil:
    section.add "bucket", valid_594224
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
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
  var valid_594230 = query.getOrDefault("userProject")
  valid_594230 = validateParameter(valid_594230, JString, required = false,
                                 default = nil)
  if valid_594230 != nil:
    section.add "userProject", valid_594230
  var valid_594231 = query.getOrDefault("key")
  valid_594231 = validateParameter(valid_594231, JString, required = false,
                                 default = nil)
  if valid_594231 != nil:
    section.add "key", valid_594231
  var valid_594232 = query.getOrDefault("prettyPrint")
  valid_594232 = validateParameter(valid_594232, JBool, required = false,
                                 default = newJBool(true))
  if valid_594232 != nil:
    section.add "prettyPrint", valid_594232
  var valid_594233 = query.getOrDefault("provisionalUserProject")
  valid_594233 = validateParameter(valid_594233, JString, required = false,
                                 default = nil)
  if valid_594233 != nil:
    section.add "provisionalUserProject", valid_594233
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

proc call*(call_594235: Call_StorageDefaultObjectAccessControlsInsert_594221;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_594235.validator(path, query, header, formData, body)
  let scheme = call_594235.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594235.url(scheme.get, call_594235.host, call_594235.base,
                         call_594235.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594235, url, valid)

proc call*(call_594236: Call_StorageDefaultObjectAccessControlsInsert_594221;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594237 = newJObject()
  var query_594238 = newJObject()
  var body_594239 = newJObject()
  add(path_594237, "bucket", newJString(bucket))
  add(query_594238, "fields", newJString(fields))
  add(query_594238, "quotaUser", newJString(quotaUser))
  add(query_594238, "alt", newJString(alt))
  add(query_594238, "oauth_token", newJString(oauthToken))
  add(query_594238, "userIp", newJString(userIp))
  add(query_594238, "userProject", newJString(userProject))
  add(query_594238, "key", newJString(key))
  if body != nil:
    body_594239 = body
  add(query_594238, "prettyPrint", newJBool(prettyPrint))
  add(query_594238, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594236.call(path_594237, query_594238, nil, nil, body_594239)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_594221(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_594222,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsInsert_594223,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_594202 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsList_594204(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsList_594203(path: JsonNode;
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
  var valid_594205 = path.getOrDefault("bucket")
  valid_594205 = validateParameter(valid_594205, JString, required = true,
                                 default = nil)
  if valid_594205 != nil:
    section.add "bucket", valid_594205
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594206 = query.getOrDefault("fields")
  valid_594206 = validateParameter(valid_594206, JString, required = false,
                                 default = nil)
  if valid_594206 != nil:
    section.add "fields", valid_594206
  var valid_594207 = query.getOrDefault("quotaUser")
  valid_594207 = validateParameter(valid_594207, JString, required = false,
                                 default = nil)
  if valid_594207 != nil:
    section.add "quotaUser", valid_594207
  var valid_594208 = query.getOrDefault("alt")
  valid_594208 = validateParameter(valid_594208, JString, required = false,
                                 default = newJString("json"))
  if valid_594208 != nil:
    section.add "alt", valid_594208
  var valid_594209 = query.getOrDefault("oauth_token")
  valid_594209 = validateParameter(valid_594209, JString, required = false,
                                 default = nil)
  if valid_594209 != nil:
    section.add "oauth_token", valid_594209
  var valid_594210 = query.getOrDefault("userIp")
  valid_594210 = validateParameter(valid_594210, JString, required = false,
                                 default = nil)
  if valid_594210 != nil:
    section.add "userIp", valid_594210
  var valid_594211 = query.getOrDefault("userProject")
  valid_594211 = validateParameter(valid_594211, JString, required = false,
                                 default = nil)
  if valid_594211 != nil:
    section.add "userProject", valid_594211
  var valid_594212 = query.getOrDefault("key")
  valid_594212 = validateParameter(valid_594212, JString, required = false,
                                 default = nil)
  if valid_594212 != nil:
    section.add "key", valid_594212
  var valid_594213 = query.getOrDefault("ifMetagenerationMatch")
  valid_594213 = validateParameter(valid_594213, JString, required = false,
                                 default = nil)
  if valid_594213 != nil:
    section.add "ifMetagenerationMatch", valid_594213
  var valid_594214 = query.getOrDefault("prettyPrint")
  valid_594214 = validateParameter(valid_594214, JBool, required = false,
                                 default = newJBool(true))
  if valid_594214 != nil:
    section.add "prettyPrint", valid_594214
  var valid_594215 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594215 = validateParameter(valid_594215, JString, required = false,
                                 default = nil)
  if valid_594215 != nil:
    section.add "ifMetagenerationNotMatch", valid_594215
  var valid_594216 = query.getOrDefault("provisionalUserProject")
  valid_594216 = validateParameter(valid_594216, JString, required = false,
                                 default = nil)
  if valid_594216 != nil:
    section.add "provisionalUserProject", valid_594216
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594217: Call_StorageDefaultObjectAccessControlsList_594202;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_594217.validator(path, query, header, formData, body)
  let scheme = call_594217.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594217.url(scheme.get, call_594217.host, call_594217.base,
                         call_594217.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594217, url, valid)

proc call*(call_594218: Call_StorageDefaultObjectAccessControlsList_594202;
          bucket: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = "";
          ifMetagenerationMatch: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string
  ##                        : If present, only return default ACL listing if the bucket's current metageneration matches this value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : If present, only return default ACL listing if the bucket's current metageneration does not match the given value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594219 = newJObject()
  var query_594220 = newJObject()
  add(path_594219, "bucket", newJString(bucket))
  add(query_594220, "fields", newJString(fields))
  add(query_594220, "quotaUser", newJString(quotaUser))
  add(query_594220, "alt", newJString(alt))
  add(query_594220, "oauth_token", newJString(oauthToken))
  add(query_594220, "userIp", newJString(userIp))
  add(query_594220, "userProject", newJString(userProject))
  add(query_594220, "key", newJString(key))
  add(query_594220, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594220, "prettyPrint", newJBool(prettyPrint))
  add(query_594220, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594220, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594218.call(path_594219, query_594220, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_594202(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_594203,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsList_594204,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_594258 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsUpdate_594260(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsUpdate_594259(path: JsonNode;
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
  var valid_594261 = path.getOrDefault("bucket")
  valid_594261 = validateParameter(valid_594261, JString, required = true,
                                 default = nil)
  if valid_594261 != nil:
    section.add "bucket", valid_594261
  var valid_594262 = path.getOrDefault("entity")
  valid_594262 = validateParameter(valid_594262, JString, required = true,
                                 default = nil)
  if valid_594262 != nil:
    section.add "entity", valid_594262
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594263 = query.getOrDefault("fields")
  valid_594263 = validateParameter(valid_594263, JString, required = false,
                                 default = nil)
  if valid_594263 != nil:
    section.add "fields", valid_594263
  var valid_594264 = query.getOrDefault("quotaUser")
  valid_594264 = validateParameter(valid_594264, JString, required = false,
                                 default = nil)
  if valid_594264 != nil:
    section.add "quotaUser", valid_594264
  var valid_594265 = query.getOrDefault("alt")
  valid_594265 = validateParameter(valid_594265, JString, required = false,
                                 default = newJString("json"))
  if valid_594265 != nil:
    section.add "alt", valid_594265
  var valid_594266 = query.getOrDefault("oauth_token")
  valid_594266 = validateParameter(valid_594266, JString, required = false,
                                 default = nil)
  if valid_594266 != nil:
    section.add "oauth_token", valid_594266
  var valid_594267 = query.getOrDefault("userIp")
  valid_594267 = validateParameter(valid_594267, JString, required = false,
                                 default = nil)
  if valid_594267 != nil:
    section.add "userIp", valid_594267
  var valid_594268 = query.getOrDefault("userProject")
  valid_594268 = validateParameter(valid_594268, JString, required = false,
                                 default = nil)
  if valid_594268 != nil:
    section.add "userProject", valid_594268
  var valid_594269 = query.getOrDefault("key")
  valid_594269 = validateParameter(valid_594269, JString, required = false,
                                 default = nil)
  if valid_594269 != nil:
    section.add "key", valid_594269
  var valid_594270 = query.getOrDefault("prettyPrint")
  valid_594270 = validateParameter(valid_594270, JBool, required = false,
                                 default = newJBool(true))
  if valid_594270 != nil:
    section.add "prettyPrint", valid_594270
  var valid_594271 = query.getOrDefault("provisionalUserProject")
  valid_594271 = validateParameter(valid_594271, JString, required = false,
                                 default = nil)
  if valid_594271 != nil:
    section.add "provisionalUserProject", valid_594271
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

proc call*(call_594273: Call_StorageDefaultObjectAccessControlsUpdate_594258;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_594273.validator(path, query, header, formData, body)
  let scheme = call_594273.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594273.url(scheme.get, call_594273.host, call_594273.base,
                         call_594273.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594273, url, valid)

proc call*(call_594274: Call_StorageDefaultObjectAccessControlsUpdate_594258;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594275 = newJObject()
  var query_594276 = newJObject()
  var body_594277 = newJObject()
  add(path_594275, "bucket", newJString(bucket))
  add(query_594276, "fields", newJString(fields))
  add(query_594276, "quotaUser", newJString(quotaUser))
  add(query_594276, "alt", newJString(alt))
  add(query_594276, "oauth_token", newJString(oauthToken))
  add(query_594276, "userIp", newJString(userIp))
  add(query_594276, "userProject", newJString(userProject))
  add(query_594276, "key", newJString(key))
  if body != nil:
    body_594277 = body
  add(query_594276, "prettyPrint", newJBool(prettyPrint))
  add(path_594275, "entity", newJString(entity))
  add(query_594276, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594274.call(path_594275, query_594276, nil, nil, body_594277)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_594258(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_594259,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsUpdate_594260,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_594240 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsGet_594242(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsGet_594241(path: JsonNode;
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
  var valid_594243 = path.getOrDefault("bucket")
  valid_594243 = validateParameter(valid_594243, JString, required = true,
                                 default = nil)
  if valid_594243 != nil:
    section.add "bucket", valid_594243
  var valid_594244 = path.getOrDefault("entity")
  valid_594244 = validateParameter(valid_594244, JString, required = true,
                                 default = nil)
  if valid_594244 != nil:
    section.add "entity", valid_594244
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594245 = query.getOrDefault("fields")
  valid_594245 = validateParameter(valid_594245, JString, required = false,
                                 default = nil)
  if valid_594245 != nil:
    section.add "fields", valid_594245
  var valid_594246 = query.getOrDefault("quotaUser")
  valid_594246 = validateParameter(valid_594246, JString, required = false,
                                 default = nil)
  if valid_594246 != nil:
    section.add "quotaUser", valid_594246
  var valid_594247 = query.getOrDefault("alt")
  valid_594247 = validateParameter(valid_594247, JString, required = false,
                                 default = newJString("json"))
  if valid_594247 != nil:
    section.add "alt", valid_594247
  var valid_594248 = query.getOrDefault("oauth_token")
  valid_594248 = validateParameter(valid_594248, JString, required = false,
                                 default = nil)
  if valid_594248 != nil:
    section.add "oauth_token", valid_594248
  var valid_594249 = query.getOrDefault("userIp")
  valid_594249 = validateParameter(valid_594249, JString, required = false,
                                 default = nil)
  if valid_594249 != nil:
    section.add "userIp", valid_594249
  var valid_594250 = query.getOrDefault("userProject")
  valid_594250 = validateParameter(valid_594250, JString, required = false,
                                 default = nil)
  if valid_594250 != nil:
    section.add "userProject", valid_594250
  var valid_594251 = query.getOrDefault("key")
  valid_594251 = validateParameter(valid_594251, JString, required = false,
                                 default = nil)
  if valid_594251 != nil:
    section.add "key", valid_594251
  var valid_594252 = query.getOrDefault("prettyPrint")
  valid_594252 = validateParameter(valid_594252, JBool, required = false,
                                 default = newJBool(true))
  if valid_594252 != nil:
    section.add "prettyPrint", valid_594252
  var valid_594253 = query.getOrDefault("provisionalUserProject")
  valid_594253 = validateParameter(valid_594253, JString, required = false,
                                 default = nil)
  if valid_594253 != nil:
    section.add "provisionalUserProject", valid_594253
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594254: Call_StorageDefaultObjectAccessControlsGet_594240;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594254.validator(path, query, header, formData, body)
  let scheme = call_594254.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594254.url(scheme.get, call_594254.host, call_594254.base,
                         call_594254.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594254, url, valid)

proc call*(call_594255: Call_StorageDefaultObjectAccessControlsGet_594240;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594256 = newJObject()
  var query_594257 = newJObject()
  add(path_594256, "bucket", newJString(bucket))
  add(query_594257, "fields", newJString(fields))
  add(query_594257, "quotaUser", newJString(quotaUser))
  add(query_594257, "alt", newJString(alt))
  add(query_594257, "oauth_token", newJString(oauthToken))
  add(query_594257, "userIp", newJString(userIp))
  add(query_594257, "userProject", newJString(userProject))
  add(query_594257, "key", newJString(key))
  add(query_594257, "prettyPrint", newJBool(prettyPrint))
  add(path_594256, "entity", newJString(entity))
  add(query_594257, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594255.call(path_594256, query_594257, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_594240(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_594241,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsGet_594242,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_594296 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsPatch_594298(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsPatch_594297(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches a default object ACL entry on the specified bucket.
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
  var valid_594299 = path.getOrDefault("bucket")
  valid_594299 = validateParameter(valid_594299, JString, required = true,
                                 default = nil)
  if valid_594299 != nil:
    section.add "bucket", valid_594299
  var valid_594300 = path.getOrDefault("entity")
  valid_594300 = validateParameter(valid_594300, JString, required = true,
                                 default = nil)
  if valid_594300 != nil:
    section.add "entity", valid_594300
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594301 = query.getOrDefault("fields")
  valid_594301 = validateParameter(valid_594301, JString, required = false,
                                 default = nil)
  if valid_594301 != nil:
    section.add "fields", valid_594301
  var valid_594302 = query.getOrDefault("quotaUser")
  valid_594302 = validateParameter(valid_594302, JString, required = false,
                                 default = nil)
  if valid_594302 != nil:
    section.add "quotaUser", valid_594302
  var valid_594303 = query.getOrDefault("alt")
  valid_594303 = validateParameter(valid_594303, JString, required = false,
                                 default = newJString("json"))
  if valid_594303 != nil:
    section.add "alt", valid_594303
  var valid_594304 = query.getOrDefault("oauth_token")
  valid_594304 = validateParameter(valid_594304, JString, required = false,
                                 default = nil)
  if valid_594304 != nil:
    section.add "oauth_token", valid_594304
  var valid_594305 = query.getOrDefault("userIp")
  valid_594305 = validateParameter(valid_594305, JString, required = false,
                                 default = nil)
  if valid_594305 != nil:
    section.add "userIp", valid_594305
  var valid_594306 = query.getOrDefault("userProject")
  valid_594306 = validateParameter(valid_594306, JString, required = false,
                                 default = nil)
  if valid_594306 != nil:
    section.add "userProject", valid_594306
  var valid_594307 = query.getOrDefault("key")
  valid_594307 = validateParameter(valid_594307, JString, required = false,
                                 default = nil)
  if valid_594307 != nil:
    section.add "key", valid_594307
  var valid_594308 = query.getOrDefault("prettyPrint")
  valid_594308 = validateParameter(valid_594308, JBool, required = false,
                                 default = newJBool(true))
  if valid_594308 != nil:
    section.add "prettyPrint", valid_594308
  var valid_594309 = query.getOrDefault("provisionalUserProject")
  valid_594309 = validateParameter(valid_594309, JString, required = false,
                                 default = nil)
  if valid_594309 != nil:
    section.add "provisionalUserProject", valid_594309
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

proc call*(call_594311: Call_StorageDefaultObjectAccessControlsPatch_594296;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches a default object ACL entry on the specified bucket.
  ## 
  let valid = call_594311.validator(path, query, header, formData, body)
  let scheme = call_594311.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594311.url(scheme.get, call_594311.host, call_594311.base,
                         call_594311.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594311, url, valid)

proc call*(call_594312: Call_StorageDefaultObjectAccessControlsPatch_594296;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageDefaultObjectAccessControlsPatch
  ## Patches a default object ACL entry on the specified bucket.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594313 = newJObject()
  var query_594314 = newJObject()
  var body_594315 = newJObject()
  add(path_594313, "bucket", newJString(bucket))
  add(query_594314, "fields", newJString(fields))
  add(query_594314, "quotaUser", newJString(quotaUser))
  add(query_594314, "alt", newJString(alt))
  add(query_594314, "oauth_token", newJString(oauthToken))
  add(query_594314, "userIp", newJString(userIp))
  add(query_594314, "userProject", newJString(userProject))
  add(query_594314, "key", newJString(key))
  if body != nil:
    body_594315 = body
  add(query_594314, "prettyPrint", newJBool(prettyPrint))
  add(path_594313, "entity", newJString(entity))
  add(query_594314, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594312.call(path_594313, query_594314, nil, nil, body_594315)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_594296(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_594297,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsPatch_594298,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_594278 = ref object of OpenApiRestCall_593424
proc url_StorageDefaultObjectAccessControlsDelete_594280(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsDelete_594279(path: JsonNode;
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
  var valid_594281 = path.getOrDefault("bucket")
  valid_594281 = validateParameter(valid_594281, JString, required = true,
                                 default = nil)
  if valid_594281 != nil:
    section.add "bucket", valid_594281
  var valid_594282 = path.getOrDefault("entity")
  valid_594282 = validateParameter(valid_594282, JString, required = true,
                                 default = nil)
  if valid_594282 != nil:
    section.add "entity", valid_594282
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594283 = query.getOrDefault("fields")
  valid_594283 = validateParameter(valid_594283, JString, required = false,
                                 default = nil)
  if valid_594283 != nil:
    section.add "fields", valid_594283
  var valid_594284 = query.getOrDefault("quotaUser")
  valid_594284 = validateParameter(valid_594284, JString, required = false,
                                 default = nil)
  if valid_594284 != nil:
    section.add "quotaUser", valid_594284
  var valid_594285 = query.getOrDefault("alt")
  valid_594285 = validateParameter(valid_594285, JString, required = false,
                                 default = newJString("json"))
  if valid_594285 != nil:
    section.add "alt", valid_594285
  var valid_594286 = query.getOrDefault("oauth_token")
  valid_594286 = validateParameter(valid_594286, JString, required = false,
                                 default = nil)
  if valid_594286 != nil:
    section.add "oauth_token", valid_594286
  var valid_594287 = query.getOrDefault("userIp")
  valid_594287 = validateParameter(valid_594287, JString, required = false,
                                 default = nil)
  if valid_594287 != nil:
    section.add "userIp", valid_594287
  var valid_594288 = query.getOrDefault("userProject")
  valid_594288 = validateParameter(valid_594288, JString, required = false,
                                 default = nil)
  if valid_594288 != nil:
    section.add "userProject", valid_594288
  var valid_594289 = query.getOrDefault("key")
  valid_594289 = validateParameter(valid_594289, JString, required = false,
                                 default = nil)
  if valid_594289 != nil:
    section.add "key", valid_594289
  var valid_594290 = query.getOrDefault("prettyPrint")
  valid_594290 = validateParameter(valid_594290, JBool, required = false,
                                 default = newJBool(true))
  if valid_594290 != nil:
    section.add "prettyPrint", valid_594290
  var valid_594291 = query.getOrDefault("provisionalUserProject")
  valid_594291 = validateParameter(valid_594291, JString, required = false,
                                 default = nil)
  if valid_594291 != nil:
    section.add "provisionalUserProject", valid_594291
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594292: Call_StorageDefaultObjectAccessControlsDelete_594278;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_594292.validator(path, query, header, formData, body)
  let scheme = call_594292.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594292.url(scheme.get, call_594292.host, call_594292.base,
                         call_594292.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594292, url, valid)

proc call*(call_594293: Call_StorageDefaultObjectAccessControlsDelete_594278;
          bucket: string; entity: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594294 = newJObject()
  var query_594295 = newJObject()
  add(path_594294, "bucket", newJString(bucket))
  add(query_594295, "fields", newJString(fields))
  add(query_594295, "quotaUser", newJString(quotaUser))
  add(query_594295, "alt", newJString(alt))
  add(query_594295, "oauth_token", newJString(oauthToken))
  add(query_594295, "userIp", newJString(userIp))
  add(query_594295, "userProject", newJString(userProject))
  add(query_594295, "key", newJString(key))
  add(query_594295, "prettyPrint", newJBool(prettyPrint))
  add(path_594294, "entity", newJString(entity))
  add(query_594295, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594293.call(path_594294, query_594295, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_594278(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_594279,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsDelete_594280,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsSetIamPolicy_594334 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsSetIamPolicy_594336(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsSetIamPolicy_594335(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594337 = path.getOrDefault("bucket")
  valid_594337 = validateParameter(valid_594337, JString, required = true,
                                 default = nil)
  if valid_594337 != nil:
    section.add "bucket", valid_594337
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594338 = query.getOrDefault("fields")
  valid_594338 = validateParameter(valid_594338, JString, required = false,
                                 default = nil)
  if valid_594338 != nil:
    section.add "fields", valid_594338
  var valid_594339 = query.getOrDefault("quotaUser")
  valid_594339 = validateParameter(valid_594339, JString, required = false,
                                 default = nil)
  if valid_594339 != nil:
    section.add "quotaUser", valid_594339
  var valid_594340 = query.getOrDefault("alt")
  valid_594340 = validateParameter(valid_594340, JString, required = false,
                                 default = newJString("json"))
  if valid_594340 != nil:
    section.add "alt", valid_594340
  var valid_594341 = query.getOrDefault("oauth_token")
  valid_594341 = validateParameter(valid_594341, JString, required = false,
                                 default = nil)
  if valid_594341 != nil:
    section.add "oauth_token", valid_594341
  var valid_594342 = query.getOrDefault("userIp")
  valid_594342 = validateParameter(valid_594342, JString, required = false,
                                 default = nil)
  if valid_594342 != nil:
    section.add "userIp", valid_594342
  var valid_594343 = query.getOrDefault("userProject")
  valid_594343 = validateParameter(valid_594343, JString, required = false,
                                 default = nil)
  if valid_594343 != nil:
    section.add "userProject", valid_594343
  var valid_594344 = query.getOrDefault("key")
  valid_594344 = validateParameter(valid_594344, JString, required = false,
                                 default = nil)
  if valid_594344 != nil:
    section.add "key", valid_594344
  var valid_594345 = query.getOrDefault("prettyPrint")
  valid_594345 = validateParameter(valid_594345, JBool, required = false,
                                 default = newJBool(true))
  if valid_594345 != nil:
    section.add "prettyPrint", valid_594345
  var valid_594346 = query.getOrDefault("provisionalUserProject")
  valid_594346 = validateParameter(valid_594346, JString, required = false,
                                 default = nil)
  if valid_594346 != nil:
    section.add "provisionalUserProject", valid_594346
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

proc call*(call_594348: Call_StorageBucketsSetIamPolicy_594334; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified bucket.
  ## 
  let valid = call_594348.validator(path, query, header, formData, body)
  let scheme = call_594348.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594348.url(scheme.get, call_594348.host, call_594348.base,
                         call_594348.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594348, url, valid)

proc call*(call_594349: Call_StorageBucketsSetIamPolicy_594334; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageBucketsSetIamPolicy
  ## Updates an IAM policy for the specified bucket.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594350 = newJObject()
  var query_594351 = newJObject()
  var body_594352 = newJObject()
  add(path_594350, "bucket", newJString(bucket))
  add(query_594351, "fields", newJString(fields))
  add(query_594351, "quotaUser", newJString(quotaUser))
  add(query_594351, "alt", newJString(alt))
  add(query_594351, "oauth_token", newJString(oauthToken))
  add(query_594351, "userIp", newJString(userIp))
  add(query_594351, "userProject", newJString(userProject))
  add(query_594351, "key", newJString(key))
  if body != nil:
    body_594352 = body
  add(query_594351, "prettyPrint", newJBool(prettyPrint))
  add(query_594351, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594349.call(path_594350, query_594351, nil, nil, body_594352)

var storageBucketsSetIamPolicy* = Call_StorageBucketsSetIamPolicy_594334(
    name: "storageBucketsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsSetIamPolicy_594335, base: "/storage/v1",
    url: url_StorageBucketsSetIamPolicy_594336, schemes: {Scheme.Https})
type
  Call_StorageBucketsGetIamPolicy_594316 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsGetIamPolicy_594318(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsGetIamPolicy_594317(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
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
  ##   optionsRequestedPolicyVersion: JInt
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594320 = query.getOrDefault("fields")
  valid_594320 = validateParameter(valid_594320, JString, required = false,
                                 default = nil)
  if valid_594320 != nil:
    section.add "fields", valid_594320
  var valid_594321 = query.getOrDefault("optionsRequestedPolicyVersion")
  valid_594321 = validateParameter(valid_594321, JInt, required = false, default = nil)
  if valid_594321 != nil:
    section.add "optionsRequestedPolicyVersion", valid_594321
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
  var valid_594325 = query.getOrDefault("userIp")
  valid_594325 = validateParameter(valid_594325, JString, required = false,
                                 default = nil)
  if valid_594325 != nil:
    section.add "userIp", valid_594325
  var valid_594326 = query.getOrDefault("userProject")
  valid_594326 = validateParameter(valid_594326, JString, required = false,
                                 default = nil)
  if valid_594326 != nil:
    section.add "userProject", valid_594326
  var valid_594327 = query.getOrDefault("key")
  valid_594327 = validateParameter(valid_594327, JString, required = false,
                                 default = nil)
  if valid_594327 != nil:
    section.add "key", valid_594327
  var valid_594328 = query.getOrDefault("prettyPrint")
  valid_594328 = validateParameter(valid_594328, JBool, required = false,
                                 default = newJBool(true))
  if valid_594328 != nil:
    section.add "prettyPrint", valid_594328
  var valid_594329 = query.getOrDefault("provisionalUserProject")
  valid_594329 = validateParameter(valid_594329, JString, required = false,
                                 default = nil)
  if valid_594329 != nil:
    section.add "provisionalUserProject", valid_594329
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594330: Call_StorageBucketsGetIamPolicy_594316; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified bucket.
  ## 
  let valid = call_594330.validator(path, query, header, formData, body)
  let scheme = call_594330.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594330.url(scheme.get, call_594330.host, call_594330.base,
                         call_594330.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594330, url, valid)

proc call*(call_594331: Call_StorageBucketsGetIamPolicy_594316; bucket: string;
          fields: string = ""; optionsRequestedPolicyVersion: int = 0;
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketsGetIamPolicy
  ## Returns an IAM policy for the specified bucket.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   optionsRequestedPolicyVersion: int
  ##                                : The IAM policy format version to be returned. If the optionsRequestedPolicyVersion is for an older version that doesn't support part of the requested IAM policy, the request fails.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594332 = newJObject()
  var query_594333 = newJObject()
  add(path_594332, "bucket", newJString(bucket))
  add(query_594333, "fields", newJString(fields))
  add(query_594333, "optionsRequestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_594333, "quotaUser", newJString(quotaUser))
  add(query_594333, "alt", newJString(alt))
  add(query_594333, "oauth_token", newJString(oauthToken))
  add(query_594333, "userIp", newJString(userIp))
  add(query_594333, "userProject", newJString(userProject))
  add(query_594333, "key", newJString(key))
  add(query_594333, "prettyPrint", newJBool(prettyPrint))
  add(query_594333, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594331.call(path_594332, query_594333, nil, nil, nil)

var storageBucketsGetIamPolicy* = Call_StorageBucketsGetIamPolicy_594316(
    name: "storageBucketsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsGetIamPolicy_594317, base: "/storage/v1",
    url: url_StorageBucketsGetIamPolicy_594318, schemes: {Scheme.Https})
type
  Call_StorageBucketsTestIamPermissions_594353 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsTestIamPermissions_594355(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsTestIamPermissions_594354(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594356 = path.getOrDefault("bucket")
  valid_594356 = validateParameter(valid_594356, JString, required = true,
                                 default = nil)
  if valid_594356 != nil:
    section.add "bucket", valid_594356
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594357 = query.getOrDefault("fields")
  valid_594357 = validateParameter(valid_594357, JString, required = false,
                                 default = nil)
  if valid_594357 != nil:
    section.add "fields", valid_594357
  var valid_594358 = query.getOrDefault("quotaUser")
  valid_594358 = validateParameter(valid_594358, JString, required = false,
                                 default = nil)
  if valid_594358 != nil:
    section.add "quotaUser", valid_594358
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_594359 = query.getOrDefault("permissions")
  valid_594359 = validateParameter(valid_594359, JArray, required = true, default = nil)
  if valid_594359 != nil:
    section.add "permissions", valid_594359
  var valid_594360 = query.getOrDefault("alt")
  valid_594360 = validateParameter(valid_594360, JString, required = false,
                                 default = newJString("json"))
  if valid_594360 != nil:
    section.add "alt", valid_594360
  var valid_594361 = query.getOrDefault("oauth_token")
  valid_594361 = validateParameter(valid_594361, JString, required = false,
                                 default = nil)
  if valid_594361 != nil:
    section.add "oauth_token", valid_594361
  var valid_594362 = query.getOrDefault("userIp")
  valid_594362 = validateParameter(valid_594362, JString, required = false,
                                 default = nil)
  if valid_594362 != nil:
    section.add "userIp", valid_594362
  var valid_594363 = query.getOrDefault("userProject")
  valid_594363 = validateParameter(valid_594363, JString, required = false,
                                 default = nil)
  if valid_594363 != nil:
    section.add "userProject", valid_594363
  var valid_594364 = query.getOrDefault("key")
  valid_594364 = validateParameter(valid_594364, JString, required = false,
                                 default = nil)
  if valid_594364 != nil:
    section.add "key", valid_594364
  var valid_594365 = query.getOrDefault("prettyPrint")
  valid_594365 = validateParameter(valid_594365, JBool, required = false,
                                 default = newJBool(true))
  if valid_594365 != nil:
    section.add "prettyPrint", valid_594365
  var valid_594366 = query.getOrDefault("provisionalUserProject")
  valid_594366 = validateParameter(valid_594366, JString, required = false,
                                 default = nil)
  if valid_594366 != nil:
    section.add "provisionalUserProject", valid_594366
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594367: Call_StorageBucketsTestIamPermissions_594353;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  let valid = call_594367.validator(path, query, header, formData, body)
  let scheme = call_594367.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594367.url(scheme.get, call_594367.host, call_594367.base,
                         call_594367.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594367, url, valid)

proc call*(call_594368: Call_StorageBucketsTestIamPermissions_594353;
          bucket: string; permissions: JsonNode; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketsTestIamPermissions
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ##   bucket: string (required)
  ##         : Name of a bucket.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594369 = newJObject()
  var query_594370 = newJObject()
  add(path_594369, "bucket", newJString(bucket))
  add(query_594370, "fields", newJString(fields))
  add(query_594370, "quotaUser", newJString(quotaUser))
  if permissions != nil:
    query_594370.add "permissions", permissions
  add(query_594370, "alt", newJString(alt))
  add(query_594370, "oauth_token", newJString(oauthToken))
  add(query_594370, "userIp", newJString(userIp))
  add(query_594370, "userProject", newJString(userProject))
  add(query_594370, "key", newJString(key))
  add(query_594370, "prettyPrint", newJBool(prettyPrint))
  add(query_594370, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594368.call(path_594369, query_594370, nil, nil, nil)

var storageBucketsTestIamPermissions* = Call_StorageBucketsTestIamPermissions_594353(
    name: "storageBucketsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam/testPermissions",
    validator: validate_StorageBucketsTestIamPermissions_594354,
    base: "/storage/v1", url: url_StorageBucketsTestIamPermissions_594355,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsLockRetentionPolicy_594371 = ref object of OpenApiRestCall_593424
proc url_StorageBucketsLockRetentionPolicy_594373(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/lockRetentionPolicy")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageBucketsLockRetentionPolicy_594372(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Locks retention policy on a bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594374 = path.getOrDefault("bucket")
  valid_594374 = validateParameter(valid_594374, JString, required = true,
                                 default = nil)
  if valid_594374 != nil:
    section.add "bucket", valid_594374
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: JString (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594375 = query.getOrDefault("fields")
  valid_594375 = validateParameter(valid_594375, JString, required = false,
                                 default = nil)
  if valid_594375 != nil:
    section.add "fields", valid_594375
  var valid_594376 = query.getOrDefault("quotaUser")
  valid_594376 = validateParameter(valid_594376, JString, required = false,
                                 default = nil)
  if valid_594376 != nil:
    section.add "quotaUser", valid_594376
  var valid_594377 = query.getOrDefault("alt")
  valid_594377 = validateParameter(valid_594377, JString, required = false,
                                 default = newJString("json"))
  if valid_594377 != nil:
    section.add "alt", valid_594377
  var valid_594378 = query.getOrDefault("oauth_token")
  valid_594378 = validateParameter(valid_594378, JString, required = false,
                                 default = nil)
  if valid_594378 != nil:
    section.add "oauth_token", valid_594378
  var valid_594379 = query.getOrDefault("userIp")
  valid_594379 = validateParameter(valid_594379, JString, required = false,
                                 default = nil)
  if valid_594379 != nil:
    section.add "userIp", valid_594379
  var valid_594380 = query.getOrDefault("userProject")
  valid_594380 = validateParameter(valid_594380, JString, required = false,
                                 default = nil)
  if valid_594380 != nil:
    section.add "userProject", valid_594380
  var valid_594381 = query.getOrDefault("key")
  valid_594381 = validateParameter(valid_594381, JString, required = false,
                                 default = nil)
  if valid_594381 != nil:
    section.add "key", valid_594381
  assert query != nil, "query argument is necessary due to required `ifMetagenerationMatch` field"
  var valid_594382 = query.getOrDefault("ifMetagenerationMatch")
  valid_594382 = validateParameter(valid_594382, JString, required = true,
                                 default = nil)
  if valid_594382 != nil:
    section.add "ifMetagenerationMatch", valid_594382
  var valid_594383 = query.getOrDefault("prettyPrint")
  valid_594383 = validateParameter(valid_594383, JBool, required = false,
                                 default = newJBool(true))
  if valid_594383 != nil:
    section.add "prettyPrint", valid_594383
  var valid_594384 = query.getOrDefault("provisionalUserProject")
  valid_594384 = validateParameter(valid_594384, JString, required = false,
                                 default = nil)
  if valid_594384 != nil:
    section.add "provisionalUserProject", valid_594384
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594385: Call_StorageBucketsLockRetentionPolicy_594371;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Locks retention policy on a bucket.
  ## 
  let valid = call_594385.validator(path, query, header, formData, body)
  let scheme = call_594385.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594385.url(scheme.get, call_594385.host, call_594385.base,
                         call_594385.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594385, url, valid)

proc call*(call_594386: Call_StorageBucketsLockRetentionPolicy_594371;
          bucket: string; ifMetagenerationMatch: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageBucketsLockRetentionPolicy
  ## Locks retention policy on a bucket.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   ifMetagenerationMatch: string (required)
  ##                        : Makes the operation conditional on whether bucket's current metageneration matches the given value.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594387 = newJObject()
  var query_594388 = newJObject()
  add(path_594387, "bucket", newJString(bucket))
  add(query_594388, "fields", newJString(fields))
  add(query_594388, "quotaUser", newJString(quotaUser))
  add(query_594388, "alt", newJString(alt))
  add(query_594388, "oauth_token", newJString(oauthToken))
  add(query_594388, "userIp", newJString(userIp))
  add(query_594388, "userProject", newJString(userProject))
  add(query_594388, "key", newJString(key))
  add(query_594388, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594388, "prettyPrint", newJBool(prettyPrint))
  add(query_594388, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594386.call(path_594387, query_594388, nil, nil, nil)

var storageBucketsLockRetentionPolicy* = Call_StorageBucketsLockRetentionPolicy_594371(
    name: "storageBucketsLockRetentionPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/lockRetentionPolicy",
    validator: validate_StorageBucketsLockRetentionPolicy_594372,
    base: "/storage/v1", url: url_StorageBucketsLockRetentionPolicy_594373,
    schemes: {Scheme.Https})
type
  Call_StorageNotificationsInsert_594406 = ref object of OpenApiRestCall_593424
proc url_StorageNotificationsInsert_594408(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsInsert_594407(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a notification subscription for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594409 = path.getOrDefault("bucket")
  valid_594409 = validateParameter(valid_594409, JString, required = true,
                                 default = nil)
  if valid_594409 != nil:
    section.add "bucket", valid_594409
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594410 = query.getOrDefault("fields")
  valid_594410 = validateParameter(valid_594410, JString, required = false,
                                 default = nil)
  if valid_594410 != nil:
    section.add "fields", valid_594410
  var valid_594411 = query.getOrDefault("quotaUser")
  valid_594411 = validateParameter(valid_594411, JString, required = false,
                                 default = nil)
  if valid_594411 != nil:
    section.add "quotaUser", valid_594411
  var valid_594412 = query.getOrDefault("alt")
  valid_594412 = validateParameter(valid_594412, JString, required = false,
                                 default = newJString("json"))
  if valid_594412 != nil:
    section.add "alt", valid_594412
  var valid_594413 = query.getOrDefault("oauth_token")
  valid_594413 = validateParameter(valid_594413, JString, required = false,
                                 default = nil)
  if valid_594413 != nil:
    section.add "oauth_token", valid_594413
  var valid_594414 = query.getOrDefault("userIp")
  valid_594414 = validateParameter(valid_594414, JString, required = false,
                                 default = nil)
  if valid_594414 != nil:
    section.add "userIp", valid_594414
  var valid_594415 = query.getOrDefault("userProject")
  valid_594415 = validateParameter(valid_594415, JString, required = false,
                                 default = nil)
  if valid_594415 != nil:
    section.add "userProject", valid_594415
  var valid_594416 = query.getOrDefault("key")
  valid_594416 = validateParameter(valid_594416, JString, required = false,
                                 default = nil)
  if valid_594416 != nil:
    section.add "key", valid_594416
  var valid_594417 = query.getOrDefault("prettyPrint")
  valid_594417 = validateParameter(valid_594417, JBool, required = false,
                                 default = newJBool(true))
  if valid_594417 != nil:
    section.add "prettyPrint", valid_594417
  var valid_594418 = query.getOrDefault("provisionalUserProject")
  valid_594418 = validateParameter(valid_594418, JString, required = false,
                                 default = nil)
  if valid_594418 != nil:
    section.add "provisionalUserProject", valid_594418
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

proc call*(call_594420: Call_StorageNotificationsInsert_594406; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a notification subscription for a given bucket.
  ## 
  let valid = call_594420.validator(path, query, header, formData, body)
  let scheme = call_594420.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594420.url(scheme.get, call_594420.host, call_594420.base,
                         call_594420.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594420, url, valid)

proc call*(call_594421: Call_StorageNotificationsInsert_594406; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsInsert
  ## Creates a notification subscription for a given bucket.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594422 = newJObject()
  var query_594423 = newJObject()
  var body_594424 = newJObject()
  add(path_594422, "bucket", newJString(bucket))
  add(query_594423, "fields", newJString(fields))
  add(query_594423, "quotaUser", newJString(quotaUser))
  add(query_594423, "alt", newJString(alt))
  add(query_594423, "oauth_token", newJString(oauthToken))
  add(query_594423, "userIp", newJString(userIp))
  add(query_594423, "userProject", newJString(userProject))
  add(query_594423, "key", newJString(key))
  if body != nil:
    body_594424 = body
  add(query_594423, "prettyPrint", newJBool(prettyPrint))
  add(query_594423, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594421.call(path_594422, query_594423, nil, nil, body_594424)

var storageNotificationsInsert* = Call_StorageNotificationsInsert_594406(
    name: "storageNotificationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsInsert_594407, base: "/storage/v1",
    url: url_StorageNotificationsInsert_594408, schemes: {Scheme.Https})
type
  Call_StorageNotificationsList_594389 = ref object of OpenApiRestCall_593424
proc url_StorageNotificationsList_594391(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsList_594390(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a Google Cloud Storage bucket.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594392 = path.getOrDefault("bucket")
  valid_594392 = validateParameter(valid_594392, JString, required = true,
                                 default = nil)
  if valid_594392 != nil:
    section.add "bucket", valid_594392
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594393 = query.getOrDefault("fields")
  valid_594393 = validateParameter(valid_594393, JString, required = false,
                                 default = nil)
  if valid_594393 != nil:
    section.add "fields", valid_594393
  var valid_594394 = query.getOrDefault("quotaUser")
  valid_594394 = validateParameter(valid_594394, JString, required = false,
                                 default = nil)
  if valid_594394 != nil:
    section.add "quotaUser", valid_594394
  var valid_594395 = query.getOrDefault("alt")
  valid_594395 = validateParameter(valid_594395, JString, required = false,
                                 default = newJString("json"))
  if valid_594395 != nil:
    section.add "alt", valid_594395
  var valid_594396 = query.getOrDefault("oauth_token")
  valid_594396 = validateParameter(valid_594396, JString, required = false,
                                 default = nil)
  if valid_594396 != nil:
    section.add "oauth_token", valid_594396
  var valid_594397 = query.getOrDefault("userIp")
  valid_594397 = validateParameter(valid_594397, JString, required = false,
                                 default = nil)
  if valid_594397 != nil:
    section.add "userIp", valid_594397
  var valid_594398 = query.getOrDefault("userProject")
  valid_594398 = validateParameter(valid_594398, JString, required = false,
                                 default = nil)
  if valid_594398 != nil:
    section.add "userProject", valid_594398
  var valid_594399 = query.getOrDefault("key")
  valid_594399 = validateParameter(valid_594399, JString, required = false,
                                 default = nil)
  if valid_594399 != nil:
    section.add "key", valid_594399
  var valid_594400 = query.getOrDefault("prettyPrint")
  valid_594400 = validateParameter(valid_594400, JBool, required = false,
                                 default = newJBool(true))
  if valid_594400 != nil:
    section.add "prettyPrint", valid_594400
  var valid_594401 = query.getOrDefault("provisionalUserProject")
  valid_594401 = validateParameter(valid_594401, JString, required = false,
                                 default = nil)
  if valid_594401 != nil:
    section.add "provisionalUserProject", valid_594401
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594402: Call_StorageNotificationsList_594389; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  let valid = call_594402.validator(path, query, header, formData, body)
  let scheme = call_594402.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594402.url(scheme.get, call_594402.host, call_594402.base,
                         call_594402.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594402, url, valid)

proc call*(call_594403: Call_StorageNotificationsList_594389; bucket: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsList
  ## Retrieves a list of notification subscriptions for a given bucket.
  ##   bucket: string (required)
  ##         : Name of a Google Cloud Storage bucket.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594404 = newJObject()
  var query_594405 = newJObject()
  add(path_594404, "bucket", newJString(bucket))
  add(query_594405, "fields", newJString(fields))
  add(query_594405, "quotaUser", newJString(quotaUser))
  add(query_594405, "alt", newJString(alt))
  add(query_594405, "oauth_token", newJString(oauthToken))
  add(query_594405, "userIp", newJString(userIp))
  add(query_594405, "userProject", newJString(userProject))
  add(query_594405, "key", newJString(key))
  add(query_594405, "prettyPrint", newJBool(prettyPrint))
  add(query_594405, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594403.call(path_594404, query_594405, nil, nil, nil)

var storageNotificationsList* = Call_StorageNotificationsList_594389(
    name: "storageNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsList_594390, base: "/storage/v1",
    url: url_StorageNotificationsList_594391, schemes: {Scheme.Https})
type
  Call_StorageNotificationsGet_594425 = ref object of OpenApiRestCall_593424
proc url_StorageNotificationsGet_594427(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsGet_594426(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## View a notification configuration.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  ##   notification: JString (required)
  ##               : Notification ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594428 = path.getOrDefault("bucket")
  valid_594428 = validateParameter(valid_594428, JString, required = true,
                                 default = nil)
  if valid_594428 != nil:
    section.add "bucket", valid_594428
  var valid_594429 = path.getOrDefault("notification")
  valid_594429 = validateParameter(valid_594429, JString, required = true,
                                 default = nil)
  if valid_594429 != nil:
    section.add "notification", valid_594429
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594430 = query.getOrDefault("fields")
  valid_594430 = validateParameter(valid_594430, JString, required = false,
                                 default = nil)
  if valid_594430 != nil:
    section.add "fields", valid_594430
  var valid_594431 = query.getOrDefault("quotaUser")
  valid_594431 = validateParameter(valid_594431, JString, required = false,
                                 default = nil)
  if valid_594431 != nil:
    section.add "quotaUser", valid_594431
  var valid_594432 = query.getOrDefault("alt")
  valid_594432 = validateParameter(valid_594432, JString, required = false,
                                 default = newJString("json"))
  if valid_594432 != nil:
    section.add "alt", valid_594432
  var valid_594433 = query.getOrDefault("oauth_token")
  valid_594433 = validateParameter(valid_594433, JString, required = false,
                                 default = nil)
  if valid_594433 != nil:
    section.add "oauth_token", valid_594433
  var valid_594434 = query.getOrDefault("userIp")
  valid_594434 = validateParameter(valid_594434, JString, required = false,
                                 default = nil)
  if valid_594434 != nil:
    section.add "userIp", valid_594434
  var valid_594435 = query.getOrDefault("userProject")
  valid_594435 = validateParameter(valid_594435, JString, required = false,
                                 default = nil)
  if valid_594435 != nil:
    section.add "userProject", valid_594435
  var valid_594436 = query.getOrDefault("key")
  valid_594436 = validateParameter(valid_594436, JString, required = false,
                                 default = nil)
  if valid_594436 != nil:
    section.add "key", valid_594436
  var valid_594437 = query.getOrDefault("prettyPrint")
  valid_594437 = validateParameter(valid_594437, JBool, required = false,
                                 default = newJBool(true))
  if valid_594437 != nil:
    section.add "prettyPrint", valid_594437
  var valid_594438 = query.getOrDefault("provisionalUserProject")
  valid_594438 = validateParameter(valid_594438, JString, required = false,
                                 default = nil)
  if valid_594438 != nil:
    section.add "provisionalUserProject", valid_594438
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594439: Call_StorageNotificationsGet_594425; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## View a notification configuration.
  ## 
  let valid = call_594439.validator(path, query, header, formData, body)
  let scheme = call_594439.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594439.url(scheme.get, call_594439.host, call_594439.base,
                         call_594439.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594439, url, valid)

proc call*(call_594440: Call_StorageNotificationsGet_594425; bucket: string;
          notification: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsGet
  ## View a notification configuration.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notification: string (required)
  ##               : Notification ID
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594441 = newJObject()
  var query_594442 = newJObject()
  add(path_594441, "bucket", newJString(bucket))
  add(query_594442, "fields", newJString(fields))
  add(query_594442, "quotaUser", newJString(quotaUser))
  add(query_594442, "alt", newJString(alt))
  add(path_594441, "notification", newJString(notification))
  add(query_594442, "oauth_token", newJString(oauthToken))
  add(query_594442, "userIp", newJString(userIp))
  add(query_594442, "userProject", newJString(userProject))
  add(query_594442, "key", newJString(key))
  add(query_594442, "prettyPrint", newJBool(prettyPrint))
  add(query_594442, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594440.call(path_594441, query_594442, nil, nil, nil)

var storageNotificationsGet* = Call_StorageNotificationsGet_594425(
    name: "storageNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsGet_594426, base: "/storage/v1",
    url: url_StorageNotificationsGet_594427, schemes: {Scheme.Https})
type
  Call_StorageNotificationsDelete_594443 = ref object of OpenApiRestCall_593424
proc url_StorageNotificationsDelete_594445(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "bucket" in path, "`bucket` is a required path parameter"
  assert "notification" in path, "`notification` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/b/"),
               (kind: VariableSegment, value: "bucket"),
               (kind: ConstantSegment, value: "/notificationConfigs/"),
               (kind: VariableSegment, value: "notification")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageNotificationsDelete_594444(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Permanently deletes a notification subscription.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : The parent bucket of the notification.
  ##   notification: JString (required)
  ##               : ID of the notification to delete.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594446 = path.getOrDefault("bucket")
  valid_594446 = validateParameter(valid_594446, JString, required = true,
                                 default = nil)
  if valid_594446 != nil:
    section.add "bucket", valid_594446
  var valid_594447 = path.getOrDefault("notification")
  valid_594447 = validateParameter(valid_594447, JString, required = true,
                                 default = nil)
  if valid_594447 != nil:
    section.add "notification", valid_594447
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594448 = query.getOrDefault("fields")
  valid_594448 = validateParameter(valid_594448, JString, required = false,
                                 default = nil)
  if valid_594448 != nil:
    section.add "fields", valid_594448
  var valid_594449 = query.getOrDefault("quotaUser")
  valid_594449 = validateParameter(valid_594449, JString, required = false,
                                 default = nil)
  if valid_594449 != nil:
    section.add "quotaUser", valid_594449
  var valid_594450 = query.getOrDefault("alt")
  valid_594450 = validateParameter(valid_594450, JString, required = false,
                                 default = newJString("json"))
  if valid_594450 != nil:
    section.add "alt", valid_594450
  var valid_594451 = query.getOrDefault("oauth_token")
  valid_594451 = validateParameter(valid_594451, JString, required = false,
                                 default = nil)
  if valid_594451 != nil:
    section.add "oauth_token", valid_594451
  var valid_594452 = query.getOrDefault("userIp")
  valid_594452 = validateParameter(valid_594452, JString, required = false,
                                 default = nil)
  if valid_594452 != nil:
    section.add "userIp", valid_594452
  var valid_594453 = query.getOrDefault("userProject")
  valid_594453 = validateParameter(valid_594453, JString, required = false,
                                 default = nil)
  if valid_594453 != nil:
    section.add "userProject", valid_594453
  var valid_594454 = query.getOrDefault("key")
  valid_594454 = validateParameter(valid_594454, JString, required = false,
                                 default = nil)
  if valid_594454 != nil:
    section.add "key", valid_594454
  var valid_594455 = query.getOrDefault("prettyPrint")
  valid_594455 = validateParameter(valid_594455, JBool, required = false,
                                 default = newJBool(true))
  if valid_594455 != nil:
    section.add "prettyPrint", valid_594455
  var valid_594456 = query.getOrDefault("provisionalUserProject")
  valid_594456 = validateParameter(valid_594456, JString, required = false,
                                 default = nil)
  if valid_594456 != nil:
    section.add "provisionalUserProject", valid_594456
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594457: Call_StorageNotificationsDelete_594443; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a notification subscription.
  ## 
  let valid = call_594457.validator(path, query, header, formData, body)
  let scheme = call_594457.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594457.url(scheme.get, call_594457.host, call_594457.base,
                         call_594457.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594457, url, valid)

proc call*(call_594458: Call_StorageNotificationsDelete_594443; bucket: string;
          notification: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageNotificationsDelete
  ## Permanently deletes a notification subscription.
  ##   bucket: string (required)
  ##         : The parent bucket of the notification.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   notification: string (required)
  ##               : ID of the notification to delete.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594459 = newJObject()
  var query_594460 = newJObject()
  add(path_594459, "bucket", newJString(bucket))
  add(query_594460, "fields", newJString(fields))
  add(query_594460, "quotaUser", newJString(quotaUser))
  add(query_594460, "alt", newJString(alt))
  add(path_594459, "notification", newJString(notification))
  add(query_594460, "oauth_token", newJString(oauthToken))
  add(query_594460, "userIp", newJString(userIp))
  add(query_594460, "userProject", newJString(userProject))
  add(query_594460, "key", newJString(key))
  add(query_594460, "prettyPrint", newJBool(prettyPrint))
  add(query_594460, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594458.call(path_594459, query_594460, nil, nil, nil)

var storageNotificationsDelete* = Call_StorageNotificationsDelete_594443(
    name: "storageNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsDelete_594444, base: "/storage/v1",
    url: url_StorageNotificationsDelete_594445, schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_594485 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsInsert_594487(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsInsert_594486(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Stores a new object and metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594488 = path.getOrDefault("bucket")
  valid_594488 = validateParameter(valid_594488, JString, required = true,
                                 default = nil)
  if valid_594488 != nil:
    section.add "bucket", valid_594488
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   contentEncoding: JString
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: JString
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594489 = query.getOrDefault("ifGenerationMatch")
  valid_594489 = validateParameter(valid_594489, JString, required = false,
                                 default = nil)
  if valid_594489 != nil:
    section.add "ifGenerationMatch", valid_594489
  var valid_594490 = query.getOrDefault("fields")
  valid_594490 = validateParameter(valid_594490, JString, required = false,
                                 default = nil)
  if valid_594490 != nil:
    section.add "fields", valid_594490
  var valid_594491 = query.getOrDefault("contentEncoding")
  valid_594491 = validateParameter(valid_594491, JString, required = false,
                                 default = nil)
  if valid_594491 != nil:
    section.add "contentEncoding", valid_594491
  var valid_594492 = query.getOrDefault("quotaUser")
  valid_594492 = validateParameter(valid_594492, JString, required = false,
                                 default = nil)
  if valid_594492 != nil:
    section.add "quotaUser", valid_594492
  var valid_594493 = query.getOrDefault("kmsKeyName")
  valid_594493 = validateParameter(valid_594493, JString, required = false,
                                 default = nil)
  if valid_594493 != nil:
    section.add "kmsKeyName", valid_594493
  var valid_594494 = query.getOrDefault("alt")
  valid_594494 = validateParameter(valid_594494, JString, required = false,
                                 default = newJString("json"))
  if valid_594494 != nil:
    section.add "alt", valid_594494
  var valid_594495 = query.getOrDefault("ifGenerationNotMatch")
  valid_594495 = validateParameter(valid_594495, JString, required = false,
                                 default = nil)
  if valid_594495 != nil:
    section.add "ifGenerationNotMatch", valid_594495
  var valid_594496 = query.getOrDefault("oauth_token")
  valid_594496 = validateParameter(valid_594496, JString, required = false,
                                 default = nil)
  if valid_594496 != nil:
    section.add "oauth_token", valid_594496
  var valid_594497 = query.getOrDefault("userIp")
  valid_594497 = validateParameter(valid_594497, JString, required = false,
                                 default = nil)
  if valid_594497 != nil:
    section.add "userIp", valid_594497
  var valid_594498 = query.getOrDefault("predefinedAcl")
  valid_594498 = validateParameter(valid_594498, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594498 != nil:
    section.add "predefinedAcl", valid_594498
  var valid_594499 = query.getOrDefault("userProject")
  valid_594499 = validateParameter(valid_594499, JString, required = false,
                                 default = nil)
  if valid_594499 != nil:
    section.add "userProject", valid_594499
  var valid_594500 = query.getOrDefault("key")
  valid_594500 = validateParameter(valid_594500, JString, required = false,
                                 default = nil)
  if valid_594500 != nil:
    section.add "key", valid_594500
  var valid_594501 = query.getOrDefault("name")
  valid_594501 = validateParameter(valid_594501, JString, required = false,
                                 default = nil)
  if valid_594501 != nil:
    section.add "name", valid_594501
  var valid_594502 = query.getOrDefault("projection")
  valid_594502 = validateParameter(valid_594502, JString, required = false,
                                 default = newJString("full"))
  if valid_594502 != nil:
    section.add "projection", valid_594502
  var valid_594503 = query.getOrDefault("ifMetagenerationMatch")
  valid_594503 = validateParameter(valid_594503, JString, required = false,
                                 default = nil)
  if valid_594503 != nil:
    section.add "ifMetagenerationMatch", valid_594503
  var valid_594504 = query.getOrDefault("prettyPrint")
  valid_594504 = validateParameter(valid_594504, JBool, required = false,
                                 default = newJBool(true))
  if valid_594504 != nil:
    section.add "prettyPrint", valid_594504
  var valid_594505 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594505 = validateParameter(valid_594505, JString, required = false,
                                 default = nil)
  if valid_594505 != nil:
    section.add "ifMetagenerationNotMatch", valid_594505
  var valid_594506 = query.getOrDefault("provisionalUserProject")
  valid_594506 = validateParameter(valid_594506, JString, required = false,
                                 default = nil)
  if valid_594506 != nil:
    section.add "provisionalUserProject", valid_594506
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

proc call*(call_594508: Call_StorageObjectsInsert_594485; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores a new object and metadata.
  ## 
  let valid = call_594508.validator(path, query, header, formData, body)
  let scheme = call_594508.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594508.url(scheme.get, call_594508.host, call_594508.base,
                         call_594508.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594508, url, valid)

proc call*(call_594509: Call_StorageObjectsInsert_594485; bucket: string;
          ifGenerationMatch: string = ""; fields: string = "";
          contentEncoding: string = ""; quotaUser: string = ""; kmsKeyName: string = "";
          alt: string = "json"; ifGenerationNotMatch: string = "";
          oauthToken: string = ""; userIp: string = "";
          predefinedAcl: string = "authenticatedRead"; userProject: string = "";
          key: string = ""; name: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsInsert
  ## Stores a new object and metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   contentEncoding: string
  ##                  : If set, sets the contentEncoding property of the final object to this value. Setting this parameter is equivalent to setting the contentEncoding metadata property. This can be useful when uploading an object with uploadType=media to indicate the encoding of the content being uploaded.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   name: string
  ##       : Name of the object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the object's current metageneration does not match the given value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594510 = newJObject()
  var query_594511 = newJObject()
  var body_594512 = newJObject()
  add(query_594511, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594510, "bucket", newJString(bucket))
  add(query_594511, "fields", newJString(fields))
  add(query_594511, "contentEncoding", newJString(contentEncoding))
  add(query_594511, "quotaUser", newJString(quotaUser))
  add(query_594511, "kmsKeyName", newJString(kmsKeyName))
  add(query_594511, "alt", newJString(alt))
  add(query_594511, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594511, "oauth_token", newJString(oauthToken))
  add(query_594511, "userIp", newJString(userIp))
  add(query_594511, "predefinedAcl", newJString(predefinedAcl))
  add(query_594511, "userProject", newJString(userProject))
  add(query_594511, "key", newJString(key))
  add(query_594511, "name", newJString(name))
  add(query_594511, "projection", newJString(projection))
  add(query_594511, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594512 = body
  add(query_594511, "prettyPrint", newJBool(prettyPrint))
  add(query_594511, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594511, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594509.call(path_594510, query_594511, nil, nil, body_594512)

var storageObjectsInsert* = Call_StorageObjectsInsert_594485(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_594486, base: "/storage/v1",
    url: url_StorageObjectsInsert_594487, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_594461 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsList_594463(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsList_594462(path: JsonNode; query: JsonNode;
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
  var valid_594464 = path.getOrDefault("bucket")
  valid_594464 = validateParameter(valid_594464, JString, required = true,
                                 default = nil)
  if valid_594464 != nil:
    section.add "bucket", valid_594464
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594465 = query.getOrDefault("fields")
  valid_594465 = validateParameter(valid_594465, JString, required = false,
                                 default = nil)
  if valid_594465 != nil:
    section.add "fields", valid_594465
  var valid_594466 = query.getOrDefault("pageToken")
  valid_594466 = validateParameter(valid_594466, JString, required = false,
                                 default = nil)
  if valid_594466 != nil:
    section.add "pageToken", valid_594466
  var valid_594467 = query.getOrDefault("quotaUser")
  valid_594467 = validateParameter(valid_594467, JString, required = false,
                                 default = nil)
  if valid_594467 != nil:
    section.add "quotaUser", valid_594467
  var valid_594468 = query.getOrDefault("includeTrailingDelimiter")
  valid_594468 = validateParameter(valid_594468, JBool, required = false, default = nil)
  if valid_594468 != nil:
    section.add "includeTrailingDelimiter", valid_594468
  var valid_594469 = query.getOrDefault("alt")
  valid_594469 = validateParameter(valid_594469, JString, required = false,
                                 default = newJString("json"))
  if valid_594469 != nil:
    section.add "alt", valid_594469
  var valid_594470 = query.getOrDefault("oauth_token")
  valid_594470 = validateParameter(valid_594470, JString, required = false,
                                 default = nil)
  if valid_594470 != nil:
    section.add "oauth_token", valid_594470
  var valid_594471 = query.getOrDefault("versions")
  valid_594471 = validateParameter(valid_594471, JBool, required = false, default = nil)
  if valid_594471 != nil:
    section.add "versions", valid_594471
  var valid_594472 = query.getOrDefault("userIp")
  valid_594472 = validateParameter(valid_594472, JString, required = false,
                                 default = nil)
  if valid_594472 != nil:
    section.add "userIp", valid_594472
  var valid_594473 = query.getOrDefault("maxResults")
  valid_594473 = validateParameter(valid_594473, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594473 != nil:
    section.add "maxResults", valid_594473
  var valid_594474 = query.getOrDefault("userProject")
  valid_594474 = validateParameter(valid_594474, JString, required = false,
                                 default = nil)
  if valid_594474 != nil:
    section.add "userProject", valid_594474
  var valid_594475 = query.getOrDefault("key")
  valid_594475 = validateParameter(valid_594475, JString, required = false,
                                 default = nil)
  if valid_594475 != nil:
    section.add "key", valid_594475
  var valid_594476 = query.getOrDefault("projection")
  valid_594476 = validateParameter(valid_594476, JString, required = false,
                                 default = newJString("full"))
  if valid_594476 != nil:
    section.add "projection", valid_594476
  var valid_594477 = query.getOrDefault("delimiter")
  valid_594477 = validateParameter(valid_594477, JString, required = false,
                                 default = nil)
  if valid_594477 != nil:
    section.add "delimiter", valid_594477
  var valid_594478 = query.getOrDefault("prettyPrint")
  valid_594478 = validateParameter(valid_594478, JBool, required = false,
                                 default = newJBool(true))
  if valid_594478 != nil:
    section.add "prettyPrint", valid_594478
  var valid_594479 = query.getOrDefault("prefix")
  valid_594479 = validateParameter(valid_594479, JString, required = false,
                                 default = nil)
  if valid_594479 != nil:
    section.add "prefix", valid_594479
  var valid_594480 = query.getOrDefault("provisionalUserProject")
  valid_594480 = validateParameter(valid_594480, JString, required = false,
                                 default = nil)
  if valid_594480 != nil:
    section.add "provisionalUserProject", valid_594480
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594481: Call_StorageObjectsList_594461; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_594481.validator(path, query, header, formData, body)
  let scheme = call_594481.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594481.url(scheme.get, call_594481.host, call_594481.base,
                         call_594481.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594481, url, valid)

proc call*(call_594482: Call_StorageObjectsList_594461; bucket: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          includeTrailingDelimiter: bool = false; alt: string = "json";
          oauthToken: string = ""; versions: bool = false; userIp: string = "";
          maxResults: int = 1000; userProject: string = ""; key: string = "";
          projection: string = "full"; delimiter: string = ""; prettyPrint: bool = true;
          prefix: string = ""; provisionalUserProject: string = ""): Recallable =
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
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594483 = newJObject()
  var query_594484 = newJObject()
  add(path_594483, "bucket", newJString(bucket))
  add(query_594484, "fields", newJString(fields))
  add(query_594484, "pageToken", newJString(pageToken))
  add(query_594484, "quotaUser", newJString(quotaUser))
  add(query_594484, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_594484, "alt", newJString(alt))
  add(query_594484, "oauth_token", newJString(oauthToken))
  add(query_594484, "versions", newJBool(versions))
  add(query_594484, "userIp", newJString(userIp))
  add(query_594484, "maxResults", newJInt(maxResults))
  add(query_594484, "userProject", newJString(userProject))
  add(query_594484, "key", newJString(key))
  add(query_594484, "projection", newJString(projection))
  add(query_594484, "delimiter", newJString(delimiter))
  add(query_594484, "prettyPrint", newJBool(prettyPrint))
  add(query_594484, "prefix", newJString(prefix))
  add(query_594484, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594482.call(path_594483, query_594484, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_594461(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_594462, base: "/storage/v1",
    url: url_StorageObjectsList_594463, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_594513 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsWatchAll_594515(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsWatchAll_594514(path: JsonNode; query: JsonNode;
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
  var valid_594516 = path.getOrDefault("bucket")
  valid_594516 = validateParameter(valid_594516, JString, required = true,
                                 default = nil)
  if valid_594516 != nil:
    section.add "bucket", valid_594516
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   pageToken: JString
  ##            : A previously-returned page token representing part of the larger set of results to view.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   includeTrailingDelimiter: JBool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   versions: JBool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: JInt
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594517 = query.getOrDefault("fields")
  valid_594517 = validateParameter(valid_594517, JString, required = false,
                                 default = nil)
  if valid_594517 != nil:
    section.add "fields", valid_594517
  var valid_594518 = query.getOrDefault("pageToken")
  valid_594518 = validateParameter(valid_594518, JString, required = false,
                                 default = nil)
  if valid_594518 != nil:
    section.add "pageToken", valid_594518
  var valid_594519 = query.getOrDefault("quotaUser")
  valid_594519 = validateParameter(valid_594519, JString, required = false,
                                 default = nil)
  if valid_594519 != nil:
    section.add "quotaUser", valid_594519
  var valid_594520 = query.getOrDefault("includeTrailingDelimiter")
  valid_594520 = validateParameter(valid_594520, JBool, required = false, default = nil)
  if valid_594520 != nil:
    section.add "includeTrailingDelimiter", valid_594520
  var valid_594521 = query.getOrDefault("alt")
  valid_594521 = validateParameter(valid_594521, JString, required = false,
                                 default = newJString("json"))
  if valid_594521 != nil:
    section.add "alt", valid_594521
  var valid_594522 = query.getOrDefault("oauth_token")
  valid_594522 = validateParameter(valid_594522, JString, required = false,
                                 default = nil)
  if valid_594522 != nil:
    section.add "oauth_token", valid_594522
  var valid_594523 = query.getOrDefault("versions")
  valid_594523 = validateParameter(valid_594523, JBool, required = false, default = nil)
  if valid_594523 != nil:
    section.add "versions", valid_594523
  var valid_594524 = query.getOrDefault("userIp")
  valid_594524 = validateParameter(valid_594524, JString, required = false,
                                 default = nil)
  if valid_594524 != nil:
    section.add "userIp", valid_594524
  var valid_594525 = query.getOrDefault("maxResults")
  valid_594525 = validateParameter(valid_594525, JInt, required = false,
                                 default = newJInt(1000))
  if valid_594525 != nil:
    section.add "maxResults", valid_594525
  var valid_594526 = query.getOrDefault("userProject")
  valid_594526 = validateParameter(valid_594526, JString, required = false,
                                 default = nil)
  if valid_594526 != nil:
    section.add "userProject", valid_594526
  var valid_594527 = query.getOrDefault("key")
  valid_594527 = validateParameter(valid_594527, JString, required = false,
                                 default = nil)
  if valid_594527 != nil:
    section.add "key", valid_594527
  var valid_594528 = query.getOrDefault("projection")
  valid_594528 = validateParameter(valid_594528, JString, required = false,
                                 default = newJString("full"))
  if valid_594528 != nil:
    section.add "projection", valid_594528
  var valid_594529 = query.getOrDefault("delimiter")
  valid_594529 = validateParameter(valid_594529, JString, required = false,
                                 default = nil)
  if valid_594529 != nil:
    section.add "delimiter", valid_594529
  var valid_594530 = query.getOrDefault("prettyPrint")
  valid_594530 = validateParameter(valid_594530, JBool, required = false,
                                 default = newJBool(true))
  if valid_594530 != nil:
    section.add "prettyPrint", valid_594530
  var valid_594531 = query.getOrDefault("prefix")
  valid_594531 = validateParameter(valid_594531, JString, required = false,
                                 default = nil)
  if valid_594531 != nil:
    section.add "prefix", valid_594531
  var valid_594532 = query.getOrDefault("provisionalUserProject")
  valid_594532 = validateParameter(valid_594532, JString, required = false,
                                 default = nil)
  if valid_594532 != nil:
    section.add "provisionalUserProject", valid_594532
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

proc call*(call_594534: Call_StorageObjectsWatchAll_594513; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_594534.validator(path, query, header, formData, body)
  let scheme = call_594534.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594534.url(scheme.get, call_594534.host, call_594534.base,
                         call_594534.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594534, url, valid)

proc call*(call_594535: Call_StorageObjectsWatchAll_594513; bucket: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          includeTrailingDelimiter: bool = false; alt: string = "json";
          oauthToken: string = ""; versions: bool = false; userIp: string = "";
          maxResults: int = 1000; userProject: string = ""; key: string = "";
          projection: string = "full"; delimiter: string = ""; resource: JsonNode = nil;
          prettyPrint: bool = true; prefix: string = "";
          provisionalUserProject: string = ""): Recallable =
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
  ##   includeTrailingDelimiter: bool
  ##                           : If true, objects that end in exactly one instance of delimiter will have their metadata included in items in addition to prefixes.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   versions: bool
  ##           : If true, lists all versions of an object as distinct results. The default is false. For more information, see Object Versioning.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   maxResults: int
  ##             : Maximum number of items plus prefixes to return in a single page of responses. As duplicate prefixes are omitted, fewer total results may be returned than requested. The service will use this parameter or 1,000 items, whichever is smaller.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594536 = newJObject()
  var query_594537 = newJObject()
  var body_594538 = newJObject()
  add(path_594536, "bucket", newJString(bucket))
  add(query_594537, "fields", newJString(fields))
  add(query_594537, "pageToken", newJString(pageToken))
  add(query_594537, "quotaUser", newJString(quotaUser))
  add(query_594537, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_594537, "alt", newJString(alt))
  add(query_594537, "oauth_token", newJString(oauthToken))
  add(query_594537, "versions", newJBool(versions))
  add(query_594537, "userIp", newJString(userIp))
  add(query_594537, "maxResults", newJInt(maxResults))
  add(query_594537, "userProject", newJString(userProject))
  add(query_594537, "key", newJString(key))
  add(query_594537, "projection", newJString(projection))
  add(query_594537, "delimiter", newJString(delimiter))
  if resource != nil:
    body_594538 = resource
  add(query_594537, "prettyPrint", newJBool(prettyPrint))
  add(query_594537, "prefix", newJString(prefix))
  add(query_594537, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594535.call(path_594536, query_594537, nil, nil, body_594538)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_594513(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_594514, base: "/storage/v1",
    url: url_StorageObjectsWatchAll_594515, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_594563 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsUpdate_594565(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsUpdate_594564(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594566 = path.getOrDefault("bucket")
  valid_594566 = validateParameter(valid_594566, JString, required = true,
                                 default = nil)
  if valid_594566 != nil:
    section.add "bucket", valid_594566
  var valid_594567 = path.getOrDefault("object")
  valid_594567 = validateParameter(valid_594567, JString, required = true,
                                 default = nil)
  if valid_594567 != nil:
    section.add "object", valid_594567
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594568 = query.getOrDefault("ifGenerationMatch")
  valid_594568 = validateParameter(valid_594568, JString, required = false,
                                 default = nil)
  if valid_594568 != nil:
    section.add "ifGenerationMatch", valid_594568
  var valid_594569 = query.getOrDefault("fields")
  valid_594569 = validateParameter(valid_594569, JString, required = false,
                                 default = nil)
  if valid_594569 != nil:
    section.add "fields", valid_594569
  var valid_594570 = query.getOrDefault("quotaUser")
  valid_594570 = validateParameter(valid_594570, JString, required = false,
                                 default = nil)
  if valid_594570 != nil:
    section.add "quotaUser", valid_594570
  var valid_594571 = query.getOrDefault("alt")
  valid_594571 = validateParameter(valid_594571, JString, required = false,
                                 default = newJString("json"))
  if valid_594571 != nil:
    section.add "alt", valid_594571
  var valid_594572 = query.getOrDefault("ifGenerationNotMatch")
  valid_594572 = validateParameter(valid_594572, JString, required = false,
                                 default = nil)
  if valid_594572 != nil:
    section.add "ifGenerationNotMatch", valid_594572
  var valid_594573 = query.getOrDefault("oauth_token")
  valid_594573 = validateParameter(valid_594573, JString, required = false,
                                 default = nil)
  if valid_594573 != nil:
    section.add "oauth_token", valid_594573
  var valid_594574 = query.getOrDefault("userIp")
  valid_594574 = validateParameter(valid_594574, JString, required = false,
                                 default = nil)
  if valid_594574 != nil:
    section.add "userIp", valid_594574
  var valid_594575 = query.getOrDefault("predefinedAcl")
  valid_594575 = validateParameter(valid_594575, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594575 != nil:
    section.add "predefinedAcl", valid_594575
  var valid_594576 = query.getOrDefault("userProject")
  valid_594576 = validateParameter(valid_594576, JString, required = false,
                                 default = nil)
  if valid_594576 != nil:
    section.add "userProject", valid_594576
  var valid_594577 = query.getOrDefault("key")
  valid_594577 = validateParameter(valid_594577, JString, required = false,
                                 default = nil)
  if valid_594577 != nil:
    section.add "key", valid_594577
  var valid_594578 = query.getOrDefault("projection")
  valid_594578 = validateParameter(valid_594578, JString, required = false,
                                 default = newJString("full"))
  if valid_594578 != nil:
    section.add "projection", valid_594578
  var valid_594579 = query.getOrDefault("ifMetagenerationMatch")
  valid_594579 = validateParameter(valid_594579, JString, required = false,
                                 default = nil)
  if valid_594579 != nil:
    section.add "ifMetagenerationMatch", valid_594579
  var valid_594580 = query.getOrDefault("generation")
  valid_594580 = validateParameter(valid_594580, JString, required = false,
                                 default = nil)
  if valid_594580 != nil:
    section.add "generation", valid_594580
  var valid_594581 = query.getOrDefault("prettyPrint")
  valid_594581 = validateParameter(valid_594581, JBool, required = false,
                                 default = newJBool(true))
  if valid_594581 != nil:
    section.add "prettyPrint", valid_594581
  var valid_594582 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594582 = validateParameter(valid_594582, JString, required = false,
                                 default = nil)
  if valid_594582 != nil:
    section.add "ifMetagenerationNotMatch", valid_594582
  var valid_594583 = query.getOrDefault("provisionalUserProject")
  valid_594583 = validateParameter(valid_594583, JString, required = false,
                                 default = nil)
  if valid_594583 != nil:
    section.add "provisionalUserProject", valid_594583
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

proc call*(call_594585: Call_StorageObjectsUpdate_594563; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an object's metadata.
  ## 
  let valid = call_594585.validator(path, query, header, formData, body)
  let scheme = call_594585.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594585.url(scheme.get, call_594585.host, call_594585.base,
                         call_594585.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594585, url, valid)

proc call*(call_594586: Call_StorageObjectsUpdate_594563; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; predefinedAcl: string = "authenticatedRead";
          userProject: string = ""; key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsUpdate
  ## Updates an object's metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594587 = newJObject()
  var query_594588 = newJObject()
  var body_594589 = newJObject()
  add(query_594588, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594587, "bucket", newJString(bucket))
  add(query_594588, "fields", newJString(fields))
  add(query_594588, "quotaUser", newJString(quotaUser))
  add(query_594588, "alt", newJString(alt))
  add(query_594588, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594588, "oauth_token", newJString(oauthToken))
  add(query_594588, "userIp", newJString(userIp))
  add(query_594588, "predefinedAcl", newJString(predefinedAcl))
  add(query_594588, "userProject", newJString(userProject))
  add(query_594588, "key", newJString(key))
  add(query_594588, "projection", newJString(projection))
  add(query_594588, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594588, "generation", newJString(generation))
  if body != nil:
    body_594589 = body
  add(query_594588, "prettyPrint", newJBool(prettyPrint))
  add(query_594588, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594587, "object", newJString(`object`))
  add(query_594588, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594586.call(path_594587, query_594588, nil, nil, body_594589)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_594563(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_594564, base: "/storage/v1",
    url: url_StorageObjectsUpdate_594565, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_594539 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsGet_594541(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsGet_594540(path: JsonNode; query: JsonNode;
                                      header: JsonNode; formData: JsonNode;
                                      body: JsonNode): JsonNode =
  ## Retrieves an object or its metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594542 = path.getOrDefault("bucket")
  valid_594542 = validateParameter(valid_594542, JString, required = true,
                                 default = nil)
  if valid_594542 != nil:
    section.add "bucket", valid_594542
  var valid_594543 = path.getOrDefault("object")
  valid_594543 = validateParameter(valid_594543, JString, required = true,
                                 default = nil)
  if valid_594543 != nil:
    section.add "object", valid_594543
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594544 = query.getOrDefault("ifGenerationMatch")
  valid_594544 = validateParameter(valid_594544, JString, required = false,
                                 default = nil)
  if valid_594544 != nil:
    section.add "ifGenerationMatch", valid_594544
  var valid_594545 = query.getOrDefault("fields")
  valid_594545 = validateParameter(valid_594545, JString, required = false,
                                 default = nil)
  if valid_594545 != nil:
    section.add "fields", valid_594545
  var valid_594546 = query.getOrDefault("quotaUser")
  valid_594546 = validateParameter(valid_594546, JString, required = false,
                                 default = nil)
  if valid_594546 != nil:
    section.add "quotaUser", valid_594546
  var valid_594547 = query.getOrDefault("alt")
  valid_594547 = validateParameter(valid_594547, JString, required = false,
                                 default = newJString("json"))
  if valid_594547 != nil:
    section.add "alt", valid_594547
  var valid_594548 = query.getOrDefault("ifGenerationNotMatch")
  valid_594548 = validateParameter(valid_594548, JString, required = false,
                                 default = nil)
  if valid_594548 != nil:
    section.add "ifGenerationNotMatch", valid_594548
  var valid_594549 = query.getOrDefault("oauth_token")
  valid_594549 = validateParameter(valid_594549, JString, required = false,
                                 default = nil)
  if valid_594549 != nil:
    section.add "oauth_token", valid_594549
  var valid_594550 = query.getOrDefault("userIp")
  valid_594550 = validateParameter(valid_594550, JString, required = false,
                                 default = nil)
  if valid_594550 != nil:
    section.add "userIp", valid_594550
  var valid_594551 = query.getOrDefault("userProject")
  valid_594551 = validateParameter(valid_594551, JString, required = false,
                                 default = nil)
  if valid_594551 != nil:
    section.add "userProject", valid_594551
  var valid_594552 = query.getOrDefault("key")
  valid_594552 = validateParameter(valid_594552, JString, required = false,
                                 default = nil)
  if valid_594552 != nil:
    section.add "key", valid_594552
  var valid_594553 = query.getOrDefault("projection")
  valid_594553 = validateParameter(valid_594553, JString, required = false,
                                 default = newJString("full"))
  if valid_594553 != nil:
    section.add "projection", valid_594553
  var valid_594554 = query.getOrDefault("ifMetagenerationMatch")
  valid_594554 = validateParameter(valid_594554, JString, required = false,
                                 default = nil)
  if valid_594554 != nil:
    section.add "ifMetagenerationMatch", valid_594554
  var valid_594555 = query.getOrDefault("generation")
  valid_594555 = validateParameter(valid_594555, JString, required = false,
                                 default = nil)
  if valid_594555 != nil:
    section.add "generation", valid_594555
  var valid_594556 = query.getOrDefault("prettyPrint")
  valid_594556 = validateParameter(valid_594556, JBool, required = false,
                                 default = newJBool(true))
  if valid_594556 != nil:
    section.add "prettyPrint", valid_594556
  var valid_594557 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594557 = validateParameter(valid_594557, JString, required = false,
                                 default = nil)
  if valid_594557 != nil:
    section.add "ifMetagenerationNotMatch", valid_594557
  var valid_594558 = query.getOrDefault("provisionalUserProject")
  valid_594558 = validateParameter(valid_594558, JString, required = false,
                                 default = nil)
  if valid_594558 != nil:
    section.add "provisionalUserProject", valid_594558
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594559: Call_StorageObjectsGet_594539; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an object or its metadata.
  ## 
  let valid = call_594559.validator(path, query, header, formData, body)
  let scheme = call_594559.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594559.url(scheme.get, call_594559.host, call_594559.base,
                         call_594559.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594559, url, valid)

proc call*(call_594560: Call_StorageObjectsGet_594539; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          projection: string = "full"; ifMetagenerationMatch: string = "";
          generation: string = ""; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsGet
  ## Retrieves an object or its metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594561 = newJObject()
  var query_594562 = newJObject()
  add(query_594562, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594561, "bucket", newJString(bucket))
  add(query_594562, "fields", newJString(fields))
  add(query_594562, "quotaUser", newJString(quotaUser))
  add(query_594562, "alt", newJString(alt))
  add(query_594562, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594562, "oauth_token", newJString(oauthToken))
  add(query_594562, "userIp", newJString(userIp))
  add(query_594562, "userProject", newJString(userProject))
  add(query_594562, "key", newJString(key))
  add(query_594562, "projection", newJString(projection))
  add(query_594562, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594562, "generation", newJString(generation))
  add(query_594562, "prettyPrint", newJBool(prettyPrint))
  add(query_594562, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594561, "object", newJString(`object`))
  add(query_594562, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594560.call(path_594561, query_594562, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_594539(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_594540,
    base: "/storage/v1", url: url_StorageObjectsGet_594541, schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_594613 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsPatch_594615(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsPatch_594614(path: JsonNode; query: JsonNode;
                                        header: JsonNode; formData: JsonNode;
                                        body: JsonNode): JsonNode =
  ## Patches an object's metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594616 = path.getOrDefault("bucket")
  valid_594616 = validateParameter(valid_594616, JString, required = true,
                                 default = nil)
  if valid_594616 != nil:
    section.add "bucket", valid_594616
  var valid_594617 = path.getOrDefault("object")
  valid_594617 = validateParameter(valid_594617, JString, required = true,
                                 default = nil)
  if valid_594617 != nil:
    section.add "object", valid_594617
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: JString
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: JString
  ##              : The project to be billed for this request, for Requester Pays buckets.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594618 = query.getOrDefault("ifGenerationMatch")
  valid_594618 = validateParameter(valid_594618, JString, required = false,
                                 default = nil)
  if valid_594618 != nil:
    section.add "ifGenerationMatch", valid_594618
  var valid_594619 = query.getOrDefault("fields")
  valid_594619 = validateParameter(valid_594619, JString, required = false,
                                 default = nil)
  if valid_594619 != nil:
    section.add "fields", valid_594619
  var valid_594620 = query.getOrDefault("quotaUser")
  valid_594620 = validateParameter(valid_594620, JString, required = false,
                                 default = nil)
  if valid_594620 != nil:
    section.add "quotaUser", valid_594620
  var valid_594621 = query.getOrDefault("alt")
  valid_594621 = validateParameter(valid_594621, JString, required = false,
                                 default = newJString("json"))
  if valid_594621 != nil:
    section.add "alt", valid_594621
  var valid_594622 = query.getOrDefault("ifGenerationNotMatch")
  valid_594622 = validateParameter(valid_594622, JString, required = false,
                                 default = nil)
  if valid_594622 != nil:
    section.add "ifGenerationNotMatch", valid_594622
  var valid_594623 = query.getOrDefault("oauth_token")
  valid_594623 = validateParameter(valid_594623, JString, required = false,
                                 default = nil)
  if valid_594623 != nil:
    section.add "oauth_token", valid_594623
  var valid_594624 = query.getOrDefault("userIp")
  valid_594624 = validateParameter(valid_594624, JString, required = false,
                                 default = nil)
  if valid_594624 != nil:
    section.add "userIp", valid_594624
  var valid_594625 = query.getOrDefault("predefinedAcl")
  valid_594625 = validateParameter(valid_594625, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594625 != nil:
    section.add "predefinedAcl", valid_594625
  var valid_594626 = query.getOrDefault("userProject")
  valid_594626 = validateParameter(valid_594626, JString, required = false,
                                 default = nil)
  if valid_594626 != nil:
    section.add "userProject", valid_594626
  var valid_594627 = query.getOrDefault("key")
  valid_594627 = validateParameter(valid_594627, JString, required = false,
                                 default = nil)
  if valid_594627 != nil:
    section.add "key", valid_594627
  var valid_594628 = query.getOrDefault("projection")
  valid_594628 = validateParameter(valid_594628, JString, required = false,
                                 default = newJString("full"))
  if valid_594628 != nil:
    section.add "projection", valid_594628
  var valid_594629 = query.getOrDefault("ifMetagenerationMatch")
  valid_594629 = validateParameter(valid_594629, JString, required = false,
                                 default = nil)
  if valid_594629 != nil:
    section.add "ifMetagenerationMatch", valid_594629
  var valid_594630 = query.getOrDefault("generation")
  valid_594630 = validateParameter(valid_594630, JString, required = false,
                                 default = nil)
  if valid_594630 != nil:
    section.add "generation", valid_594630
  var valid_594631 = query.getOrDefault("prettyPrint")
  valid_594631 = validateParameter(valid_594631, JBool, required = false,
                                 default = newJBool(true))
  if valid_594631 != nil:
    section.add "prettyPrint", valid_594631
  var valid_594632 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594632 = validateParameter(valid_594632, JString, required = false,
                                 default = nil)
  if valid_594632 != nil:
    section.add "ifMetagenerationNotMatch", valid_594632
  var valid_594633 = query.getOrDefault("provisionalUserProject")
  valid_594633 = validateParameter(valid_594633, JString, required = false,
                                 default = nil)
  if valid_594633 != nil:
    section.add "provisionalUserProject", valid_594633
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

proc call*(call_594635: Call_StorageObjectsPatch_594613; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an object's metadata.
  ## 
  let valid = call_594635.validator(path, query, header, formData, body)
  let scheme = call_594635.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594635.url(scheme.get, call_594635.host, call_594635.base,
                         call_594635.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594635, url, valid)

proc call*(call_594636: Call_StorageObjectsPatch_594613; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; predefinedAcl: string = "authenticatedRead";
          userProject: string = ""; key: string = ""; projection: string = "full";
          ifMetagenerationMatch: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          ifMetagenerationNotMatch: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsPatch
  ## Patches an object's metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   predefinedAcl: string
  ##                : Apply a predefined set of access controls to this object.
  ##   userProject: string
  ##              : The project to be billed for this request, for Requester Pays buckets.
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594637 = newJObject()
  var query_594638 = newJObject()
  var body_594639 = newJObject()
  add(query_594638, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594637, "bucket", newJString(bucket))
  add(query_594638, "fields", newJString(fields))
  add(query_594638, "quotaUser", newJString(quotaUser))
  add(query_594638, "alt", newJString(alt))
  add(query_594638, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594638, "oauth_token", newJString(oauthToken))
  add(query_594638, "userIp", newJString(userIp))
  add(query_594638, "predefinedAcl", newJString(predefinedAcl))
  add(query_594638, "userProject", newJString(userProject))
  add(query_594638, "key", newJString(key))
  add(query_594638, "projection", newJString(projection))
  add(query_594638, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594638, "generation", newJString(generation))
  if body != nil:
    body_594639 = body
  add(query_594638, "prettyPrint", newJBool(prettyPrint))
  add(query_594638, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594637, "object", newJString(`object`))
  add(query_594638, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594636.call(path_594637, query_594638, nil, nil, body_594639)

var storageObjectsPatch* = Call_StorageObjectsPatch_594613(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_594614, base: "/storage/v1",
    url: url_StorageObjectsPatch_594615, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_594590 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsDelete_594592(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsDelete_594591(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594593 = path.getOrDefault("bucket")
  valid_594593 = validateParameter(valid_594593, JString, required = true,
                                 default = nil)
  if valid_594593 != nil:
    section.add "bucket", valid_594593
  var valid_594594 = path.getOrDefault("object")
  valid_594594 = validateParameter(valid_594594, JString, required = true,
                                 default = nil)
  if valid_594594 != nil:
    section.add "object", valid_594594
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594595 = query.getOrDefault("ifGenerationMatch")
  valid_594595 = validateParameter(valid_594595, JString, required = false,
                                 default = nil)
  if valid_594595 != nil:
    section.add "ifGenerationMatch", valid_594595
  var valid_594596 = query.getOrDefault("fields")
  valid_594596 = validateParameter(valid_594596, JString, required = false,
                                 default = nil)
  if valid_594596 != nil:
    section.add "fields", valid_594596
  var valid_594597 = query.getOrDefault("quotaUser")
  valid_594597 = validateParameter(valid_594597, JString, required = false,
                                 default = nil)
  if valid_594597 != nil:
    section.add "quotaUser", valid_594597
  var valid_594598 = query.getOrDefault("alt")
  valid_594598 = validateParameter(valid_594598, JString, required = false,
                                 default = newJString("json"))
  if valid_594598 != nil:
    section.add "alt", valid_594598
  var valid_594599 = query.getOrDefault("ifGenerationNotMatch")
  valid_594599 = validateParameter(valid_594599, JString, required = false,
                                 default = nil)
  if valid_594599 != nil:
    section.add "ifGenerationNotMatch", valid_594599
  var valid_594600 = query.getOrDefault("oauth_token")
  valid_594600 = validateParameter(valid_594600, JString, required = false,
                                 default = nil)
  if valid_594600 != nil:
    section.add "oauth_token", valid_594600
  var valid_594601 = query.getOrDefault("userIp")
  valid_594601 = validateParameter(valid_594601, JString, required = false,
                                 default = nil)
  if valid_594601 != nil:
    section.add "userIp", valid_594601
  var valid_594602 = query.getOrDefault("userProject")
  valid_594602 = validateParameter(valid_594602, JString, required = false,
                                 default = nil)
  if valid_594602 != nil:
    section.add "userProject", valid_594602
  var valid_594603 = query.getOrDefault("key")
  valid_594603 = validateParameter(valid_594603, JString, required = false,
                                 default = nil)
  if valid_594603 != nil:
    section.add "key", valid_594603
  var valid_594604 = query.getOrDefault("ifMetagenerationMatch")
  valid_594604 = validateParameter(valid_594604, JString, required = false,
                                 default = nil)
  if valid_594604 != nil:
    section.add "ifMetagenerationMatch", valid_594604
  var valid_594605 = query.getOrDefault("generation")
  valid_594605 = validateParameter(valid_594605, JString, required = false,
                                 default = nil)
  if valid_594605 != nil:
    section.add "generation", valid_594605
  var valid_594606 = query.getOrDefault("prettyPrint")
  valid_594606 = validateParameter(valid_594606, JBool, required = false,
                                 default = newJBool(true))
  if valid_594606 != nil:
    section.add "prettyPrint", valid_594606
  var valid_594607 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594607 = validateParameter(valid_594607, JString, required = false,
                                 default = nil)
  if valid_594607 != nil:
    section.add "ifMetagenerationNotMatch", valid_594607
  var valid_594608 = query.getOrDefault("provisionalUserProject")
  valid_594608 = validateParameter(valid_594608, JString, required = false,
                                 default = nil)
  if valid_594608 != nil:
    section.add "provisionalUserProject", valid_594608
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594609: Call_StorageObjectsDelete_594590; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_594609.validator(path, query, header, formData, body)
  let scheme = call_594609.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594609.url(scheme.get, call_594609.host, call_594609.base,
                         call_594609.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594609, url, valid)

proc call*(call_594610: Call_StorageObjectsDelete_594590; bucket: string;
          `object`: string; ifGenerationMatch: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json";
          ifGenerationNotMatch: string = ""; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          ifMetagenerationMatch: string = ""; generation: string = "";
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsDelete
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594611 = newJObject()
  var query_594612 = newJObject()
  add(query_594612, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_594611, "bucket", newJString(bucket))
  add(query_594612, "fields", newJString(fields))
  add(query_594612, "quotaUser", newJString(quotaUser))
  add(query_594612, "alt", newJString(alt))
  add(query_594612, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594612, "oauth_token", newJString(oauthToken))
  add(query_594612, "userIp", newJString(userIp))
  add(query_594612, "userProject", newJString(userProject))
  add(query_594612, "key", newJString(key))
  add(query_594612, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594612, "generation", newJString(generation))
  add(query_594612, "prettyPrint", newJBool(prettyPrint))
  add(query_594612, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_594611, "object", newJString(`object`))
  add(query_594612, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594610.call(path_594611, query_594612, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_594590(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_594591, base: "/storage/v1",
    url: url_StorageObjectsDelete_594592, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_594659 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsInsert_594661(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsInsert_594660(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594662 = path.getOrDefault("bucket")
  valid_594662 = validateParameter(valid_594662, JString, required = true,
                                 default = nil)
  if valid_594662 != nil:
    section.add "bucket", valid_594662
  var valid_594663 = path.getOrDefault("object")
  valid_594663 = validateParameter(valid_594663, JString, required = true,
                                 default = nil)
  if valid_594663 != nil:
    section.add "object", valid_594663
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594664 = query.getOrDefault("fields")
  valid_594664 = validateParameter(valid_594664, JString, required = false,
                                 default = nil)
  if valid_594664 != nil:
    section.add "fields", valid_594664
  var valid_594665 = query.getOrDefault("quotaUser")
  valid_594665 = validateParameter(valid_594665, JString, required = false,
                                 default = nil)
  if valid_594665 != nil:
    section.add "quotaUser", valid_594665
  var valid_594666 = query.getOrDefault("alt")
  valid_594666 = validateParameter(valid_594666, JString, required = false,
                                 default = newJString("json"))
  if valid_594666 != nil:
    section.add "alt", valid_594666
  var valid_594667 = query.getOrDefault("oauth_token")
  valid_594667 = validateParameter(valid_594667, JString, required = false,
                                 default = nil)
  if valid_594667 != nil:
    section.add "oauth_token", valid_594667
  var valid_594668 = query.getOrDefault("userIp")
  valid_594668 = validateParameter(valid_594668, JString, required = false,
                                 default = nil)
  if valid_594668 != nil:
    section.add "userIp", valid_594668
  var valid_594669 = query.getOrDefault("userProject")
  valid_594669 = validateParameter(valid_594669, JString, required = false,
                                 default = nil)
  if valid_594669 != nil:
    section.add "userProject", valid_594669
  var valid_594670 = query.getOrDefault("key")
  valid_594670 = validateParameter(valid_594670, JString, required = false,
                                 default = nil)
  if valid_594670 != nil:
    section.add "key", valid_594670
  var valid_594671 = query.getOrDefault("generation")
  valid_594671 = validateParameter(valid_594671, JString, required = false,
                                 default = nil)
  if valid_594671 != nil:
    section.add "generation", valid_594671
  var valid_594672 = query.getOrDefault("prettyPrint")
  valid_594672 = validateParameter(valid_594672, JBool, required = false,
                                 default = newJBool(true))
  if valid_594672 != nil:
    section.add "prettyPrint", valid_594672
  var valid_594673 = query.getOrDefault("provisionalUserProject")
  valid_594673 = validateParameter(valid_594673, JString, required = false,
                                 default = nil)
  if valid_594673 != nil:
    section.add "provisionalUserProject", valid_594673
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

proc call*(call_594675: Call_StorageObjectAccessControlsInsert_594659;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_594675.validator(path, query, header, formData, body)
  let scheme = call_594675.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594675.url(scheme.get, call_594675.host, call_594675.base,
                         call_594675.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594675, url, valid)

proc call*(call_594676: Call_StorageObjectAccessControlsInsert_594659;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594677 = newJObject()
  var query_594678 = newJObject()
  var body_594679 = newJObject()
  add(path_594677, "bucket", newJString(bucket))
  add(query_594678, "fields", newJString(fields))
  add(query_594678, "quotaUser", newJString(quotaUser))
  add(query_594678, "alt", newJString(alt))
  add(query_594678, "oauth_token", newJString(oauthToken))
  add(query_594678, "userIp", newJString(userIp))
  add(query_594678, "userProject", newJString(userProject))
  add(query_594678, "key", newJString(key))
  add(query_594678, "generation", newJString(generation))
  if body != nil:
    body_594679 = body
  add(query_594678, "prettyPrint", newJBool(prettyPrint))
  add(path_594677, "object", newJString(`object`))
  add(query_594678, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594676.call(path_594677, query_594678, nil, nil, body_594679)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_594659(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_594660,
    base: "/storage/v1", url: url_StorageObjectAccessControlsInsert_594661,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_594640 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsList_594642(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsList_594641(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves ACL entries on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594643 = path.getOrDefault("bucket")
  valid_594643 = validateParameter(valid_594643, JString, required = true,
                                 default = nil)
  if valid_594643 != nil:
    section.add "bucket", valid_594643
  var valid_594644 = path.getOrDefault("object")
  valid_594644 = validateParameter(valid_594644, JString, required = true,
                                 default = nil)
  if valid_594644 != nil:
    section.add "object", valid_594644
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594645 = query.getOrDefault("fields")
  valid_594645 = validateParameter(valid_594645, JString, required = false,
                                 default = nil)
  if valid_594645 != nil:
    section.add "fields", valid_594645
  var valid_594646 = query.getOrDefault("quotaUser")
  valid_594646 = validateParameter(valid_594646, JString, required = false,
                                 default = nil)
  if valid_594646 != nil:
    section.add "quotaUser", valid_594646
  var valid_594647 = query.getOrDefault("alt")
  valid_594647 = validateParameter(valid_594647, JString, required = false,
                                 default = newJString("json"))
  if valid_594647 != nil:
    section.add "alt", valid_594647
  var valid_594648 = query.getOrDefault("oauth_token")
  valid_594648 = validateParameter(valid_594648, JString, required = false,
                                 default = nil)
  if valid_594648 != nil:
    section.add "oauth_token", valid_594648
  var valid_594649 = query.getOrDefault("userIp")
  valid_594649 = validateParameter(valid_594649, JString, required = false,
                                 default = nil)
  if valid_594649 != nil:
    section.add "userIp", valid_594649
  var valid_594650 = query.getOrDefault("userProject")
  valid_594650 = validateParameter(valid_594650, JString, required = false,
                                 default = nil)
  if valid_594650 != nil:
    section.add "userProject", valid_594650
  var valid_594651 = query.getOrDefault("key")
  valid_594651 = validateParameter(valid_594651, JString, required = false,
                                 default = nil)
  if valid_594651 != nil:
    section.add "key", valid_594651
  var valid_594652 = query.getOrDefault("generation")
  valid_594652 = validateParameter(valid_594652, JString, required = false,
                                 default = nil)
  if valid_594652 != nil:
    section.add "generation", valid_594652
  var valid_594653 = query.getOrDefault("prettyPrint")
  valid_594653 = validateParameter(valid_594653, JBool, required = false,
                                 default = newJBool(true))
  if valid_594653 != nil:
    section.add "prettyPrint", valid_594653
  var valid_594654 = query.getOrDefault("provisionalUserProject")
  valid_594654 = validateParameter(valid_594654, JString, required = false,
                                 default = nil)
  if valid_594654 != nil:
    section.add "provisionalUserProject", valid_594654
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594655: Call_StorageObjectAccessControlsList_594640;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_594655.validator(path, query, header, formData, body)
  let scheme = call_594655.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594655.url(scheme.get, call_594655.host, call_594655.base,
                         call_594655.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594655, url, valid)

proc call*(call_594656: Call_StorageObjectAccessControlsList_594640;
          bucket: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594657 = newJObject()
  var query_594658 = newJObject()
  add(path_594657, "bucket", newJString(bucket))
  add(query_594658, "fields", newJString(fields))
  add(query_594658, "quotaUser", newJString(quotaUser))
  add(query_594658, "alt", newJString(alt))
  add(query_594658, "oauth_token", newJString(oauthToken))
  add(query_594658, "userIp", newJString(userIp))
  add(query_594658, "userProject", newJString(userProject))
  add(query_594658, "key", newJString(key))
  add(query_594658, "generation", newJString(generation))
  add(query_594658, "prettyPrint", newJBool(prettyPrint))
  add(path_594657, "object", newJString(`object`))
  add(query_594658, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594656.call(path_594657, query_594658, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_594640(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_594641,
    base: "/storage/v1", url: url_StorageObjectAccessControlsList_594642,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_594700 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsUpdate_594702(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsUpdate_594701(path: JsonNode;
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594703 = path.getOrDefault("bucket")
  valid_594703 = validateParameter(valid_594703, JString, required = true,
                                 default = nil)
  if valid_594703 != nil:
    section.add "bucket", valid_594703
  var valid_594704 = path.getOrDefault("entity")
  valid_594704 = validateParameter(valid_594704, JString, required = true,
                                 default = nil)
  if valid_594704 != nil:
    section.add "entity", valid_594704
  var valid_594705 = path.getOrDefault("object")
  valid_594705 = validateParameter(valid_594705, JString, required = true,
                                 default = nil)
  if valid_594705 != nil:
    section.add "object", valid_594705
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594706 = query.getOrDefault("fields")
  valid_594706 = validateParameter(valid_594706, JString, required = false,
                                 default = nil)
  if valid_594706 != nil:
    section.add "fields", valid_594706
  var valid_594707 = query.getOrDefault("quotaUser")
  valid_594707 = validateParameter(valid_594707, JString, required = false,
                                 default = nil)
  if valid_594707 != nil:
    section.add "quotaUser", valid_594707
  var valid_594708 = query.getOrDefault("alt")
  valid_594708 = validateParameter(valid_594708, JString, required = false,
                                 default = newJString("json"))
  if valid_594708 != nil:
    section.add "alt", valid_594708
  var valid_594709 = query.getOrDefault("oauth_token")
  valid_594709 = validateParameter(valid_594709, JString, required = false,
                                 default = nil)
  if valid_594709 != nil:
    section.add "oauth_token", valid_594709
  var valid_594710 = query.getOrDefault("userIp")
  valid_594710 = validateParameter(valid_594710, JString, required = false,
                                 default = nil)
  if valid_594710 != nil:
    section.add "userIp", valid_594710
  var valid_594711 = query.getOrDefault("userProject")
  valid_594711 = validateParameter(valid_594711, JString, required = false,
                                 default = nil)
  if valid_594711 != nil:
    section.add "userProject", valid_594711
  var valid_594712 = query.getOrDefault("key")
  valid_594712 = validateParameter(valid_594712, JString, required = false,
                                 default = nil)
  if valid_594712 != nil:
    section.add "key", valid_594712
  var valid_594713 = query.getOrDefault("generation")
  valid_594713 = validateParameter(valid_594713, JString, required = false,
                                 default = nil)
  if valid_594713 != nil:
    section.add "generation", valid_594713
  var valid_594714 = query.getOrDefault("prettyPrint")
  valid_594714 = validateParameter(valid_594714, JBool, required = false,
                                 default = newJBool(true))
  if valid_594714 != nil:
    section.add "prettyPrint", valid_594714
  var valid_594715 = query.getOrDefault("provisionalUserProject")
  valid_594715 = validateParameter(valid_594715, JString, required = false,
                                 default = nil)
  if valid_594715 != nil:
    section.add "provisionalUserProject", valid_594715
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

proc call*(call_594717: Call_StorageObjectAccessControlsUpdate_594700;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_594717.validator(path, query, header, formData, body)
  let scheme = call_594717.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594717.url(scheme.get, call_594717.host, call_594717.base,
                         call_594717.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594717, url, valid)

proc call*(call_594718: Call_StorageObjectAccessControlsUpdate_594700;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          generation: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594719 = newJObject()
  var query_594720 = newJObject()
  var body_594721 = newJObject()
  add(path_594719, "bucket", newJString(bucket))
  add(query_594720, "fields", newJString(fields))
  add(query_594720, "quotaUser", newJString(quotaUser))
  add(query_594720, "alt", newJString(alt))
  add(query_594720, "oauth_token", newJString(oauthToken))
  add(query_594720, "userIp", newJString(userIp))
  add(query_594720, "userProject", newJString(userProject))
  add(query_594720, "key", newJString(key))
  add(query_594720, "generation", newJString(generation))
  if body != nil:
    body_594721 = body
  add(query_594720, "prettyPrint", newJBool(prettyPrint))
  add(path_594719, "entity", newJString(entity))
  add(path_594719, "object", newJString(`object`))
  add(query_594720, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594718.call(path_594719, query_594720, nil, nil, body_594721)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_594700(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_594701,
    base: "/storage/v1", url: url_StorageObjectAccessControlsUpdate_594702,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_594680 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsGet_594682(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsGet_594681(path: JsonNode;
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594683 = path.getOrDefault("bucket")
  valid_594683 = validateParameter(valid_594683, JString, required = true,
                                 default = nil)
  if valid_594683 != nil:
    section.add "bucket", valid_594683
  var valid_594684 = path.getOrDefault("entity")
  valid_594684 = validateParameter(valid_594684, JString, required = true,
                                 default = nil)
  if valid_594684 != nil:
    section.add "entity", valid_594684
  var valid_594685 = path.getOrDefault("object")
  valid_594685 = validateParameter(valid_594685, JString, required = true,
                                 default = nil)
  if valid_594685 != nil:
    section.add "object", valid_594685
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594686 = query.getOrDefault("fields")
  valid_594686 = validateParameter(valid_594686, JString, required = false,
                                 default = nil)
  if valid_594686 != nil:
    section.add "fields", valid_594686
  var valid_594687 = query.getOrDefault("quotaUser")
  valid_594687 = validateParameter(valid_594687, JString, required = false,
                                 default = nil)
  if valid_594687 != nil:
    section.add "quotaUser", valid_594687
  var valid_594688 = query.getOrDefault("alt")
  valid_594688 = validateParameter(valid_594688, JString, required = false,
                                 default = newJString("json"))
  if valid_594688 != nil:
    section.add "alt", valid_594688
  var valid_594689 = query.getOrDefault("oauth_token")
  valid_594689 = validateParameter(valid_594689, JString, required = false,
                                 default = nil)
  if valid_594689 != nil:
    section.add "oauth_token", valid_594689
  var valid_594690 = query.getOrDefault("userIp")
  valid_594690 = validateParameter(valid_594690, JString, required = false,
                                 default = nil)
  if valid_594690 != nil:
    section.add "userIp", valid_594690
  var valid_594691 = query.getOrDefault("userProject")
  valid_594691 = validateParameter(valid_594691, JString, required = false,
                                 default = nil)
  if valid_594691 != nil:
    section.add "userProject", valid_594691
  var valid_594692 = query.getOrDefault("key")
  valid_594692 = validateParameter(valid_594692, JString, required = false,
                                 default = nil)
  if valid_594692 != nil:
    section.add "key", valid_594692
  var valid_594693 = query.getOrDefault("generation")
  valid_594693 = validateParameter(valid_594693, JString, required = false,
                                 default = nil)
  if valid_594693 != nil:
    section.add "generation", valid_594693
  var valid_594694 = query.getOrDefault("prettyPrint")
  valid_594694 = validateParameter(valid_594694, JBool, required = false,
                                 default = newJBool(true))
  if valid_594694 != nil:
    section.add "prettyPrint", valid_594694
  var valid_594695 = query.getOrDefault("provisionalUserProject")
  valid_594695 = validateParameter(valid_594695, JString, required = false,
                                 default = nil)
  if valid_594695 != nil:
    section.add "provisionalUserProject", valid_594695
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594696: Call_StorageObjectAccessControlsGet_594680; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_594696.validator(path, query, header, formData, body)
  let scheme = call_594696.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594696.url(scheme.get, call_594696.host, call_594696.base,
                         call_594696.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594696, url, valid)

proc call*(call_594697: Call_StorageObjectAccessControlsGet_594680; bucket: string;
          entity: string; `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594698 = newJObject()
  var query_594699 = newJObject()
  add(path_594698, "bucket", newJString(bucket))
  add(query_594699, "fields", newJString(fields))
  add(query_594699, "quotaUser", newJString(quotaUser))
  add(query_594699, "alt", newJString(alt))
  add(query_594699, "oauth_token", newJString(oauthToken))
  add(query_594699, "userIp", newJString(userIp))
  add(query_594699, "userProject", newJString(userProject))
  add(query_594699, "key", newJString(key))
  add(query_594699, "generation", newJString(generation))
  add(query_594699, "prettyPrint", newJBool(prettyPrint))
  add(path_594698, "entity", newJString(entity))
  add(path_594698, "object", newJString(`object`))
  add(query_594699, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594697.call(path_594698, query_594699, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_594680(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_594681,
    base: "/storage/v1", url: url_StorageObjectAccessControlsGet_594682,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_594742 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsPatch_594744(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsPatch_594743(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Patches an ACL entry on the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of a bucket.
  ##   entity: JString (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594745 = path.getOrDefault("bucket")
  valid_594745 = validateParameter(valid_594745, JString, required = true,
                                 default = nil)
  if valid_594745 != nil:
    section.add "bucket", valid_594745
  var valid_594746 = path.getOrDefault("entity")
  valid_594746 = validateParameter(valid_594746, JString, required = true,
                                 default = nil)
  if valid_594746 != nil:
    section.add "entity", valid_594746
  var valid_594747 = path.getOrDefault("object")
  valid_594747 = validateParameter(valid_594747, JString, required = true,
                                 default = nil)
  if valid_594747 != nil:
    section.add "object", valid_594747
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594748 = query.getOrDefault("fields")
  valid_594748 = validateParameter(valid_594748, JString, required = false,
                                 default = nil)
  if valid_594748 != nil:
    section.add "fields", valid_594748
  var valid_594749 = query.getOrDefault("quotaUser")
  valid_594749 = validateParameter(valid_594749, JString, required = false,
                                 default = nil)
  if valid_594749 != nil:
    section.add "quotaUser", valid_594749
  var valid_594750 = query.getOrDefault("alt")
  valid_594750 = validateParameter(valid_594750, JString, required = false,
                                 default = newJString("json"))
  if valid_594750 != nil:
    section.add "alt", valid_594750
  var valid_594751 = query.getOrDefault("oauth_token")
  valid_594751 = validateParameter(valid_594751, JString, required = false,
                                 default = nil)
  if valid_594751 != nil:
    section.add "oauth_token", valid_594751
  var valid_594752 = query.getOrDefault("userIp")
  valid_594752 = validateParameter(valid_594752, JString, required = false,
                                 default = nil)
  if valid_594752 != nil:
    section.add "userIp", valid_594752
  var valid_594753 = query.getOrDefault("userProject")
  valid_594753 = validateParameter(valid_594753, JString, required = false,
                                 default = nil)
  if valid_594753 != nil:
    section.add "userProject", valid_594753
  var valid_594754 = query.getOrDefault("key")
  valid_594754 = validateParameter(valid_594754, JString, required = false,
                                 default = nil)
  if valid_594754 != nil:
    section.add "key", valid_594754
  var valid_594755 = query.getOrDefault("generation")
  valid_594755 = validateParameter(valid_594755, JString, required = false,
                                 default = nil)
  if valid_594755 != nil:
    section.add "generation", valid_594755
  var valid_594756 = query.getOrDefault("prettyPrint")
  valid_594756 = validateParameter(valid_594756, JBool, required = false,
                                 default = newJBool(true))
  if valid_594756 != nil:
    section.add "prettyPrint", valid_594756
  var valid_594757 = query.getOrDefault("provisionalUserProject")
  valid_594757 = validateParameter(valid_594757, JString, required = false,
                                 default = nil)
  if valid_594757 != nil:
    section.add "provisionalUserProject", valid_594757
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

proc call*(call_594759: Call_StorageObjectAccessControlsPatch_594742;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified object.
  ## 
  let valid = call_594759.validator(path, query, header, formData, body)
  let scheme = call_594759.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594759.url(scheme.get, call_594759.host, call_594759.base,
                         call_594759.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594759, url, valid)

proc call*(call_594760: Call_StorageObjectAccessControlsPatch_594742;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          generation: string = ""; body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectAccessControlsPatch
  ## Patches an ACL entry on the specified object.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594761 = newJObject()
  var query_594762 = newJObject()
  var body_594763 = newJObject()
  add(path_594761, "bucket", newJString(bucket))
  add(query_594762, "fields", newJString(fields))
  add(query_594762, "quotaUser", newJString(quotaUser))
  add(query_594762, "alt", newJString(alt))
  add(query_594762, "oauth_token", newJString(oauthToken))
  add(query_594762, "userIp", newJString(userIp))
  add(query_594762, "userProject", newJString(userProject))
  add(query_594762, "key", newJString(key))
  add(query_594762, "generation", newJString(generation))
  if body != nil:
    body_594763 = body
  add(query_594762, "prettyPrint", newJBool(prettyPrint))
  add(path_594761, "entity", newJString(entity))
  add(path_594761, "object", newJString(`object`))
  add(query_594762, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594760.call(path_594761, query_594762, nil, nil, body_594763)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_594742(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_594743,
    base: "/storage/v1", url: url_StorageObjectAccessControlsPatch_594744,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_594722 = ref object of OpenApiRestCall_593424
proc url_StorageObjectAccessControlsDelete_594724(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsDelete_594723(path: JsonNode;
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
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594725 = path.getOrDefault("bucket")
  valid_594725 = validateParameter(valid_594725, JString, required = true,
                                 default = nil)
  if valid_594725 != nil:
    section.add "bucket", valid_594725
  var valid_594726 = path.getOrDefault("entity")
  valid_594726 = validateParameter(valid_594726, JString, required = true,
                                 default = nil)
  if valid_594726 != nil:
    section.add "entity", valid_594726
  var valid_594727 = path.getOrDefault("object")
  valid_594727 = validateParameter(valid_594727, JString, required = true,
                                 default = nil)
  if valid_594727 != nil:
    section.add "object", valid_594727
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594728 = query.getOrDefault("fields")
  valid_594728 = validateParameter(valid_594728, JString, required = false,
                                 default = nil)
  if valid_594728 != nil:
    section.add "fields", valid_594728
  var valid_594729 = query.getOrDefault("quotaUser")
  valid_594729 = validateParameter(valid_594729, JString, required = false,
                                 default = nil)
  if valid_594729 != nil:
    section.add "quotaUser", valid_594729
  var valid_594730 = query.getOrDefault("alt")
  valid_594730 = validateParameter(valid_594730, JString, required = false,
                                 default = newJString("json"))
  if valid_594730 != nil:
    section.add "alt", valid_594730
  var valid_594731 = query.getOrDefault("oauth_token")
  valid_594731 = validateParameter(valid_594731, JString, required = false,
                                 default = nil)
  if valid_594731 != nil:
    section.add "oauth_token", valid_594731
  var valid_594732 = query.getOrDefault("userIp")
  valid_594732 = validateParameter(valid_594732, JString, required = false,
                                 default = nil)
  if valid_594732 != nil:
    section.add "userIp", valid_594732
  var valid_594733 = query.getOrDefault("userProject")
  valid_594733 = validateParameter(valid_594733, JString, required = false,
                                 default = nil)
  if valid_594733 != nil:
    section.add "userProject", valid_594733
  var valid_594734 = query.getOrDefault("key")
  valid_594734 = validateParameter(valid_594734, JString, required = false,
                                 default = nil)
  if valid_594734 != nil:
    section.add "key", valid_594734
  var valid_594735 = query.getOrDefault("generation")
  valid_594735 = validateParameter(valid_594735, JString, required = false,
                                 default = nil)
  if valid_594735 != nil:
    section.add "generation", valid_594735
  var valid_594736 = query.getOrDefault("prettyPrint")
  valid_594736 = validateParameter(valid_594736, JBool, required = false,
                                 default = newJBool(true))
  if valid_594736 != nil:
    section.add "prettyPrint", valid_594736
  var valid_594737 = query.getOrDefault("provisionalUserProject")
  valid_594737 = validateParameter(valid_594737, JString, required = false,
                                 default = nil)
  if valid_594737 != nil:
    section.add "provisionalUserProject", valid_594737
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594738: Call_StorageObjectAccessControlsDelete_594722;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_594738.validator(path, query, header, formData, body)
  let scheme = call_594738.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594738.url(scheme.get, call_594738.host, call_594738.base,
                         call_594738.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594738, url, valid)

proc call*(call_594739: Call_StorageObjectAccessControlsDelete_594722;
          bucket: string; entity: string; `object`: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          generation: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   entity: string (required)
  ##         : The entity holding the permission. Can be user-userId, user-emailAddress, group-groupId, group-emailAddress, allUsers, or allAuthenticatedUsers.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594740 = newJObject()
  var query_594741 = newJObject()
  add(path_594740, "bucket", newJString(bucket))
  add(query_594741, "fields", newJString(fields))
  add(query_594741, "quotaUser", newJString(quotaUser))
  add(query_594741, "alt", newJString(alt))
  add(query_594741, "oauth_token", newJString(oauthToken))
  add(query_594741, "userIp", newJString(userIp))
  add(query_594741, "userProject", newJString(userProject))
  add(query_594741, "key", newJString(key))
  add(query_594741, "generation", newJString(generation))
  add(query_594741, "prettyPrint", newJBool(prettyPrint))
  add(path_594740, "entity", newJString(entity))
  add(path_594740, "object", newJString(`object`))
  add(query_594741, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594739.call(path_594740, query_594741, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_594722(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_594723,
    base: "/storage/v1", url: url_StorageObjectAccessControlsDelete_594724,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsSetIamPolicy_594783 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsSetIamPolicy_594785(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsSetIamPolicy_594784(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594786 = path.getOrDefault("bucket")
  valid_594786 = validateParameter(valid_594786, JString, required = true,
                                 default = nil)
  if valid_594786 != nil:
    section.add "bucket", valid_594786
  var valid_594787 = path.getOrDefault("object")
  valid_594787 = validateParameter(valid_594787, JString, required = true,
                                 default = nil)
  if valid_594787 != nil:
    section.add "object", valid_594787
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594788 = query.getOrDefault("fields")
  valid_594788 = validateParameter(valid_594788, JString, required = false,
                                 default = nil)
  if valid_594788 != nil:
    section.add "fields", valid_594788
  var valid_594789 = query.getOrDefault("quotaUser")
  valid_594789 = validateParameter(valid_594789, JString, required = false,
                                 default = nil)
  if valid_594789 != nil:
    section.add "quotaUser", valid_594789
  var valid_594790 = query.getOrDefault("alt")
  valid_594790 = validateParameter(valid_594790, JString, required = false,
                                 default = newJString("json"))
  if valid_594790 != nil:
    section.add "alt", valid_594790
  var valid_594791 = query.getOrDefault("oauth_token")
  valid_594791 = validateParameter(valid_594791, JString, required = false,
                                 default = nil)
  if valid_594791 != nil:
    section.add "oauth_token", valid_594791
  var valid_594792 = query.getOrDefault("userIp")
  valid_594792 = validateParameter(valid_594792, JString, required = false,
                                 default = nil)
  if valid_594792 != nil:
    section.add "userIp", valid_594792
  var valid_594793 = query.getOrDefault("userProject")
  valid_594793 = validateParameter(valid_594793, JString, required = false,
                                 default = nil)
  if valid_594793 != nil:
    section.add "userProject", valid_594793
  var valid_594794 = query.getOrDefault("key")
  valid_594794 = validateParameter(valid_594794, JString, required = false,
                                 default = nil)
  if valid_594794 != nil:
    section.add "key", valid_594794
  var valid_594795 = query.getOrDefault("generation")
  valid_594795 = validateParameter(valid_594795, JString, required = false,
                                 default = nil)
  if valid_594795 != nil:
    section.add "generation", valid_594795
  var valid_594796 = query.getOrDefault("prettyPrint")
  valid_594796 = validateParameter(valid_594796, JBool, required = false,
                                 default = newJBool(true))
  if valid_594796 != nil:
    section.add "prettyPrint", valid_594796
  var valid_594797 = query.getOrDefault("provisionalUserProject")
  valid_594797 = validateParameter(valid_594797, JString, required = false,
                                 default = nil)
  if valid_594797 != nil:
    section.add "provisionalUserProject", valid_594797
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

proc call*(call_594799: Call_StorageObjectsSetIamPolicy_594783; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified object.
  ## 
  let valid = call_594799.validator(path, query, header, formData, body)
  let scheme = call_594799.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594799.url(scheme.get, call_594799.host, call_594799.base,
                         call_594799.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594799, url, valid)

proc call*(call_594800: Call_StorageObjectsSetIamPolicy_594783; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          body: JsonNode = nil; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsSetIamPolicy
  ## Updates an IAM policy for the specified object.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594801 = newJObject()
  var query_594802 = newJObject()
  var body_594803 = newJObject()
  add(path_594801, "bucket", newJString(bucket))
  add(query_594802, "fields", newJString(fields))
  add(query_594802, "quotaUser", newJString(quotaUser))
  add(query_594802, "alt", newJString(alt))
  add(query_594802, "oauth_token", newJString(oauthToken))
  add(query_594802, "userIp", newJString(userIp))
  add(query_594802, "userProject", newJString(userProject))
  add(query_594802, "key", newJString(key))
  add(query_594802, "generation", newJString(generation))
  if body != nil:
    body_594803 = body
  add(query_594802, "prettyPrint", newJBool(prettyPrint))
  add(path_594801, "object", newJString(`object`))
  add(query_594802, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594800.call(path_594801, query_594802, nil, nil, body_594803)

var storageObjectsSetIamPolicy* = Call_StorageObjectsSetIamPolicy_594783(
    name: "storageObjectsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsSetIamPolicy_594784, base: "/storage/v1",
    url: url_StorageObjectsSetIamPolicy_594785, schemes: {Scheme.Https})
type
  Call_StorageObjectsGetIamPolicy_594764 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsGetIamPolicy_594766(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsGetIamPolicy_594765(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Returns an IAM policy for the specified object.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594767 = path.getOrDefault("bucket")
  valid_594767 = validateParameter(valid_594767, JString, required = true,
                                 default = nil)
  if valid_594767 != nil:
    section.add "bucket", valid_594767
  var valid_594768 = path.getOrDefault("object")
  valid_594768 = validateParameter(valid_594768, JString, required = true,
                                 default = nil)
  if valid_594768 != nil:
    section.add "object", valid_594768
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594769 = query.getOrDefault("fields")
  valid_594769 = validateParameter(valid_594769, JString, required = false,
                                 default = nil)
  if valid_594769 != nil:
    section.add "fields", valid_594769
  var valid_594770 = query.getOrDefault("quotaUser")
  valid_594770 = validateParameter(valid_594770, JString, required = false,
                                 default = nil)
  if valid_594770 != nil:
    section.add "quotaUser", valid_594770
  var valid_594771 = query.getOrDefault("alt")
  valid_594771 = validateParameter(valid_594771, JString, required = false,
                                 default = newJString("json"))
  if valid_594771 != nil:
    section.add "alt", valid_594771
  var valid_594772 = query.getOrDefault("oauth_token")
  valid_594772 = validateParameter(valid_594772, JString, required = false,
                                 default = nil)
  if valid_594772 != nil:
    section.add "oauth_token", valid_594772
  var valid_594773 = query.getOrDefault("userIp")
  valid_594773 = validateParameter(valid_594773, JString, required = false,
                                 default = nil)
  if valid_594773 != nil:
    section.add "userIp", valid_594773
  var valid_594774 = query.getOrDefault("userProject")
  valid_594774 = validateParameter(valid_594774, JString, required = false,
                                 default = nil)
  if valid_594774 != nil:
    section.add "userProject", valid_594774
  var valid_594775 = query.getOrDefault("key")
  valid_594775 = validateParameter(valid_594775, JString, required = false,
                                 default = nil)
  if valid_594775 != nil:
    section.add "key", valid_594775
  var valid_594776 = query.getOrDefault("generation")
  valid_594776 = validateParameter(valid_594776, JString, required = false,
                                 default = nil)
  if valid_594776 != nil:
    section.add "generation", valid_594776
  var valid_594777 = query.getOrDefault("prettyPrint")
  valid_594777 = validateParameter(valid_594777, JBool, required = false,
                                 default = newJBool(true))
  if valid_594777 != nil:
    section.add "prettyPrint", valid_594777
  var valid_594778 = query.getOrDefault("provisionalUserProject")
  valid_594778 = validateParameter(valid_594778, JString, required = false,
                                 default = nil)
  if valid_594778 != nil:
    section.add "provisionalUserProject", valid_594778
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594779: Call_StorageObjectsGetIamPolicy_594764; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified object.
  ## 
  let valid = call_594779.validator(path, query, header, formData, body)
  let scheme = call_594779.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594779.url(scheme.get, call_594779.host, call_594779.base,
                         call_594779.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594779, url, valid)

proc call*(call_594780: Call_StorageObjectsGetIamPolicy_594764; bucket: string;
          `object`: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; generation: string = "";
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsGetIamPolicy
  ## Returns an IAM policy for the specified object.
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
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594781 = newJObject()
  var query_594782 = newJObject()
  add(path_594781, "bucket", newJString(bucket))
  add(query_594782, "fields", newJString(fields))
  add(query_594782, "quotaUser", newJString(quotaUser))
  add(query_594782, "alt", newJString(alt))
  add(query_594782, "oauth_token", newJString(oauthToken))
  add(query_594782, "userIp", newJString(userIp))
  add(query_594782, "userProject", newJString(userProject))
  add(query_594782, "key", newJString(key))
  add(query_594782, "generation", newJString(generation))
  add(query_594782, "prettyPrint", newJBool(prettyPrint))
  add(path_594781, "object", newJString(`object`))
  add(query_594782, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594780.call(path_594781, query_594782, nil, nil, nil)

var storageObjectsGetIamPolicy* = Call_StorageObjectsGetIamPolicy_594764(
    name: "storageObjectsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsGetIamPolicy_594765, base: "/storage/v1",
    url: url_StorageObjectsGetIamPolicy_594766, schemes: {Scheme.Https})
type
  Call_StorageObjectsTestIamPermissions_594804 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsTestIamPermissions_594806(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsTestIamPermissions_594805(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   bucket: JString (required)
  ##         : Name of the bucket in which the object resides.
  ##   object: JString (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `bucket` field"
  var valid_594807 = path.getOrDefault("bucket")
  valid_594807 = validateParameter(valid_594807, JString, required = true,
                                 default = nil)
  if valid_594807 != nil:
    section.add "bucket", valid_594807
  var valid_594808 = path.getOrDefault("object")
  valid_594808 = validateParameter(valid_594808, JString, required = true,
                                 default = nil)
  if valid_594808 != nil:
    section.add "object", valid_594808
  result.add "path", section
  ## parameters in `query` object:
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: JString
  ##      : Data format for the response.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: JString
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594809 = query.getOrDefault("fields")
  valid_594809 = validateParameter(valid_594809, JString, required = false,
                                 default = nil)
  if valid_594809 != nil:
    section.add "fields", valid_594809
  var valid_594810 = query.getOrDefault("quotaUser")
  valid_594810 = validateParameter(valid_594810, JString, required = false,
                                 default = nil)
  if valid_594810 != nil:
    section.add "quotaUser", valid_594810
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_594811 = query.getOrDefault("permissions")
  valid_594811 = validateParameter(valid_594811, JArray, required = true, default = nil)
  if valid_594811 != nil:
    section.add "permissions", valid_594811
  var valid_594812 = query.getOrDefault("alt")
  valid_594812 = validateParameter(valid_594812, JString, required = false,
                                 default = newJString("json"))
  if valid_594812 != nil:
    section.add "alt", valid_594812
  var valid_594813 = query.getOrDefault("oauth_token")
  valid_594813 = validateParameter(valid_594813, JString, required = false,
                                 default = nil)
  if valid_594813 != nil:
    section.add "oauth_token", valid_594813
  var valid_594814 = query.getOrDefault("userIp")
  valid_594814 = validateParameter(valid_594814, JString, required = false,
                                 default = nil)
  if valid_594814 != nil:
    section.add "userIp", valid_594814
  var valid_594815 = query.getOrDefault("userProject")
  valid_594815 = validateParameter(valid_594815, JString, required = false,
                                 default = nil)
  if valid_594815 != nil:
    section.add "userProject", valid_594815
  var valid_594816 = query.getOrDefault("key")
  valid_594816 = validateParameter(valid_594816, JString, required = false,
                                 default = nil)
  if valid_594816 != nil:
    section.add "key", valid_594816
  var valid_594817 = query.getOrDefault("generation")
  valid_594817 = validateParameter(valid_594817, JString, required = false,
                                 default = nil)
  if valid_594817 != nil:
    section.add "generation", valid_594817
  var valid_594818 = query.getOrDefault("prettyPrint")
  valid_594818 = validateParameter(valid_594818, JBool, required = false,
                                 default = newJBool(true))
  if valid_594818 != nil:
    section.add "prettyPrint", valid_594818
  var valid_594819 = query.getOrDefault("provisionalUserProject")
  valid_594819 = validateParameter(valid_594819, JString, required = false,
                                 default = nil)
  if valid_594819 != nil:
    section.add "provisionalUserProject", valid_594819
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594820: Call_StorageObjectsTestIamPermissions_594804;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  let valid = call_594820.validator(path, query, header, formData, body)
  let scheme = call_594820.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594820.url(scheme.get, call_594820.host, call_594820.base,
                         call_594820.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594820, url, valid)

proc call*(call_594821: Call_StorageObjectsTestIamPermissions_594804;
          bucket: string; permissions: JsonNode; `object`: string;
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          oauthToken: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; generation: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsTestIamPermissions
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ##   bucket: string (required)
  ##         : Name of the bucket in which the object resides.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   permissions: JArray (required)
  ##              : Permissions to test.
  ##   alt: string
  ##      : Data format for the response.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   generation: string
  ##             : If present, selects a specific revision of this object (as opposed to the latest version, the default).
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   object: string (required)
  ##         : Name of the object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594822 = newJObject()
  var query_594823 = newJObject()
  add(path_594822, "bucket", newJString(bucket))
  add(query_594823, "fields", newJString(fields))
  add(query_594823, "quotaUser", newJString(quotaUser))
  if permissions != nil:
    query_594823.add "permissions", permissions
  add(query_594823, "alt", newJString(alt))
  add(query_594823, "oauth_token", newJString(oauthToken))
  add(query_594823, "userIp", newJString(userIp))
  add(query_594823, "userProject", newJString(userProject))
  add(query_594823, "key", newJString(key))
  add(query_594823, "generation", newJString(generation))
  add(query_594823, "prettyPrint", newJBool(prettyPrint))
  add(path_594822, "object", newJString(`object`))
  add(query_594823, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594821.call(path_594822, query_594823, nil, nil, nil)

var storageObjectsTestIamPermissions* = Call_StorageObjectsTestIamPermissions_594804(
    name: "storageObjectsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}/iam/testPermissions",
    validator: validate_StorageObjectsTestIamPermissions_594805,
    base: "/storage/v1", url: url_StorageObjectsTestIamPermissions_594806,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_594824 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsCompose_594826(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsCompose_594825(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket containing the source objects. The destination object is stored in this bucket.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_594827 = path.getOrDefault("destinationBucket")
  valid_594827 = validateParameter(valid_594827, JString, required = true,
                                 default = nil)
  if valid_594827 != nil:
    section.add "destinationBucket", valid_594827
  var valid_594828 = path.getOrDefault("destinationObject")
  valid_594828 = validateParameter(valid_594828, JString, required = true,
                                 default = nil)
  if valid_594828 != nil:
    section.add "destinationObject", valid_594828
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   kmsKeyName: JString
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
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
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594829 = query.getOrDefault("ifGenerationMatch")
  valid_594829 = validateParameter(valid_594829, JString, required = false,
                                 default = nil)
  if valid_594829 != nil:
    section.add "ifGenerationMatch", valid_594829
  var valid_594830 = query.getOrDefault("kmsKeyName")
  valid_594830 = validateParameter(valid_594830, JString, required = false,
                                 default = nil)
  if valid_594830 != nil:
    section.add "kmsKeyName", valid_594830
  var valid_594831 = query.getOrDefault("fields")
  valid_594831 = validateParameter(valid_594831, JString, required = false,
                                 default = nil)
  if valid_594831 != nil:
    section.add "fields", valid_594831
  var valid_594832 = query.getOrDefault("quotaUser")
  valid_594832 = validateParameter(valid_594832, JString, required = false,
                                 default = nil)
  if valid_594832 != nil:
    section.add "quotaUser", valid_594832
  var valid_594833 = query.getOrDefault("alt")
  valid_594833 = validateParameter(valid_594833, JString, required = false,
                                 default = newJString("json"))
  if valid_594833 != nil:
    section.add "alt", valid_594833
  var valid_594834 = query.getOrDefault("oauth_token")
  valid_594834 = validateParameter(valid_594834, JString, required = false,
                                 default = nil)
  if valid_594834 != nil:
    section.add "oauth_token", valid_594834
  var valid_594835 = query.getOrDefault("userIp")
  valid_594835 = validateParameter(valid_594835, JString, required = false,
                                 default = nil)
  if valid_594835 != nil:
    section.add "userIp", valid_594835
  var valid_594836 = query.getOrDefault("userProject")
  valid_594836 = validateParameter(valid_594836, JString, required = false,
                                 default = nil)
  if valid_594836 != nil:
    section.add "userProject", valid_594836
  var valid_594837 = query.getOrDefault("key")
  valid_594837 = validateParameter(valid_594837, JString, required = false,
                                 default = nil)
  if valid_594837 != nil:
    section.add "key", valid_594837
  var valid_594838 = query.getOrDefault("destinationPredefinedAcl")
  valid_594838 = validateParameter(valid_594838, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594838 != nil:
    section.add "destinationPredefinedAcl", valid_594838
  var valid_594839 = query.getOrDefault("ifMetagenerationMatch")
  valid_594839 = validateParameter(valid_594839, JString, required = false,
                                 default = nil)
  if valid_594839 != nil:
    section.add "ifMetagenerationMatch", valid_594839
  var valid_594840 = query.getOrDefault("prettyPrint")
  valid_594840 = validateParameter(valid_594840, JBool, required = false,
                                 default = newJBool(true))
  if valid_594840 != nil:
    section.add "prettyPrint", valid_594840
  var valid_594841 = query.getOrDefault("provisionalUserProject")
  valid_594841 = validateParameter(valid_594841, JString, required = false,
                                 default = nil)
  if valid_594841 != nil:
    section.add "provisionalUserProject", valid_594841
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

proc call*(call_594843: Call_StorageObjectsCompose_594824; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_594843.validator(path, query, header, formData, body)
  let scheme = call_594843.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594843.url(scheme.get, call_594843.host, call_594843.base,
                         call_594843.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594843, url, valid)

proc call*(call_594844: Call_StorageObjectsCompose_594824;
          destinationBucket: string; destinationObject: string;
          ifGenerationMatch: string = ""; kmsKeyName: string = ""; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          destinationPredefinedAcl: string = "authenticatedRead";
          ifMetagenerationMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsCompose
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   kmsKeyName: string
  ##             : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
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
  ##                    : Name of the new object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the object's current metageneration matches the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594845 = newJObject()
  var query_594846 = newJObject()
  var body_594847 = newJObject()
  add(query_594846, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_594846, "kmsKeyName", newJString(kmsKeyName))
  add(query_594846, "fields", newJString(fields))
  add(query_594846, "quotaUser", newJString(quotaUser))
  add(query_594846, "alt", newJString(alt))
  add(query_594846, "oauth_token", newJString(oauthToken))
  add(path_594845, "destinationBucket", newJString(destinationBucket))
  add(query_594846, "userIp", newJString(userIp))
  add(path_594845, "destinationObject", newJString(destinationObject))
  add(query_594846, "userProject", newJString(userProject))
  add(query_594846, "key", newJString(key))
  add(query_594846, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_594846, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_594847 = body
  add(query_594846, "prettyPrint", newJBool(prettyPrint))
  add(query_594846, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594844.call(path_594845, query_594846, nil, nil, body_594847)

var storageObjectsCompose* = Call_StorageObjectsCompose_594824(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_594825, base: "/storage/v1",
    url: url_StorageObjectsCompose_594826, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_594848 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsCopy_594850(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsCopy_594849(path: JsonNode; query: JsonNode;
                                       header: JsonNode; formData: JsonNode;
                                       body: JsonNode): JsonNode =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_594851 = path.getOrDefault("destinationBucket")
  valid_594851 = validateParameter(valid_594851, JString, required = true,
                                 default = nil)
  if valid_594851 != nil:
    section.add "destinationBucket", valid_594851
  var valid_594852 = path.getOrDefault("destinationObject")
  valid_594852 = validateParameter(valid_594852, JString, required = true,
                                 default = nil)
  if valid_594852 != nil:
    section.add "destinationObject", valid_594852
  var valid_594853 = path.getOrDefault("sourceBucket")
  valid_594853 = validateParameter(valid_594853, JString, required = true,
                                 default = nil)
  if valid_594853 != nil:
    section.add "sourceBucket", valid_594853
  var valid_594854 = path.getOrDefault("sourceObject")
  valid_594854 = validateParameter(valid_594854, JString, required = true,
                                 default = nil)
  if valid_594854 != nil:
    section.add "sourceObject", valid_594854
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594855 = query.getOrDefault("ifGenerationMatch")
  valid_594855 = validateParameter(valid_594855, JString, required = false,
                                 default = nil)
  if valid_594855 != nil:
    section.add "ifGenerationMatch", valid_594855
  var valid_594856 = query.getOrDefault("ifSourceGenerationMatch")
  valid_594856 = validateParameter(valid_594856, JString, required = false,
                                 default = nil)
  if valid_594856 != nil:
    section.add "ifSourceGenerationMatch", valid_594856
  var valid_594857 = query.getOrDefault("fields")
  valid_594857 = validateParameter(valid_594857, JString, required = false,
                                 default = nil)
  if valid_594857 != nil:
    section.add "fields", valid_594857
  var valid_594858 = query.getOrDefault("quotaUser")
  valid_594858 = validateParameter(valid_594858, JString, required = false,
                                 default = nil)
  if valid_594858 != nil:
    section.add "quotaUser", valid_594858
  var valid_594859 = query.getOrDefault("alt")
  valid_594859 = validateParameter(valid_594859, JString, required = false,
                                 default = newJString("json"))
  if valid_594859 != nil:
    section.add "alt", valid_594859
  var valid_594860 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_594860 = validateParameter(valid_594860, JString, required = false,
                                 default = nil)
  if valid_594860 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_594860
  var valid_594861 = query.getOrDefault("ifGenerationNotMatch")
  valid_594861 = validateParameter(valid_594861, JString, required = false,
                                 default = nil)
  if valid_594861 != nil:
    section.add "ifGenerationNotMatch", valid_594861
  var valid_594862 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_594862 = validateParameter(valid_594862, JString, required = false,
                                 default = nil)
  if valid_594862 != nil:
    section.add "ifSourceMetagenerationMatch", valid_594862
  var valid_594863 = query.getOrDefault("oauth_token")
  valid_594863 = validateParameter(valid_594863, JString, required = false,
                                 default = nil)
  if valid_594863 != nil:
    section.add "oauth_token", valid_594863
  var valid_594864 = query.getOrDefault("sourceGeneration")
  valid_594864 = validateParameter(valid_594864, JString, required = false,
                                 default = nil)
  if valid_594864 != nil:
    section.add "sourceGeneration", valid_594864
  var valid_594865 = query.getOrDefault("userIp")
  valid_594865 = validateParameter(valid_594865, JString, required = false,
                                 default = nil)
  if valid_594865 != nil:
    section.add "userIp", valid_594865
  var valid_594866 = query.getOrDefault("userProject")
  valid_594866 = validateParameter(valid_594866, JString, required = false,
                                 default = nil)
  if valid_594866 != nil:
    section.add "userProject", valid_594866
  var valid_594867 = query.getOrDefault("key")
  valid_594867 = validateParameter(valid_594867, JString, required = false,
                                 default = nil)
  if valid_594867 != nil:
    section.add "key", valid_594867
  var valid_594868 = query.getOrDefault("projection")
  valid_594868 = validateParameter(valid_594868, JString, required = false,
                                 default = newJString("full"))
  if valid_594868 != nil:
    section.add "projection", valid_594868
  var valid_594869 = query.getOrDefault("destinationPredefinedAcl")
  valid_594869 = validateParameter(valid_594869, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594869 != nil:
    section.add "destinationPredefinedAcl", valid_594869
  var valid_594870 = query.getOrDefault("ifMetagenerationMatch")
  valid_594870 = validateParameter(valid_594870, JString, required = false,
                                 default = nil)
  if valid_594870 != nil:
    section.add "ifMetagenerationMatch", valid_594870
  var valid_594871 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_594871 = validateParameter(valid_594871, JString, required = false,
                                 default = nil)
  if valid_594871 != nil:
    section.add "ifSourceGenerationNotMatch", valid_594871
  var valid_594872 = query.getOrDefault("prettyPrint")
  valid_594872 = validateParameter(valid_594872, JBool, required = false,
                                 default = newJBool(true))
  if valid_594872 != nil:
    section.add "prettyPrint", valid_594872
  var valid_594873 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594873 = validateParameter(valid_594873, JString, required = false,
                                 default = nil)
  if valid_594873 != nil:
    section.add "ifMetagenerationNotMatch", valid_594873
  var valid_594874 = query.getOrDefault("provisionalUserProject")
  valid_594874 = validateParameter(valid_594874, JString, required = false,
                                 default = nil)
  if valid_594874 != nil:
    section.add "provisionalUserProject", valid_594874
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

proc call*(call_594876: Call_StorageObjectsCopy_594848; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_594876.validator(path, query, header, formData, body)
  let scheme = call_594876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594876.url(scheme.get, call_594876.host, call_594876.base,
                         call_594876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594876, url, valid)

proc call*(call_594877: Call_StorageObjectsCopy_594848; destinationBucket: string;
          destinationObject: string; sourceBucket: string; sourceObject: string;
          ifGenerationMatch: string = ""; ifSourceGenerationMatch: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ifSourceMetagenerationNotMatch: string = "";
          ifGenerationNotMatch: string = "";
          ifSourceMetagenerationMatch: string = ""; oauthToken: string = "";
          sourceGeneration: string = ""; userIp: string = ""; userProject: string = "";
          key: string = ""; projection: string = "full";
          destinationPredefinedAcl: string = "authenticatedRead";
          ifMetagenerationMatch: string = "";
          ifSourceGenerationNotMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; ifMetagenerationNotMatch: string = "";
          provisionalUserProject: string = ""): Recallable =
  ## storageObjectsCopy
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the destination object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the destination object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   ifSourceMetagenerationMatch: string
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauthToken: string
  ##             : OAuth 2.0 token for the current user.
  ##   sourceGeneration: string
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   destinationBucket: string (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   userIp: string
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594878 = newJObject()
  var query_594879 = newJObject()
  var body_594880 = newJObject()
  add(query_594879, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_594879, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_594879, "fields", newJString(fields))
  add(query_594879, "quotaUser", newJString(quotaUser))
  add(query_594879, "alt", newJString(alt))
  add(query_594879, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_594879, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594879, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_594879, "oauth_token", newJString(oauthToken))
  add(query_594879, "sourceGeneration", newJString(sourceGeneration))
  add(path_594878, "destinationBucket", newJString(destinationBucket))
  add(query_594879, "userIp", newJString(userIp))
  add(path_594878, "destinationObject", newJString(destinationObject))
  add(path_594878, "sourceBucket", newJString(sourceBucket))
  add(query_594879, "userProject", newJString(userProject))
  add(query_594879, "key", newJString(key))
  add(path_594878, "sourceObject", newJString(sourceObject))
  add(query_594879, "projection", newJString(projection))
  add(query_594879, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_594879, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594879, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_594880 = body
  add(query_594879, "prettyPrint", newJBool(prettyPrint))
  add(query_594879, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594879, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594877.call(path_594878, query_594879, nil, nil, body_594880)

var storageObjectsCopy* = Call_StorageObjectsCopy_594848(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_594849, base: "/storage/v1",
    url: url_StorageObjectsCopy_594850, schemes: {Scheme.Https})
type
  Call_StorageObjectsRewrite_594881 = ref object of OpenApiRestCall_593424
proc url_StorageObjectsRewrite_594883(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/rewriteTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsRewrite_594882(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   destinationBucket: JString (required)
  ##                    : Name of the bucket in which to store the new object. Overrides the provided object metadata's bucket value, if any.
  ##   destinationObject: JString (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: JString (required)
  ##               : Name of the bucket in which to find the source object.
  ##   sourceObject: JString (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  section = newJObject()
  assert path != nil,
        "path argument is necessary due to required `destinationBucket` field"
  var valid_594884 = path.getOrDefault("destinationBucket")
  valid_594884 = validateParameter(valid_594884, JString, required = true,
                                 default = nil)
  if valid_594884 != nil:
    section.add "destinationBucket", valid_594884
  var valid_594885 = path.getOrDefault("destinationObject")
  valid_594885 = validateParameter(valid_594885, JString, required = true,
                                 default = nil)
  if valid_594885 != nil:
    section.add "destinationObject", valid_594885
  var valid_594886 = path.getOrDefault("sourceBucket")
  valid_594886 = validateParameter(valid_594886, JString, required = true,
                                 default = nil)
  if valid_594886 != nil:
    section.add "sourceBucket", valid_594886
  var valid_594887 = path.getOrDefault("sourceObject")
  valid_594887 = validateParameter(valid_594887, JString, required = true,
                                 default = nil)
  if valid_594887 != nil:
    section.add "sourceObject", valid_594887
  result.add "path", section
  ## parameters in `query` object:
  ##   ifGenerationMatch: JString
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: JString
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: JString
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: JString
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: JString
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: JString
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: JString
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
  ##   ifSourceMetagenerationMatch: JString
  ##                              : Makes the operation conditional on whether the source object's current metageneration matches the given value.
  ##   oauth_token: JString
  ##              : OAuth 2.0 token for the current user.
  ##   sourceGeneration: JString
  ##                   : If present, selects a specific revision of the source object (as opposed to the latest version, the default).
  ##   userIp: JString
  ##         : Deprecated. Please use quotaUser instead.
  ##   destinationKmsKeyName: JString
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   userProject: JString
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projection: JString
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: JString
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: JString
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: JString
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   rewriteToken: JString
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   ifMetagenerationNotMatch: JString
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   maxBytesRewrittenPerCall: JString
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_594888 = query.getOrDefault("ifGenerationMatch")
  valid_594888 = validateParameter(valid_594888, JString, required = false,
                                 default = nil)
  if valid_594888 != nil:
    section.add "ifGenerationMatch", valid_594888
  var valid_594889 = query.getOrDefault("ifSourceGenerationMatch")
  valid_594889 = validateParameter(valid_594889, JString, required = false,
                                 default = nil)
  if valid_594889 != nil:
    section.add "ifSourceGenerationMatch", valid_594889
  var valid_594890 = query.getOrDefault("fields")
  valid_594890 = validateParameter(valid_594890, JString, required = false,
                                 default = nil)
  if valid_594890 != nil:
    section.add "fields", valid_594890
  var valid_594891 = query.getOrDefault("quotaUser")
  valid_594891 = validateParameter(valid_594891, JString, required = false,
                                 default = nil)
  if valid_594891 != nil:
    section.add "quotaUser", valid_594891
  var valid_594892 = query.getOrDefault("alt")
  valid_594892 = validateParameter(valid_594892, JString, required = false,
                                 default = newJString("json"))
  if valid_594892 != nil:
    section.add "alt", valid_594892
  var valid_594893 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_594893 = validateParameter(valid_594893, JString, required = false,
                                 default = nil)
  if valid_594893 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_594893
  var valid_594894 = query.getOrDefault("ifGenerationNotMatch")
  valid_594894 = validateParameter(valid_594894, JString, required = false,
                                 default = nil)
  if valid_594894 != nil:
    section.add "ifGenerationNotMatch", valid_594894
  var valid_594895 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_594895 = validateParameter(valid_594895, JString, required = false,
                                 default = nil)
  if valid_594895 != nil:
    section.add "ifSourceMetagenerationMatch", valid_594895
  var valid_594896 = query.getOrDefault("oauth_token")
  valid_594896 = validateParameter(valid_594896, JString, required = false,
                                 default = nil)
  if valid_594896 != nil:
    section.add "oauth_token", valid_594896
  var valid_594897 = query.getOrDefault("sourceGeneration")
  valid_594897 = validateParameter(valid_594897, JString, required = false,
                                 default = nil)
  if valid_594897 != nil:
    section.add "sourceGeneration", valid_594897
  var valid_594898 = query.getOrDefault("userIp")
  valid_594898 = validateParameter(valid_594898, JString, required = false,
                                 default = nil)
  if valid_594898 != nil:
    section.add "userIp", valid_594898
  var valid_594899 = query.getOrDefault("destinationKmsKeyName")
  valid_594899 = validateParameter(valid_594899, JString, required = false,
                                 default = nil)
  if valid_594899 != nil:
    section.add "destinationKmsKeyName", valid_594899
  var valid_594900 = query.getOrDefault("userProject")
  valid_594900 = validateParameter(valid_594900, JString, required = false,
                                 default = nil)
  if valid_594900 != nil:
    section.add "userProject", valid_594900
  var valid_594901 = query.getOrDefault("key")
  valid_594901 = validateParameter(valid_594901, JString, required = false,
                                 default = nil)
  if valid_594901 != nil:
    section.add "key", valid_594901
  var valid_594902 = query.getOrDefault("projection")
  valid_594902 = validateParameter(valid_594902, JString, required = false,
                                 default = newJString("full"))
  if valid_594902 != nil:
    section.add "projection", valid_594902
  var valid_594903 = query.getOrDefault("destinationPredefinedAcl")
  valid_594903 = validateParameter(valid_594903, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_594903 != nil:
    section.add "destinationPredefinedAcl", valid_594903
  var valid_594904 = query.getOrDefault("ifMetagenerationMatch")
  valid_594904 = validateParameter(valid_594904, JString, required = false,
                                 default = nil)
  if valid_594904 != nil:
    section.add "ifMetagenerationMatch", valid_594904
  var valid_594905 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_594905 = validateParameter(valid_594905, JString, required = false,
                                 default = nil)
  if valid_594905 != nil:
    section.add "ifSourceGenerationNotMatch", valid_594905
  var valid_594906 = query.getOrDefault("prettyPrint")
  valid_594906 = validateParameter(valid_594906, JBool, required = false,
                                 default = newJBool(true))
  if valid_594906 != nil:
    section.add "prettyPrint", valid_594906
  var valid_594907 = query.getOrDefault("rewriteToken")
  valid_594907 = validateParameter(valid_594907, JString, required = false,
                                 default = nil)
  if valid_594907 != nil:
    section.add "rewriteToken", valid_594907
  var valid_594908 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_594908 = validateParameter(valid_594908, JString, required = false,
                                 default = nil)
  if valid_594908 != nil:
    section.add "ifMetagenerationNotMatch", valid_594908
  var valid_594909 = query.getOrDefault("maxBytesRewrittenPerCall")
  valid_594909 = validateParameter(valid_594909, JString, required = false,
                                 default = nil)
  if valid_594909 != nil:
    section.add "maxBytesRewrittenPerCall", valid_594909
  var valid_594910 = query.getOrDefault("provisionalUserProject")
  valid_594910 = validateParameter(valid_594910, JString, required = false,
                                 default = nil)
  if valid_594910 != nil:
    section.add "provisionalUserProject", valid_594910
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

proc call*(call_594912: Call_StorageObjectsRewrite_594881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_594912.validator(path, query, header, formData, body)
  let scheme = call_594912.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594912.url(scheme.get, call_594912.host, call_594912.base,
                         call_594912.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594912, url, valid)

proc call*(call_594913: Call_StorageObjectsRewrite_594881;
          destinationBucket: string; destinationObject: string;
          sourceBucket: string; sourceObject: string;
          ifGenerationMatch: string = ""; ifSourceGenerationMatch: string = "";
          fields: string = ""; quotaUser: string = ""; alt: string = "json";
          ifSourceMetagenerationNotMatch: string = "";
          ifGenerationNotMatch: string = "";
          ifSourceMetagenerationMatch: string = ""; oauthToken: string = "";
          sourceGeneration: string = ""; userIp: string = "";
          destinationKmsKeyName: string = ""; userProject: string = "";
          key: string = ""; projection: string = "full";
          destinationPredefinedAcl: string = "authenticatedRead";
          ifMetagenerationMatch: string = "";
          ifSourceGenerationNotMatch: string = ""; body: JsonNode = nil;
          prettyPrint: bool = true; rewriteToken: string = "";
          ifMetagenerationNotMatch: string = "";
          maxBytesRewrittenPerCall: string = ""; provisionalUserProject: string = ""): Recallable =
  ## storageObjectsRewrite
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ##   ifGenerationMatch: string
  ##                    : Makes the operation conditional on whether the object's current generation matches the given value. Setting to 0 makes the operation succeed only if there are no live versions of the object.
  ##   ifSourceGenerationMatch: string
  ##                          : Makes the operation conditional on whether the source object's current generation matches the given value.
  ##   fields: string
  ##         : Selector specifying which fields to include in a partial response.
  ##   quotaUser: string
  ##            : An opaque string that represents a user for quota purposes. Must not exceed 40 characters.
  ##   alt: string
  ##      : Data format for the response.
  ##   ifSourceMetagenerationNotMatch: string
  ##                                 : Makes the operation conditional on whether the source object's current metageneration does not match the given value.
  ##   ifGenerationNotMatch: string
  ##                       : Makes the operation conditional on whether the object's current generation does not match the given value. If no live object exists, the precondition fails. Setting to 0 makes the operation succeed only if there is a live version of the object.
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
  ##   destinationKmsKeyName: string
  ##                        : Resource name of the Cloud KMS key, of the form projects/my-project/locations/global/keyRings/my-kr/cryptoKeys/my-key, that will be used to encrypt the object. Overrides the object metadata's kms_key_name value, if any.
  ##   destinationObject: string (required)
  ##                    : Name of the new object. Required when the object metadata is not otherwise provided. Overrides the object metadata's name value, if any. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   sourceBucket: string (required)
  ##               : Name of the bucket in which to find the source object.
  ##   userProject: string
  ##              : The project to be billed for this request. Required for Requester Pays buckets.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   sourceObject: string (required)
  ##               : Name of the source object. For information about how to URL encode object names to be path safe, see Encoding URI Path Parts.
  ##   projection: string
  ##             : Set of properties to return. Defaults to noAcl, unless the object resource specifies the acl property, when it defaults to full.
  ##   destinationPredefinedAcl: string
  ##                           : Apply a predefined set of access controls to the destination object.
  ##   ifMetagenerationMatch: string
  ##                        : Makes the operation conditional on whether the destination object's current metageneration matches the given value.
  ##   ifSourceGenerationNotMatch: string
  ##                             : Makes the operation conditional on whether the source object's current generation does not match the given value.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   rewriteToken: string
  ##               : Include this field (from the previous rewrite response) on each rewrite request after the first one, until the rewrite response 'done' flag is true. Calls that provide a rewriteToken can omit all other request fields, but if included those fields must match the values provided in the first rewrite request.
  ##   ifMetagenerationNotMatch: string
  ##                           : Makes the operation conditional on whether the destination object's current metageneration does not match the given value.
  ##   maxBytesRewrittenPerCall: string
  ##                           : The maximum number of bytes that will be rewritten per rewrite request. Most callers shouldn't need to specify this parameter - it is primarily in place to support testing. If specified the value must be an integral multiple of 1 MiB (1048576). Also, this only applies to requests where the source and destination span locations and/or storage classes. Finally, this value must not change across rewrite calls else you'll get an error that the rewriteToken is invalid.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_594914 = newJObject()
  var query_594915 = newJObject()
  var body_594916 = newJObject()
  add(query_594915, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_594915, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_594915, "fields", newJString(fields))
  add(query_594915, "quotaUser", newJString(quotaUser))
  add(query_594915, "alt", newJString(alt))
  add(query_594915, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_594915, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_594915, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_594915, "oauth_token", newJString(oauthToken))
  add(query_594915, "sourceGeneration", newJString(sourceGeneration))
  add(path_594914, "destinationBucket", newJString(destinationBucket))
  add(query_594915, "userIp", newJString(userIp))
  add(query_594915, "destinationKmsKeyName", newJString(destinationKmsKeyName))
  add(path_594914, "destinationObject", newJString(destinationObject))
  add(path_594914, "sourceBucket", newJString(sourceBucket))
  add(query_594915, "userProject", newJString(userProject))
  add(query_594915, "key", newJString(key))
  add(path_594914, "sourceObject", newJString(sourceObject))
  add(query_594915, "projection", newJString(projection))
  add(query_594915, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_594915, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_594915, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_594916 = body
  add(query_594915, "prettyPrint", newJBool(prettyPrint))
  add(query_594915, "rewriteToken", newJString(rewriteToken))
  add(query_594915, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_594915, "maxBytesRewrittenPerCall",
      newJString(maxBytesRewrittenPerCall))
  add(query_594915, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_594913.call(path_594914, query_594915, nil, nil, body_594916)

var storageObjectsRewrite* = Call_StorageObjectsRewrite_594881(
    name: "storageObjectsRewrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/rewriteTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsRewrite_594882, base: "/storage/v1",
    url: url_StorageObjectsRewrite_594883, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_594917 = ref object of OpenApiRestCall_593424
proc url_StorageChannelsStop_594919(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  result.path = base & route

proc validate_StorageChannelsStop_594918(path: JsonNode; query: JsonNode;
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
  var valid_594920 = query.getOrDefault("fields")
  valid_594920 = validateParameter(valid_594920, JString, required = false,
                                 default = nil)
  if valid_594920 != nil:
    section.add "fields", valid_594920
  var valid_594921 = query.getOrDefault("quotaUser")
  valid_594921 = validateParameter(valid_594921, JString, required = false,
                                 default = nil)
  if valid_594921 != nil:
    section.add "quotaUser", valid_594921
  var valid_594922 = query.getOrDefault("alt")
  valid_594922 = validateParameter(valid_594922, JString, required = false,
                                 default = newJString("json"))
  if valid_594922 != nil:
    section.add "alt", valid_594922
  var valid_594923 = query.getOrDefault("oauth_token")
  valid_594923 = validateParameter(valid_594923, JString, required = false,
                                 default = nil)
  if valid_594923 != nil:
    section.add "oauth_token", valid_594923
  var valid_594924 = query.getOrDefault("userIp")
  valid_594924 = validateParameter(valid_594924, JString, required = false,
                                 default = nil)
  if valid_594924 != nil:
    section.add "userIp", valid_594924
  var valid_594925 = query.getOrDefault("key")
  valid_594925 = validateParameter(valid_594925, JString, required = false,
                                 default = nil)
  if valid_594925 != nil:
    section.add "key", valid_594925
  var valid_594926 = query.getOrDefault("prettyPrint")
  valid_594926 = validateParameter(valid_594926, JBool, required = false,
                                 default = newJBool(true))
  if valid_594926 != nil:
    section.add "prettyPrint", valid_594926
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

proc call*(call_594928: Call_StorageChannelsStop_594917; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_594928.validator(path, query, header, formData, body)
  let scheme = call_594928.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594928.url(scheme.get, call_594928.host, call_594928.base,
                         call_594928.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594928, url, valid)

proc call*(call_594929: Call_StorageChannelsStop_594917; fields: string = "";
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
  var query_594930 = newJObject()
  var body_594931 = newJObject()
  add(query_594930, "fields", newJString(fields))
  add(query_594930, "quotaUser", newJString(quotaUser))
  add(query_594930, "alt", newJString(alt))
  add(query_594930, "oauth_token", newJString(oauthToken))
  add(query_594930, "userIp", newJString(userIp))
  add(query_594930, "key", newJString(key))
  if resource != nil:
    body_594931 = resource
  add(query_594930, "prettyPrint", newJBool(prettyPrint))
  result = call_594929.call(nil, query_594930, nil, nil, body_594931)

var storageChannelsStop* = Call_StorageChannelsStop_594917(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_594918, base: "/storage/v1",
    url: url_StorageChannelsStop_594919, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysCreate_594952 = ref object of OpenApiRestCall_593424
proc url_StorageProjectsHmacKeysCreate_594954(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysCreate_594953(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Creates a new HMAC key for the specified service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594955 = path.getOrDefault("projectId")
  valid_594955 = validateParameter(valid_594955, JString, required = true,
                                 default = nil)
  if valid_594955 != nil:
    section.add "projectId", valid_594955
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceAccountEmail: JString (required)
  ##                      : Email address of the service account.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594956 = query.getOrDefault("fields")
  valid_594956 = validateParameter(valid_594956, JString, required = false,
                                 default = nil)
  if valid_594956 != nil:
    section.add "fields", valid_594956
  var valid_594957 = query.getOrDefault("quotaUser")
  valid_594957 = validateParameter(valid_594957, JString, required = false,
                                 default = nil)
  if valid_594957 != nil:
    section.add "quotaUser", valid_594957
  var valid_594958 = query.getOrDefault("alt")
  valid_594958 = validateParameter(valid_594958, JString, required = false,
                                 default = newJString("json"))
  if valid_594958 != nil:
    section.add "alt", valid_594958
  var valid_594959 = query.getOrDefault("oauth_token")
  valid_594959 = validateParameter(valid_594959, JString, required = false,
                                 default = nil)
  if valid_594959 != nil:
    section.add "oauth_token", valid_594959
  var valid_594960 = query.getOrDefault("userIp")
  valid_594960 = validateParameter(valid_594960, JString, required = false,
                                 default = nil)
  if valid_594960 != nil:
    section.add "userIp", valid_594960
  var valid_594961 = query.getOrDefault("userProject")
  valid_594961 = validateParameter(valid_594961, JString, required = false,
                                 default = nil)
  if valid_594961 != nil:
    section.add "userProject", valid_594961
  var valid_594962 = query.getOrDefault("key")
  valid_594962 = validateParameter(valid_594962, JString, required = false,
                                 default = nil)
  if valid_594962 != nil:
    section.add "key", valid_594962
  assert query != nil, "query argument is necessary due to required `serviceAccountEmail` field"
  var valid_594963 = query.getOrDefault("serviceAccountEmail")
  valid_594963 = validateParameter(valid_594963, JString, required = true,
                                 default = nil)
  if valid_594963 != nil:
    section.add "serviceAccountEmail", valid_594963
  var valid_594964 = query.getOrDefault("prettyPrint")
  valid_594964 = validateParameter(valid_594964, JBool, required = false,
                                 default = newJBool(true))
  if valid_594964 != nil:
    section.add "prettyPrint", valid_594964
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594965: Call_StorageProjectsHmacKeysCreate_594952; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new HMAC key for the specified service account.
  ## 
  let valid = call_594965.validator(path, query, header, formData, body)
  let scheme = call_594965.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594965.url(scheme.get, call_594965.host, call_594965.base,
                         call_594965.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594965, url, valid)

proc call*(call_594966: Call_StorageProjectsHmacKeysCreate_594952;
          serviceAccountEmail: string; projectId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysCreate
  ## Creates a new HMAC key for the specified service account.
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
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   serviceAccountEmail: string (required)
  ##                      : Email address of the service account.
  ##   projectId: string (required)
  ##            : Project ID owning the service account.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594967 = newJObject()
  var query_594968 = newJObject()
  add(query_594968, "fields", newJString(fields))
  add(query_594968, "quotaUser", newJString(quotaUser))
  add(query_594968, "alt", newJString(alt))
  add(query_594968, "oauth_token", newJString(oauthToken))
  add(query_594968, "userIp", newJString(userIp))
  add(query_594968, "userProject", newJString(userProject))
  add(query_594968, "key", newJString(key))
  add(query_594968, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(path_594967, "projectId", newJString(projectId))
  add(query_594968, "prettyPrint", newJBool(prettyPrint))
  result = call_594966.call(path_594967, query_594968, nil, nil, nil)

var storageProjectsHmacKeysCreate* = Call_StorageProjectsHmacKeysCreate_594952(
    name: "storageProjectsHmacKeysCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysCreate_594953, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysCreate_594954, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysList_594932 = ref object of OpenApiRestCall_593424
proc url_StorageProjectsHmacKeysList_594934(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysList_594933(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Name of the project in which to look for HMAC keys.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594935 = path.getOrDefault("projectId")
  valid_594935 = validateParameter(valid_594935, JString, required = true,
                                 default = nil)
  if valid_594935 != nil:
    section.add "projectId", valid_594935
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
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   showDeletedKeys: JBool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: JString
  ##                      : If present, only keys for the given service account are returned.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594936 = query.getOrDefault("fields")
  valid_594936 = validateParameter(valid_594936, JString, required = false,
                                 default = nil)
  if valid_594936 != nil:
    section.add "fields", valid_594936
  var valid_594937 = query.getOrDefault("pageToken")
  valid_594937 = validateParameter(valid_594937, JString, required = false,
                                 default = nil)
  if valid_594937 != nil:
    section.add "pageToken", valid_594937
  var valid_594938 = query.getOrDefault("quotaUser")
  valid_594938 = validateParameter(valid_594938, JString, required = false,
                                 default = nil)
  if valid_594938 != nil:
    section.add "quotaUser", valid_594938
  var valid_594939 = query.getOrDefault("alt")
  valid_594939 = validateParameter(valid_594939, JString, required = false,
                                 default = newJString("json"))
  if valid_594939 != nil:
    section.add "alt", valid_594939
  var valid_594940 = query.getOrDefault("oauth_token")
  valid_594940 = validateParameter(valid_594940, JString, required = false,
                                 default = nil)
  if valid_594940 != nil:
    section.add "oauth_token", valid_594940
  var valid_594941 = query.getOrDefault("userIp")
  valid_594941 = validateParameter(valid_594941, JString, required = false,
                                 default = nil)
  if valid_594941 != nil:
    section.add "userIp", valid_594941
  var valid_594942 = query.getOrDefault("maxResults")
  valid_594942 = validateParameter(valid_594942, JInt, required = false,
                                 default = newJInt(250))
  if valid_594942 != nil:
    section.add "maxResults", valid_594942
  var valid_594943 = query.getOrDefault("userProject")
  valid_594943 = validateParameter(valid_594943, JString, required = false,
                                 default = nil)
  if valid_594943 != nil:
    section.add "userProject", valid_594943
  var valid_594944 = query.getOrDefault("key")
  valid_594944 = validateParameter(valid_594944, JString, required = false,
                                 default = nil)
  if valid_594944 != nil:
    section.add "key", valid_594944
  var valid_594945 = query.getOrDefault("showDeletedKeys")
  valid_594945 = validateParameter(valid_594945, JBool, required = false, default = nil)
  if valid_594945 != nil:
    section.add "showDeletedKeys", valid_594945
  var valid_594946 = query.getOrDefault("serviceAccountEmail")
  valid_594946 = validateParameter(valid_594946, JString, required = false,
                                 default = nil)
  if valid_594946 != nil:
    section.add "serviceAccountEmail", valid_594946
  var valid_594947 = query.getOrDefault("prettyPrint")
  valid_594947 = validateParameter(valid_594947, JBool, required = false,
                                 default = newJBool(true))
  if valid_594947 != nil:
    section.add "prettyPrint", valid_594947
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594948: Call_StorageProjectsHmacKeysList_594932; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  let valid = call_594948.validator(path, query, header, formData, body)
  let scheme = call_594948.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594948.url(scheme.get, call_594948.host, call_594948.base,
                         call_594948.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594948, url, valid)

proc call*(call_594949: Call_StorageProjectsHmacKeysList_594932; projectId: string;
          fields: string = ""; pageToken: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          maxResults: int = 250; userProject: string = ""; key: string = "";
          showDeletedKeys: bool = false; serviceAccountEmail: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysList
  ## Retrieves a list of HMAC keys matching the criteria.
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
  ##             : Maximum number of items to return in a single page of responses. The service uses this parameter or 250 items, whichever is smaller. The max number of items per page will also be limited by the number of distinct service accounts in the response. If the number of service accounts in a single response is too high, the page will truncated and a next page token will be returned.
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   showDeletedKeys: bool
  ##                  : Whether or not to show keys in the DELETED state.
  ##   serviceAccountEmail: string
  ##                      : If present, only keys for the given service account are returned.
  ##   projectId: string (required)
  ##            : Name of the project in which to look for HMAC keys.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594950 = newJObject()
  var query_594951 = newJObject()
  add(query_594951, "fields", newJString(fields))
  add(query_594951, "pageToken", newJString(pageToken))
  add(query_594951, "quotaUser", newJString(quotaUser))
  add(query_594951, "alt", newJString(alt))
  add(query_594951, "oauth_token", newJString(oauthToken))
  add(query_594951, "userIp", newJString(userIp))
  add(query_594951, "maxResults", newJInt(maxResults))
  add(query_594951, "userProject", newJString(userProject))
  add(query_594951, "key", newJString(key))
  add(query_594951, "showDeletedKeys", newJBool(showDeletedKeys))
  add(query_594951, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(path_594950, "projectId", newJString(projectId))
  add(query_594951, "prettyPrint", newJBool(prettyPrint))
  result = call_594949.call(path_594950, query_594951, nil, nil, nil)

var storageProjectsHmacKeysList* = Call_StorageProjectsHmacKeysList_594932(
    name: "storageProjectsHmacKeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysList_594933, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysList_594934, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysUpdate_594986 = ref object of OpenApiRestCall_593424
proc url_StorageProjectsHmacKeysUpdate_594988(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysUpdate_594987(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the updated key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key being updated.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594989 = path.getOrDefault("projectId")
  valid_594989 = validateParameter(valid_594989, JString, required = true,
                                 default = nil)
  if valid_594989 != nil:
    section.add "projectId", valid_594989
  var valid_594990 = path.getOrDefault("accessId")
  valid_594990 = validateParameter(valid_594990, JString, required = true,
                                 default = nil)
  if valid_594990 != nil:
    section.add "accessId", valid_594990
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594991 = query.getOrDefault("fields")
  valid_594991 = validateParameter(valid_594991, JString, required = false,
                                 default = nil)
  if valid_594991 != nil:
    section.add "fields", valid_594991
  var valid_594992 = query.getOrDefault("quotaUser")
  valid_594992 = validateParameter(valid_594992, JString, required = false,
                                 default = nil)
  if valid_594992 != nil:
    section.add "quotaUser", valid_594992
  var valid_594993 = query.getOrDefault("alt")
  valid_594993 = validateParameter(valid_594993, JString, required = false,
                                 default = newJString("json"))
  if valid_594993 != nil:
    section.add "alt", valid_594993
  var valid_594994 = query.getOrDefault("oauth_token")
  valid_594994 = validateParameter(valid_594994, JString, required = false,
                                 default = nil)
  if valid_594994 != nil:
    section.add "oauth_token", valid_594994
  var valid_594995 = query.getOrDefault("userIp")
  valid_594995 = validateParameter(valid_594995, JString, required = false,
                                 default = nil)
  if valid_594995 != nil:
    section.add "userIp", valid_594995
  var valid_594996 = query.getOrDefault("userProject")
  valid_594996 = validateParameter(valid_594996, JString, required = false,
                                 default = nil)
  if valid_594996 != nil:
    section.add "userProject", valid_594996
  var valid_594997 = query.getOrDefault("key")
  valid_594997 = validateParameter(valid_594997, JString, required = false,
                                 default = nil)
  if valid_594997 != nil:
    section.add "key", valid_594997
  var valid_594998 = query.getOrDefault("prettyPrint")
  valid_594998 = validateParameter(valid_594998, JBool, required = false,
                                 default = newJBool(true))
  if valid_594998 != nil:
    section.add "prettyPrint", valid_594998
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

proc call*(call_595000: Call_StorageProjectsHmacKeysUpdate_594986; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  let valid = call_595000.validator(path, query, header, formData, body)
  let scheme = call_595000.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595000.url(scheme.get, call_595000.host, call_595000.base,
                         call_595000.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595000, url, valid)

proc call*(call_595001: Call_StorageProjectsHmacKeysUpdate_594986;
          projectId: string; accessId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          body: JsonNode = nil; prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysUpdate
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
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
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the updated key.
  ##   accessId: string (required)
  ##           : Name of the HMAC key being updated.
  ##   body: JObject
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_595002 = newJObject()
  var query_595003 = newJObject()
  var body_595004 = newJObject()
  add(query_595003, "fields", newJString(fields))
  add(query_595003, "quotaUser", newJString(quotaUser))
  add(query_595003, "alt", newJString(alt))
  add(query_595003, "oauth_token", newJString(oauthToken))
  add(query_595003, "userIp", newJString(userIp))
  add(query_595003, "userProject", newJString(userProject))
  add(query_595003, "key", newJString(key))
  add(path_595002, "projectId", newJString(projectId))
  add(path_595002, "accessId", newJString(accessId))
  if body != nil:
    body_595004 = body
  add(query_595003, "prettyPrint", newJBool(prettyPrint))
  result = call_595001.call(path_595002, query_595003, nil, nil, body_595004)

var storageProjectsHmacKeysUpdate* = Call_StorageProjectsHmacKeysUpdate_594986(
    name: "storageProjectsHmacKeysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysUpdate_594987, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysUpdate_594988, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysGet_594969 = ref object of OpenApiRestCall_593424
proc url_StorageProjectsHmacKeysGet_594971(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysGet_594970(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Retrieves an HMAC key's metadata
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the service account of the requested key.
  ##   accessId: JString (required)
  ##           : Name of the HMAC key.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_594972 = path.getOrDefault("projectId")
  valid_594972 = validateParameter(valid_594972, JString, required = true,
                                 default = nil)
  if valid_594972 != nil:
    section.add "projectId", valid_594972
  var valid_594973 = path.getOrDefault("accessId")
  valid_594973 = validateParameter(valid_594973, JString, required = true,
                                 default = nil)
  if valid_594973 != nil:
    section.add "accessId", valid_594973
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_594974 = query.getOrDefault("fields")
  valid_594974 = validateParameter(valid_594974, JString, required = false,
                                 default = nil)
  if valid_594974 != nil:
    section.add "fields", valid_594974
  var valid_594975 = query.getOrDefault("quotaUser")
  valid_594975 = validateParameter(valid_594975, JString, required = false,
                                 default = nil)
  if valid_594975 != nil:
    section.add "quotaUser", valid_594975
  var valid_594976 = query.getOrDefault("alt")
  valid_594976 = validateParameter(valid_594976, JString, required = false,
                                 default = newJString("json"))
  if valid_594976 != nil:
    section.add "alt", valid_594976
  var valid_594977 = query.getOrDefault("oauth_token")
  valid_594977 = validateParameter(valid_594977, JString, required = false,
                                 default = nil)
  if valid_594977 != nil:
    section.add "oauth_token", valid_594977
  var valid_594978 = query.getOrDefault("userIp")
  valid_594978 = validateParameter(valid_594978, JString, required = false,
                                 default = nil)
  if valid_594978 != nil:
    section.add "userIp", valid_594978
  var valid_594979 = query.getOrDefault("userProject")
  valid_594979 = validateParameter(valid_594979, JString, required = false,
                                 default = nil)
  if valid_594979 != nil:
    section.add "userProject", valid_594979
  var valid_594980 = query.getOrDefault("key")
  valid_594980 = validateParameter(valid_594980, JString, required = false,
                                 default = nil)
  if valid_594980 != nil:
    section.add "key", valid_594980
  var valid_594981 = query.getOrDefault("prettyPrint")
  valid_594981 = validateParameter(valid_594981, JBool, required = false,
                                 default = newJBool(true))
  if valid_594981 != nil:
    section.add "prettyPrint", valid_594981
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_594982: Call_StorageProjectsHmacKeysGet_594969; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an HMAC key's metadata
  ## 
  let valid = call_594982.validator(path, query, header, formData, body)
  let scheme = call_594982.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_594982.url(scheme.get, call_594982.host, call_594982.base,
                         call_594982.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_594982, url, valid)

proc call*(call_594983: Call_StorageProjectsHmacKeysGet_594969; projectId: string;
          accessId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysGet
  ## Retrieves an HMAC key's metadata
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
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID owning the service account of the requested key.
  ##   accessId: string (required)
  ##           : Name of the HMAC key.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_594984 = newJObject()
  var query_594985 = newJObject()
  add(query_594985, "fields", newJString(fields))
  add(query_594985, "quotaUser", newJString(quotaUser))
  add(query_594985, "alt", newJString(alt))
  add(query_594985, "oauth_token", newJString(oauthToken))
  add(query_594985, "userIp", newJString(userIp))
  add(query_594985, "userProject", newJString(userProject))
  add(query_594985, "key", newJString(key))
  add(path_594984, "projectId", newJString(projectId))
  add(path_594984, "accessId", newJString(accessId))
  add(query_594985, "prettyPrint", newJBool(prettyPrint))
  result = call_594983.call(path_594984, query_594985, nil, nil, nil)

var storageProjectsHmacKeysGet* = Call_StorageProjectsHmacKeysGet_594969(
    name: "storageProjectsHmacKeysGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysGet_594970, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysGet_594971, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysDelete_595005 = ref object of OpenApiRestCall_593424
proc url_StorageProjectsHmacKeysDelete_595007(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  assert "accessId" in path, "`accessId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/hmacKeys/"),
               (kind: VariableSegment, value: "accessId")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsHmacKeysDelete_595006(path: JsonNode; query: JsonNode;
    header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Deletes an HMAC key.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID owning the requested key
  ##   accessId: JString (required)
  ##           : Name of the HMAC key to be deleted.
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_595008 = path.getOrDefault("projectId")
  valid_595008 = validateParameter(valid_595008, JString, required = true,
                                 default = nil)
  if valid_595008 != nil:
    section.add "projectId", valid_595008
  var valid_595009 = path.getOrDefault("accessId")
  valid_595009 = validateParameter(valid_595009, JString, required = true,
                                 default = nil)
  if valid_595009 != nil:
    section.add "accessId", valid_595009
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  section = newJObject()
  var valid_595010 = query.getOrDefault("fields")
  valid_595010 = validateParameter(valid_595010, JString, required = false,
                                 default = nil)
  if valid_595010 != nil:
    section.add "fields", valid_595010
  var valid_595011 = query.getOrDefault("quotaUser")
  valid_595011 = validateParameter(valid_595011, JString, required = false,
                                 default = nil)
  if valid_595011 != nil:
    section.add "quotaUser", valid_595011
  var valid_595012 = query.getOrDefault("alt")
  valid_595012 = validateParameter(valid_595012, JString, required = false,
                                 default = newJString("json"))
  if valid_595012 != nil:
    section.add "alt", valid_595012
  var valid_595013 = query.getOrDefault("oauth_token")
  valid_595013 = validateParameter(valid_595013, JString, required = false,
                                 default = nil)
  if valid_595013 != nil:
    section.add "oauth_token", valid_595013
  var valid_595014 = query.getOrDefault("userIp")
  valid_595014 = validateParameter(valid_595014, JString, required = false,
                                 default = nil)
  if valid_595014 != nil:
    section.add "userIp", valid_595014
  var valid_595015 = query.getOrDefault("userProject")
  valid_595015 = validateParameter(valid_595015, JString, required = false,
                                 default = nil)
  if valid_595015 != nil:
    section.add "userProject", valid_595015
  var valid_595016 = query.getOrDefault("key")
  valid_595016 = validateParameter(valid_595016, JString, required = false,
                                 default = nil)
  if valid_595016 != nil:
    section.add "key", valid_595016
  var valid_595017 = query.getOrDefault("prettyPrint")
  valid_595017 = validateParameter(valid_595017, JBool, required = false,
                                 default = newJBool(true))
  if valid_595017 != nil:
    section.add "prettyPrint", valid_595017
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595018: Call_StorageProjectsHmacKeysDelete_595005; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an HMAC key.
  ## 
  let valid = call_595018.validator(path, query, header, formData, body)
  let scheme = call_595018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595018.url(scheme.get, call_595018.host, call_595018.base,
                         call_595018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595018, url, valid)

proc call*(call_595019: Call_StorageProjectsHmacKeysDelete_595005;
          projectId: string; accessId: string; fields: string = "";
          quotaUser: string = ""; alt: string = "json"; oauthToken: string = "";
          userIp: string = ""; userProject: string = ""; key: string = "";
          prettyPrint: bool = true): Recallable =
  ## storageProjectsHmacKeysDelete
  ## Deletes an HMAC key.
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
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID owning the requested key
  ##   accessId: string (required)
  ##           : Name of the HMAC key to be deleted.
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  var path_595020 = newJObject()
  var query_595021 = newJObject()
  add(query_595021, "fields", newJString(fields))
  add(query_595021, "quotaUser", newJString(quotaUser))
  add(query_595021, "alt", newJString(alt))
  add(query_595021, "oauth_token", newJString(oauthToken))
  add(query_595021, "userIp", newJString(userIp))
  add(query_595021, "userProject", newJString(userProject))
  add(query_595021, "key", newJString(key))
  add(path_595020, "projectId", newJString(projectId))
  add(path_595020, "accessId", newJString(accessId))
  add(query_595021, "prettyPrint", newJBool(prettyPrint))
  result = call_595019.call(path_595020, query_595021, nil, nil, nil)

var storageProjectsHmacKeysDelete* = Call_StorageProjectsHmacKeysDelete_595005(
    name: "storageProjectsHmacKeysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysDelete_595006, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysDelete_595007, schemes: {Scheme.Https})
type
  Call_StorageProjectsServiceAccountGet_595022 = ref object of OpenApiRestCall_593424
proc url_StorageProjectsServiceAccountGet_595024(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $queryString(query)
  assert path != nil, "path is required to populate template"
  assert "projectId" in path, "`projectId` is a required path parameter"
  const
    segments = @[(kind: ConstantSegment, value: "/projects/"),
               (kind: VariableSegment, value: "projectId"),
               (kind: ConstantSegment, value: "/serviceAccount")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageProjectsServiceAccountGet_595023(path: JsonNode;
    query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): JsonNode =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  var section: JsonNode
  result = newJObject()
  ## parameters in `path` object:
  ##   projectId: JString (required)
  ##            : Project ID
  section = newJObject()
  assert path != nil, "path argument is necessary due to required `projectId` field"
  var valid_595025 = path.getOrDefault("projectId")
  valid_595025 = validateParameter(valid_595025, JString, required = true,
                                 default = nil)
  if valid_595025 != nil:
    section.add "projectId", valid_595025
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
  ##   userProject: JString
  ##              : The project to be billed for this request.
  ##   key: JString
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   prettyPrint: JBool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: JString
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  section = newJObject()
  var valid_595026 = query.getOrDefault("fields")
  valid_595026 = validateParameter(valid_595026, JString, required = false,
                                 default = nil)
  if valid_595026 != nil:
    section.add "fields", valid_595026
  var valid_595027 = query.getOrDefault("quotaUser")
  valid_595027 = validateParameter(valid_595027, JString, required = false,
                                 default = nil)
  if valid_595027 != nil:
    section.add "quotaUser", valid_595027
  var valid_595028 = query.getOrDefault("alt")
  valid_595028 = validateParameter(valid_595028, JString, required = false,
                                 default = newJString("json"))
  if valid_595028 != nil:
    section.add "alt", valid_595028
  var valid_595029 = query.getOrDefault("oauth_token")
  valid_595029 = validateParameter(valid_595029, JString, required = false,
                                 default = nil)
  if valid_595029 != nil:
    section.add "oauth_token", valid_595029
  var valid_595030 = query.getOrDefault("userIp")
  valid_595030 = validateParameter(valid_595030, JString, required = false,
                                 default = nil)
  if valid_595030 != nil:
    section.add "userIp", valid_595030
  var valid_595031 = query.getOrDefault("userProject")
  valid_595031 = validateParameter(valid_595031, JString, required = false,
                                 default = nil)
  if valid_595031 != nil:
    section.add "userProject", valid_595031
  var valid_595032 = query.getOrDefault("key")
  valid_595032 = validateParameter(valid_595032, JString, required = false,
                                 default = nil)
  if valid_595032 != nil:
    section.add "key", valid_595032
  var valid_595033 = query.getOrDefault("prettyPrint")
  valid_595033 = validateParameter(valid_595033, JBool, required = false,
                                 default = newJBool(true))
  if valid_595033 != nil:
    section.add "prettyPrint", valid_595033
  var valid_595034 = query.getOrDefault("provisionalUserProject")
  valid_595034 = validateParameter(valid_595034, JString, required = false,
                                 default = nil)
  if valid_595034 != nil:
    section.add "provisionalUserProject", valid_595034
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_595035: Call_StorageProjectsServiceAccountGet_595022;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  let valid = call_595035.validator(path, query, header, formData, body)
  let scheme = call_595035.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_595035.url(scheme.get, call_595035.host, call_595035.base,
                         call_595035.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_595035, url, valid)

proc call*(call_595036: Call_StorageProjectsServiceAccountGet_595022;
          projectId: string; fields: string = ""; quotaUser: string = "";
          alt: string = "json"; oauthToken: string = ""; userIp: string = "";
          userProject: string = ""; key: string = ""; prettyPrint: bool = true;
          provisionalUserProject: string = ""): Recallable =
  ## storageProjectsServiceAccountGet
  ## Get the email address of this project's Google Cloud Storage service account.
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
  ##   userProject: string
  ##              : The project to be billed for this request.
  ##   key: string
  ##      : API key. Your API key identifies your project and provides you with API access, quota, and reports. Required unless you provide an OAuth 2.0 token.
  ##   projectId: string (required)
  ##            : Project ID
  ##   prettyPrint: bool
  ##              : Returns response with indentations and line breaks.
  ##   provisionalUserProject: string
  ##                         : The project to be billed for this request if the target bucket is requester-pays bucket.
  var path_595037 = newJObject()
  var query_595038 = newJObject()
  add(query_595038, "fields", newJString(fields))
  add(query_595038, "quotaUser", newJString(quotaUser))
  add(query_595038, "alt", newJString(alt))
  add(query_595038, "oauth_token", newJString(oauthToken))
  add(query_595038, "userIp", newJString(userIp))
  add(query_595038, "userProject", newJString(userProject))
  add(query_595038, "key", newJString(key))
  add(path_595037, "projectId", newJString(projectId))
  add(query_595038, "prettyPrint", newJBool(prettyPrint))
  add(query_595038, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_595036.call(path_595037, query_595038, nil, nil, nil)

var storageProjectsServiceAccountGet* = Call_StorageProjectsServiceAccountGet_595022(
    name: "storageProjectsServiceAccountGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/serviceAccount",
    validator: validate_StorageProjectsServiceAccountGet_595023,
    base: "/storage/v1", url: url_StorageProjectsServiceAccountGet_595024,
    schemes: {Scheme.Https})
export
  rest

method hook(call: OpenApiRestCall; url: Uri; input: JsonNode): Recallable {.base.} =
  let headers = massageHeaders(input.getOrDefault("header"))
  result = newRecallable(call, url, headers, input.getOrDefault("body").getStr)
