
import
  json, options, hashes, uri, rest, os, uri, strutils, times, httpcore, httpclient,
  asyncdispatch, jwt

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
  Call_StorageBucketsInsert_589001 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsInsert_589003(protocol: Scheme; host: string; base: string;
                                    route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageBucketsInsert_589002(path: JsonNode; query: JsonNode;
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
  var valid_589004 = query.getOrDefault("fields")
  valid_589004 = validateParameter(valid_589004, JString, required = false,
                                 default = nil)
  if valid_589004 != nil:
    section.add "fields", valid_589004
  var valid_589005 = query.getOrDefault("quotaUser")
  valid_589005 = validateParameter(valid_589005, JString, required = false,
                                 default = nil)
  if valid_589005 != nil:
    section.add "quotaUser", valid_589005
  var valid_589006 = query.getOrDefault("alt")
  valid_589006 = validateParameter(valid_589006, JString, required = false,
                                 default = newJString("json"))
  if valid_589006 != nil:
    section.add "alt", valid_589006
  var valid_589007 = query.getOrDefault("oauth_token")
  valid_589007 = validateParameter(valid_589007, JString, required = false,
                                 default = nil)
  if valid_589007 != nil:
    section.add "oauth_token", valid_589007
  var valid_589008 = query.getOrDefault("userIp")
  valid_589008 = validateParameter(valid_589008, JString, required = false,
                                 default = nil)
  if valid_589008 != nil:
    section.add "userIp", valid_589008
  var valid_589009 = query.getOrDefault("predefinedAcl")
  valid_589009 = validateParameter(valid_589009, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589009 != nil:
    section.add "predefinedAcl", valid_589009
  var valid_589010 = query.getOrDefault("userProject")
  valid_589010 = validateParameter(valid_589010, JString, required = false,
                                 default = nil)
  if valid_589010 != nil:
    section.add "userProject", valid_589010
  var valid_589011 = query.getOrDefault("key")
  valid_589011 = validateParameter(valid_589011, JString, required = false,
                                 default = nil)
  if valid_589011 != nil:
    section.add "key", valid_589011
  var valid_589012 = query.getOrDefault("projection")
  valid_589012 = validateParameter(valid_589012, JString, required = false,
                                 default = newJString("full"))
  if valid_589012 != nil:
    section.add "projection", valid_589012
  var valid_589013 = query.getOrDefault("prettyPrint")
  valid_589013 = validateParameter(valid_589013, JBool, required = false,
                                 default = newJBool(true))
  if valid_589013 != nil:
    section.add "prettyPrint", valid_589013
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_589014 = query.getOrDefault("project")
  valid_589014 = validateParameter(valid_589014, JString, required = true,
                                 default = nil)
  if valid_589014 != nil:
    section.add "project", valid_589014
  var valid_589015 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_589015 = validateParameter(valid_589015, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589015 != nil:
    section.add "predefinedDefaultObjectAcl", valid_589015
  var valid_589016 = query.getOrDefault("provisionalUserProject")
  valid_589016 = validateParameter(valid_589016, JString, required = false,
                                 default = nil)
  if valid_589016 != nil:
    section.add "provisionalUserProject", valid_589016
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

proc call*(call_589018: Call_StorageBucketsInsert_589001; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new bucket.
  ## 
  let valid = call_589018.validator(path, query, header, formData, body)
  let scheme = call_589018.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589018.url(scheme.get, call_589018.host, call_589018.base,
                         call_589018.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589018, url, valid)

proc call*(call_589019: Call_StorageBucketsInsert_589001; project: string;
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
  var query_589020 = newJObject()
  var body_589021 = newJObject()
  add(query_589020, "fields", newJString(fields))
  add(query_589020, "quotaUser", newJString(quotaUser))
  add(query_589020, "alt", newJString(alt))
  add(query_589020, "oauth_token", newJString(oauthToken))
  add(query_589020, "userIp", newJString(userIp))
  add(query_589020, "predefinedAcl", newJString(predefinedAcl))
  add(query_589020, "userProject", newJString(userProject))
  add(query_589020, "key", newJString(key))
  add(query_589020, "projection", newJString(projection))
  if body != nil:
    body_589021 = body
  add(query_589020, "prettyPrint", newJBool(prettyPrint))
  add(query_589020, "project", newJString(project))
  add(query_589020, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_589020, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589019.call(nil, query_589020, nil, nil, body_589021)

var storageBucketsInsert* = Call_StorageBucketsInsert_589001(
    name: "storageBucketsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b",
    validator: validate_StorageBucketsInsert_589002, base: "/storage/v1",
    url: url_StorageBucketsInsert_589003, schemes: {Scheme.Https})
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
  var valid_588859 = query.getOrDefault("maxResults")
  valid_588859 = validateParameter(valid_588859, JInt, required = false,
                                 default = newJInt(1000))
  if valid_588859 != nil:
    section.add "maxResults", valid_588859
  var valid_588860 = query.getOrDefault("userProject")
  valid_588860 = validateParameter(valid_588860, JString, required = false,
                                 default = nil)
  if valid_588860 != nil:
    section.add "userProject", valid_588860
  var valid_588861 = query.getOrDefault("key")
  valid_588861 = validateParameter(valid_588861, JString, required = false,
                                 default = nil)
  if valid_588861 != nil:
    section.add "key", valid_588861
  var valid_588862 = query.getOrDefault("projection")
  valid_588862 = validateParameter(valid_588862, JString, required = false,
                                 default = newJString("full"))
  if valid_588862 != nil:
    section.add "projection", valid_588862
  assert query != nil, "query argument is necessary due to required `project` field"
  var valid_588863 = query.getOrDefault("project")
  valid_588863 = validateParameter(valid_588863, JString, required = true,
                                 default = nil)
  if valid_588863 != nil:
    section.add "project", valid_588863
  var valid_588864 = query.getOrDefault("prettyPrint")
  valid_588864 = validateParameter(valid_588864, JBool, required = false,
                                 default = newJBool(true))
  if valid_588864 != nil:
    section.add "prettyPrint", valid_588864
  var valid_588865 = query.getOrDefault("prefix")
  valid_588865 = validateParameter(valid_588865, JString, required = false,
                                 default = nil)
  if valid_588865 != nil:
    section.add "prefix", valid_588865
  var valid_588866 = query.getOrDefault("provisionalUserProject")
  valid_588866 = validateParameter(valid_588866, JString, required = false,
                                 default = nil)
  if valid_588866 != nil:
    section.add "provisionalUserProject", valid_588866
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_588889: Call_StorageBucketsList_588725; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of buckets for a given project.
  ## 
  let valid = call_588889.validator(path, query, header, formData, body)
  let scheme = call_588889.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_588889.url(scheme.get, call_588889.host, call_588889.base,
                         call_588889.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_588889, url, valid)

proc call*(call_588960: Call_StorageBucketsList_588725; project: string;
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
  var query_588961 = newJObject()
  add(query_588961, "fields", newJString(fields))
  add(query_588961, "pageToken", newJString(pageToken))
  add(query_588961, "quotaUser", newJString(quotaUser))
  add(query_588961, "alt", newJString(alt))
  add(query_588961, "oauth_token", newJString(oauthToken))
  add(query_588961, "userIp", newJString(userIp))
  add(query_588961, "maxResults", newJInt(maxResults))
  add(query_588961, "userProject", newJString(userProject))
  add(query_588961, "key", newJString(key))
  add(query_588961, "projection", newJString(projection))
  add(query_588961, "project", newJString(project))
  add(query_588961, "prettyPrint", newJBool(prettyPrint))
  add(query_588961, "prefix", newJString(prefix))
  add(query_588961, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_588960.call(nil, query_588961, nil, nil, nil)

var storageBucketsList* = Call_StorageBucketsList_588725(
    name: "storageBucketsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b", validator: validate_StorageBucketsList_588726,
    base: "/storage/v1", url: url_StorageBucketsList_588727, schemes: {Scheme.Https})
type
  Call_StorageBucketsUpdate_589056 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsUpdate_589058(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsUpdate_589057(path: JsonNode; query: JsonNode;
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
  var valid_589059 = path.getOrDefault("bucket")
  valid_589059 = validateParameter(valid_589059, JString, required = true,
                                 default = nil)
  if valid_589059 != nil:
    section.add "bucket", valid_589059
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
  var valid_589060 = query.getOrDefault("fields")
  valid_589060 = validateParameter(valid_589060, JString, required = false,
                                 default = nil)
  if valid_589060 != nil:
    section.add "fields", valid_589060
  var valid_589061 = query.getOrDefault("quotaUser")
  valid_589061 = validateParameter(valid_589061, JString, required = false,
                                 default = nil)
  if valid_589061 != nil:
    section.add "quotaUser", valid_589061
  var valid_589062 = query.getOrDefault("alt")
  valid_589062 = validateParameter(valid_589062, JString, required = false,
                                 default = newJString("json"))
  if valid_589062 != nil:
    section.add "alt", valid_589062
  var valid_589063 = query.getOrDefault("oauth_token")
  valid_589063 = validateParameter(valid_589063, JString, required = false,
                                 default = nil)
  if valid_589063 != nil:
    section.add "oauth_token", valid_589063
  var valid_589064 = query.getOrDefault("userIp")
  valid_589064 = validateParameter(valid_589064, JString, required = false,
                                 default = nil)
  if valid_589064 != nil:
    section.add "userIp", valid_589064
  var valid_589065 = query.getOrDefault("predefinedAcl")
  valid_589065 = validateParameter(valid_589065, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589065 != nil:
    section.add "predefinedAcl", valid_589065
  var valid_589066 = query.getOrDefault("userProject")
  valid_589066 = validateParameter(valid_589066, JString, required = false,
                                 default = nil)
  if valid_589066 != nil:
    section.add "userProject", valid_589066
  var valid_589067 = query.getOrDefault("key")
  valid_589067 = validateParameter(valid_589067, JString, required = false,
                                 default = nil)
  if valid_589067 != nil:
    section.add "key", valid_589067
  var valid_589068 = query.getOrDefault("projection")
  valid_589068 = validateParameter(valid_589068, JString, required = false,
                                 default = newJString("full"))
  if valid_589068 != nil:
    section.add "projection", valid_589068
  var valid_589069 = query.getOrDefault("ifMetagenerationMatch")
  valid_589069 = validateParameter(valid_589069, JString, required = false,
                                 default = nil)
  if valid_589069 != nil:
    section.add "ifMetagenerationMatch", valid_589069
  var valid_589070 = query.getOrDefault("prettyPrint")
  valid_589070 = validateParameter(valid_589070, JBool, required = false,
                                 default = newJBool(true))
  if valid_589070 != nil:
    section.add "prettyPrint", valid_589070
  var valid_589071 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589071 = validateParameter(valid_589071, JString, required = false,
                                 default = nil)
  if valid_589071 != nil:
    section.add "ifMetagenerationNotMatch", valid_589071
  var valid_589072 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_589072 = validateParameter(valid_589072, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589072 != nil:
    section.add "predefinedDefaultObjectAcl", valid_589072
  var valid_589073 = query.getOrDefault("provisionalUserProject")
  valid_589073 = validateParameter(valid_589073, JString, required = false,
                                 default = nil)
  if valid_589073 != nil:
    section.add "provisionalUserProject", valid_589073
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

proc call*(call_589075: Call_StorageBucketsUpdate_589056; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_589075.validator(path, query, header, formData, body)
  let scheme = call_589075.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589075.url(scheme.get, call_589075.host, call_589075.base,
                         call_589075.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589075, url, valid)

proc call*(call_589076: Call_StorageBucketsUpdate_589056; bucket: string;
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
  var path_589077 = newJObject()
  var query_589078 = newJObject()
  var body_589079 = newJObject()
  add(path_589077, "bucket", newJString(bucket))
  add(query_589078, "fields", newJString(fields))
  add(query_589078, "quotaUser", newJString(quotaUser))
  add(query_589078, "alt", newJString(alt))
  add(query_589078, "oauth_token", newJString(oauthToken))
  add(query_589078, "userIp", newJString(userIp))
  add(query_589078, "predefinedAcl", newJString(predefinedAcl))
  add(query_589078, "userProject", newJString(userProject))
  add(query_589078, "key", newJString(key))
  add(query_589078, "projection", newJString(projection))
  add(query_589078, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_589079 = body
  add(query_589078, "prettyPrint", newJBool(prettyPrint))
  add(query_589078, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589078, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_589078, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589076.call(path_589077, query_589078, nil, nil, body_589079)

var storageBucketsUpdate* = Call_StorageBucketsUpdate_589056(
    name: "storageBucketsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsUpdate_589057, base: "/storage/v1",
    url: url_StorageBucketsUpdate_589058, schemes: {Scheme.Https})
type
  Call_StorageBucketsGet_589022 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsGet_589024(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsGet_589023(path: JsonNode; query: JsonNode;
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
  var valid_589039 = path.getOrDefault("bucket")
  valid_589039 = validateParameter(valid_589039, JString, required = true,
                                 default = nil)
  if valid_589039 != nil:
    section.add "bucket", valid_589039
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
  var valid_589040 = query.getOrDefault("fields")
  valid_589040 = validateParameter(valid_589040, JString, required = false,
                                 default = nil)
  if valid_589040 != nil:
    section.add "fields", valid_589040
  var valid_589041 = query.getOrDefault("quotaUser")
  valid_589041 = validateParameter(valid_589041, JString, required = false,
                                 default = nil)
  if valid_589041 != nil:
    section.add "quotaUser", valid_589041
  var valid_589042 = query.getOrDefault("alt")
  valid_589042 = validateParameter(valid_589042, JString, required = false,
                                 default = newJString("json"))
  if valid_589042 != nil:
    section.add "alt", valid_589042
  var valid_589043 = query.getOrDefault("oauth_token")
  valid_589043 = validateParameter(valid_589043, JString, required = false,
                                 default = nil)
  if valid_589043 != nil:
    section.add "oauth_token", valid_589043
  var valid_589044 = query.getOrDefault("userIp")
  valid_589044 = validateParameter(valid_589044, JString, required = false,
                                 default = nil)
  if valid_589044 != nil:
    section.add "userIp", valid_589044
  var valid_589045 = query.getOrDefault("userProject")
  valid_589045 = validateParameter(valid_589045, JString, required = false,
                                 default = nil)
  if valid_589045 != nil:
    section.add "userProject", valid_589045
  var valid_589046 = query.getOrDefault("key")
  valid_589046 = validateParameter(valid_589046, JString, required = false,
                                 default = nil)
  if valid_589046 != nil:
    section.add "key", valid_589046
  var valid_589047 = query.getOrDefault("projection")
  valid_589047 = validateParameter(valid_589047, JString, required = false,
                                 default = newJString("full"))
  if valid_589047 != nil:
    section.add "projection", valid_589047
  var valid_589048 = query.getOrDefault("ifMetagenerationMatch")
  valid_589048 = validateParameter(valid_589048, JString, required = false,
                                 default = nil)
  if valid_589048 != nil:
    section.add "ifMetagenerationMatch", valid_589048
  var valid_589049 = query.getOrDefault("prettyPrint")
  valid_589049 = validateParameter(valid_589049, JBool, required = false,
                                 default = newJBool(true))
  if valid_589049 != nil:
    section.add "prettyPrint", valid_589049
  var valid_589050 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589050 = validateParameter(valid_589050, JString, required = false,
                                 default = nil)
  if valid_589050 != nil:
    section.add "ifMetagenerationNotMatch", valid_589050
  var valid_589051 = query.getOrDefault("provisionalUserProject")
  valid_589051 = validateParameter(valid_589051, JString, required = false,
                                 default = nil)
  if valid_589051 != nil:
    section.add "provisionalUserProject", valid_589051
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589052: Call_StorageBucketsGet_589022; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns metadata for the specified bucket.
  ## 
  let valid = call_589052.validator(path, query, header, formData, body)
  let scheme = call_589052.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589052.url(scheme.get, call_589052.host, call_589052.base,
                         call_589052.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589052, url, valid)

proc call*(call_589053: Call_StorageBucketsGet_589022; bucket: string;
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
  var path_589054 = newJObject()
  var query_589055 = newJObject()
  add(path_589054, "bucket", newJString(bucket))
  add(query_589055, "fields", newJString(fields))
  add(query_589055, "quotaUser", newJString(quotaUser))
  add(query_589055, "alt", newJString(alt))
  add(query_589055, "oauth_token", newJString(oauthToken))
  add(query_589055, "userIp", newJString(userIp))
  add(query_589055, "userProject", newJString(userProject))
  add(query_589055, "key", newJString(key))
  add(query_589055, "projection", newJString(projection))
  add(query_589055, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589055, "prettyPrint", newJBool(prettyPrint))
  add(query_589055, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589055, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589053.call(path_589054, query_589055, nil, nil, nil)

var storageBucketsGet* = Call_StorageBucketsGet_589022(name: "storageBucketsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsGet_589023, base: "/storage/v1",
    url: url_StorageBucketsGet_589024, schemes: {Scheme.Https})
type
  Call_StorageBucketsPatch_589099 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsPatch_589101(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsPatch_589100(path: JsonNode; query: JsonNode;
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
  var valid_589102 = path.getOrDefault("bucket")
  valid_589102 = validateParameter(valid_589102, JString, required = true,
                                 default = nil)
  if valid_589102 != nil:
    section.add "bucket", valid_589102
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
  var valid_589103 = query.getOrDefault("fields")
  valid_589103 = validateParameter(valid_589103, JString, required = false,
                                 default = nil)
  if valid_589103 != nil:
    section.add "fields", valid_589103
  var valid_589104 = query.getOrDefault("quotaUser")
  valid_589104 = validateParameter(valid_589104, JString, required = false,
                                 default = nil)
  if valid_589104 != nil:
    section.add "quotaUser", valid_589104
  var valid_589105 = query.getOrDefault("alt")
  valid_589105 = validateParameter(valid_589105, JString, required = false,
                                 default = newJString("json"))
  if valid_589105 != nil:
    section.add "alt", valid_589105
  var valid_589106 = query.getOrDefault("oauth_token")
  valid_589106 = validateParameter(valid_589106, JString, required = false,
                                 default = nil)
  if valid_589106 != nil:
    section.add "oauth_token", valid_589106
  var valid_589107 = query.getOrDefault("userIp")
  valid_589107 = validateParameter(valid_589107, JString, required = false,
                                 default = nil)
  if valid_589107 != nil:
    section.add "userIp", valid_589107
  var valid_589108 = query.getOrDefault("predefinedAcl")
  valid_589108 = validateParameter(valid_589108, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589108 != nil:
    section.add "predefinedAcl", valid_589108
  var valid_589109 = query.getOrDefault("userProject")
  valid_589109 = validateParameter(valid_589109, JString, required = false,
                                 default = nil)
  if valid_589109 != nil:
    section.add "userProject", valid_589109
  var valid_589110 = query.getOrDefault("key")
  valid_589110 = validateParameter(valid_589110, JString, required = false,
                                 default = nil)
  if valid_589110 != nil:
    section.add "key", valid_589110
  var valid_589111 = query.getOrDefault("projection")
  valid_589111 = validateParameter(valid_589111, JString, required = false,
                                 default = newJString("full"))
  if valid_589111 != nil:
    section.add "projection", valid_589111
  var valid_589112 = query.getOrDefault("ifMetagenerationMatch")
  valid_589112 = validateParameter(valid_589112, JString, required = false,
                                 default = nil)
  if valid_589112 != nil:
    section.add "ifMetagenerationMatch", valid_589112
  var valid_589113 = query.getOrDefault("prettyPrint")
  valid_589113 = validateParameter(valid_589113, JBool, required = false,
                                 default = newJBool(true))
  if valid_589113 != nil:
    section.add "prettyPrint", valid_589113
  var valid_589114 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589114 = validateParameter(valid_589114, JString, required = false,
                                 default = nil)
  if valid_589114 != nil:
    section.add "ifMetagenerationNotMatch", valid_589114
  var valid_589115 = query.getOrDefault("predefinedDefaultObjectAcl")
  valid_589115 = validateParameter(valid_589115, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589115 != nil:
    section.add "predefinedDefaultObjectAcl", valid_589115
  var valid_589116 = query.getOrDefault("provisionalUserProject")
  valid_589116 = validateParameter(valid_589116, JString, required = false,
                                 default = nil)
  if valid_589116 != nil:
    section.add "provisionalUserProject", valid_589116
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

proc call*(call_589118: Call_StorageBucketsPatch_589099; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches a bucket. Changes to the bucket will be readable immediately after writing, but configuration changes may take time to propagate.
  ## 
  let valid = call_589118.validator(path, query, header, formData, body)
  let scheme = call_589118.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589118.url(scheme.get, call_589118.host, call_589118.base,
                         call_589118.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589118, url, valid)

proc call*(call_589119: Call_StorageBucketsPatch_589099; bucket: string;
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
  var path_589120 = newJObject()
  var query_589121 = newJObject()
  var body_589122 = newJObject()
  add(path_589120, "bucket", newJString(bucket))
  add(query_589121, "fields", newJString(fields))
  add(query_589121, "quotaUser", newJString(quotaUser))
  add(query_589121, "alt", newJString(alt))
  add(query_589121, "oauth_token", newJString(oauthToken))
  add(query_589121, "userIp", newJString(userIp))
  add(query_589121, "predefinedAcl", newJString(predefinedAcl))
  add(query_589121, "userProject", newJString(userProject))
  add(query_589121, "key", newJString(key))
  add(query_589121, "projection", newJString(projection))
  add(query_589121, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_589122 = body
  add(query_589121, "prettyPrint", newJBool(prettyPrint))
  add(query_589121, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589121, "predefinedDefaultObjectAcl",
      newJString(predefinedDefaultObjectAcl))
  add(query_589121, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589119.call(path_589120, query_589121, nil, nil, body_589122)

var storageBucketsPatch* = Call_StorageBucketsPatch_589099(
    name: "storageBucketsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsPatch_589100, base: "/storage/v1",
    url: url_StorageBucketsPatch_589101, schemes: {Scheme.Https})
type
  Call_StorageBucketsDelete_589080 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsDelete_589082(protocol: Scheme; host: string; base: string;
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

proc validate_StorageBucketsDelete_589081(path: JsonNode; query: JsonNode;
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
  var valid_589083 = path.getOrDefault("bucket")
  valid_589083 = validateParameter(valid_589083, JString, required = true,
                                 default = nil)
  if valid_589083 != nil:
    section.add "bucket", valid_589083
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
  var valid_589084 = query.getOrDefault("fields")
  valid_589084 = validateParameter(valid_589084, JString, required = false,
                                 default = nil)
  if valid_589084 != nil:
    section.add "fields", valid_589084
  var valid_589085 = query.getOrDefault("quotaUser")
  valid_589085 = validateParameter(valid_589085, JString, required = false,
                                 default = nil)
  if valid_589085 != nil:
    section.add "quotaUser", valid_589085
  var valid_589086 = query.getOrDefault("alt")
  valid_589086 = validateParameter(valid_589086, JString, required = false,
                                 default = newJString("json"))
  if valid_589086 != nil:
    section.add "alt", valid_589086
  var valid_589087 = query.getOrDefault("oauth_token")
  valid_589087 = validateParameter(valid_589087, JString, required = false,
                                 default = nil)
  if valid_589087 != nil:
    section.add "oauth_token", valid_589087
  var valid_589088 = query.getOrDefault("userIp")
  valid_589088 = validateParameter(valid_589088, JString, required = false,
                                 default = nil)
  if valid_589088 != nil:
    section.add "userIp", valid_589088
  var valid_589089 = query.getOrDefault("userProject")
  valid_589089 = validateParameter(valid_589089, JString, required = false,
                                 default = nil)
  if valid_589089 != nil:
    section.add "userProject", valid_589089
  var valid_589090 = query.getOrDefault("key")
  valid_589090 = validateParameter(valid_589090, JString, required = false,
                                 default = nil)
  if valid_589090 != nil:
    section.add "key", valid_589090
  var valid_589091 = query.getOrDefault("ifMetagenerationMatch")
  valid_589091 = validateParameter(valid_589091, JString, required = false,
                                 default = nil)
  if valid_589091 != nil:
    section.add "ifMetagenerationMatch", valid_589091
  var valid_589092 = query.getOrDefault("prettyPrint")
  valid_589092 = validateParameter(valid_589092, JBool, required = false,
                                 default = newJBool(true))
  if valid_589092 != nil:
    section.add "prettyPrint", valid_589092
  var valid_589093 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589093 = validateParameter(valid_589093, JString, required = false,
                                 default = nil)
  if valid_589093 != nil:
    section.add "ifMetagenerationNotMatch", valid_589093
  var valid_589094 = query.getOrDefault("provisionalUserProject")
  valid_589094 = validateParameter(valid_589094, JString, required = false,
                                 default = nil)
  if valid_589094 != nil:
    section.add "provisionalUserProject", valid_589094
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589095: Call_StorageBucketsDelete_589080; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes an empty bucket.
  ## 
  let valid = call_589095.validator(path, query, header, formData, body)
  let scheme = call_589095.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589095.url(scheme.get, call_589095.host, call_589095.base,
                         call_589095.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589095, url, valid)

proc call*(call_589096: Call_StorageBucketsDelete_589080; bucket: string;
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
  var path_589097 = newJObject()
  var query_589098 = newJObject()
  add(path_589097, "bucket", newJString(bucket))
  add(query_589098, "fields", newJString(fields))
  add(query_589098, "quotaUser", newJString(quotaUser))
  add(query_589098, "alt", newJString(alt))
  add(query_589098, "oauth_token", newJString(oauthToken))
  add(query_589098, "userIp", newJString(userIp))
  add(query_589098, "userProject", newJString(userProject))
  add(query_589098, "key", newJString(key))
  add(query_589098, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589098, "prettyPrint", newJBool(prettyPrint))
  add(query_589098, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589098, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589096.call(path_589097, query_589098, nil, nil, nil)

var storageBucketsDelete* = Call_StorageBucketsDelete_589080(
    name: "storageBucketsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}",
    validator: validate_StorageBucketsDelete_589081, base: "/storage/v1",
    url: url_StorageBucketsDelete_589082, schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsInsert_589140 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsInsert_589142(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsInsert_589141(path: JsonNode;
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
  var valid_589143 = path.getOrDefault("bucket")
  valid_589143 = validateParameter(valid_589143, JString, required = true,
                                 default = nil)
  if valid_589143 != nil:
    section.add "bucket", valid_589143
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
  var valid_589144 = query.getOrDefault("fields")
  valid_589144 = validateParameter(valid_589144, JString, required = false,
                                 default = nil)
  if valid_589144 != nil:
    section.add "fields", valid_589144
  var valid_589145 = query.getOrDefault("quotaUser")
  valid_589145 = validateParameter(valid_589145, JString, required = false,
                                 default = nil)
  if valid_589145 != nil:
    section.add "quotaUser", valid_589145
  var valid_589146 = query.getOrDefault("alt")
  valid_589146 = validateParameter(valid_589146, JString, required = false,
                                 default = newJString("json"))
  if valid_589146 != nil:
    section.add "alt", valid_589146
  var valid_589147 = query.getOrDefault("oauth_token")
  valid_589147 = validateParameter(valid_589147, JString, required = false,
                                 default = nil)
  if valid_589147 != nil:
    section.add "oauth_token", valid_589147
  var valid_589148 = query.getOrDefault("userIp")
  valid_589148 = validateParameter(valid_589148, JString, required = false,
                                 default = nil)
  if valid_589148 != nil:
    section.add "userIp", valid_589148
  var valid_589149 = query.getOrDefault("userProject")
  valid_589149 = validateParameter(valid_589149, JString, required = false,
                                 default = nil)
  if valid_589149 != nil:
    section.add "userProject", valid_589149
  var valid_589150 = query.getOrDefault("key")
  valid_589150 = validateParameter(valid_589150, JString, required = false,
                                 default = nil)
  if valid_589150 != nil:
    section.add "key", valid_589150
  var valid_589151 = query.getOrDefault("prettyPrint")
  valid_589151 = validateParameter(valid_589151, JBool, required = false,
                                 default = newJBool(true))
  if valid_589151 != nil:
    section.add "prettyPrint", valid_589151
  var valid_589152 = query.getOrDefault("provisionalUserProject")
  valid_589152 = validateParameter(valid_589152, JString, required = false,
                                 default = nil)
  if valid_589152 != nil:
    section.add "provisionalUserProject", valid_589152
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

proc call*(call_589154: Call_StorageBucketAccessControlsInsert_589140;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified bucket.
  ## 
  let valid = call_589154.validator(path, query, header, formData, body)
  let scheme = call_589154.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589154.url(scheme.get, call_589154.host, call_589154.base,
                         call_589154.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589154, url, valid)

proc call*(call_589155: Call_StorageBucketAccessControlsInsert_589140;
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
  var path_589156 = newJObject()
  var query_589157 = newJObject()
  var body_589158 = newJObject()
  add(path_589156, "bucket", newJString(bucket))
  add(query_589157, "fields", newJString(fields))
  add(query_589157, "quotaUser", newJString(quotaUser))
  add(query_589157, "alt", newJString(alt))
  add(query_589157, "oauth_token", newJString(oauthToken))
  add(query_589157, "userIp", newJString(userIp))
  add(query_589157, "userProject", newJString(userProject))
  add(query_589157, "key", newJString(key))
  if body != nil:
    body_589158 = body
  add(query_589157, "prettyPrint", newJBool(prettyPrint))
  add(query_589157, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589155.call(path_589156, query_589157, nil, nil, body_589158)

var storageBucketAccessControlsInsert* = Call_StorageBucketAccessControlsInsert_589140(
    name: "storageBucketAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsInsert_589141,
    base: "/storage/v1", url: url_StorageBucketAccessControlsInsert_589142,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsList_589123 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsList_589125(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsList_589124(path: JsonNode;
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
  var valid_589126 = path.getOrDefault("bucket")
  valid_589126 = validateParameter(valid_589126, JString, required = true,
                                 default = nil)
  if valid_589126 != nil:
    section.add "bucket", valid_589126
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
  var valid_589127 = query.getOrDefault("fields")
  valid_589127 = validateParameter(valid_589127, JString, required = false,
                                 default = nil)
  if valid_589127 != nil:
    section.add "fields", valid_589127
  var valid_589128 = query.getOrDefault("quotaUser")
  valid_589128 = validateParameter(valid_589128, JString, required = false,
                                 default = nil)
  if valid_589128 != nil:
    section.add "quotaUser", valid_589128
  var valid_589129 = query.getOrDefault("alt")
  valid_589129 = validateParameter(valid_589129, JString, required = false,
                                 default = newJString("json"))
  if valid_589129 != nil:
    section.add "alt", valid_589129
  var valid_589130 = query.getOrDefault("oauth_token")
  valid_589130 = validateParameter(valid_589130, JString, required = false,
                                 default = nil)
  if valid_589130 != nil:
    section.add "oauth_token", valid_589130
  var valid_589131 = query.getOrDefault("userIp")
  valid_589131 = validateParameter(valid_589131, JString, required = false,
                                 default = nil)
  if valid_589131 != nil:
    section.add "userIp", valid_589131
  var valid_589132 = query.getOrDefault("userProject")
  valid_589132 = validateParameter(valid_589132, JString, required = false,
                                 default = nil)
  if valid_589132 != nil:
    section.add "userProject", valid_589132
  var valid_589133 = query.getOrDefault("key")
  valid_589133 = validateParameter(valid_589133, JString, required = false,
                                 default = nil)
  if valid_589133 != nil:
    section.add "key", valid_589133
  var valid_589134 = query.getOrDefault("prettyPrint")
  valid_589134 = validateParameter(valid_589134, JBool, required = false,
                                 default = newJBool(true))
  if valid_589134 != nil:
    section.add "prettyPrint", valid_589134
  var valid_589135 = query.getOrDefault("provisionalUserProject")
  valid_589135 = validateParameter(valid_589135, JString, required = false,
                                 default = nil)
  if valid_589135 != nil:
    section.add "provisionalUserProject", valid_589135
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589136: Call_StorageBucketAccessControlsList_589123;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified bucket.
  ## 
  let valid = call_589136.validator(path, query, header, formData, body)
  let scheme = call_589136.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589136.url(scheme.get, call_589136.host, call_589136.base,
                         call_589136.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589136, url, valid)

proc call*(call_589137: Call_StorageBucketAccessControlsList_589123;
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
  var path_589138 = newJObject()
  var query_589139 = newJObject()
  add(path_589138, "bucket", newJString(bucket))
  add(query_589139, "fields", newJString(fields))
  add(query_589139, "quotaUser", newJString(quotaUser))
  add(query_589139, "alt", newJString(alt))
  add(query_589139, "oauth_token", newJString(oauthToken))
  add(query_589139, "userIp", newJString(userIp))
  add(query_589139, "userProject", newJString(userProject))
  add(query_589139, "key", newJString(key))
  add(query_589139, "prettyPrint", newJBool(prettyPrint))
  add(query_589139, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589137.call(path_589138, query_589139, nil, nil, nil)

var storageBucketAccessControlsList* = Call_StorageBucketAccessControlsList_589123(
    name: "storageBucketAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl",
    validator: validate_StorageBucketAccessControlsList_589124,
    base: "/storage/v1", url: url_StorageBucketAccessControlsList_589125,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsUpdate_589177 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsUpdate_589179(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsUpdate_589178(path: JsonNode;
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
  var valid_589180 = path.getOrDefault("bucket")
  valid_589180 = validateParameter(valid_589180, JString, required = true,
                                 default = nil)
  if valid_589180 != nil:
    section.add "bucket", valid_589180
  var valid_589181 = path.getOrDefault("entity")
  valid_589181 = validateParameter(valid_589181, JString, required = true,
                                 default = nil)
  if valid_589181 != nil:
    section.add "entity", valid_589181
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
  var valid_589182 = query.getOrDefault("fields")
  valid_589182 = validateParameter(valid_589182, JString, required = false,
                                 default = nil)
  if valid_589182 != nil:
    section.add "fields", valid_589182
  var valid_589183 = query.getOrDefault("quotaUser")
  valid_589183 = validateParameter(valid_589183, JString, required = false,
                                 default = nil)
  if valid_589183 != nil:
    section.add "quotaUser", valid_589183
  var valid_589184 = query.getOrDefault("alt")
  valid_589184 = validateParameter(valid_589184, JString, required = false,
                                 default = newJString("json"))
  if valid_589184 != nil:
    section.add "alt", valid_589184
  var valid_589185 = query.getOrDefault("oauth_token")
  valid_589185 = validateParameter(valid_589185, JString, required = false,
                                 default = nil)
  if valid_589185 != nil:
    section.add "oauth_token", valid_589185
  var valid_589186 = query.getOrDefault("userIp")
  valid_589186 = validateParameter(valid_589186, JString, required = false,
                                 default = nil)
  if valid_589186 != nil:
    section.add "userIp", valid_589186
  var valid_589187 = query.getOrDefault("userProject")
  valid_589187 = validateParameter(valid_589187, JString, required = false,
                                 default = nil)
  if valid_589187 != nil:
    section.add "userProject", valid_589187
  var valid_589188 = query.getOrDefault("key")
  valid_589188 = validateParameter(valid_589188, JString, required = false,
                                 default = nil)
  if valid_589188 != nil:
    section.add "key", valid_589188
  var valid_589189 = query.getOrDefault("prettyPrint")
  valid_589189 = validateParameter(valid_589189, JBool, required = false,
                                 default = newJBool(true))
  if valid_589189 != nil:
    section.add "prettyPrint", valid_589189
  var valid_589190 = query.getOrDefault("provisionalUserProject")
  valid_589190 = validateParameter(valid_589190, JString, required = false,
                                 default = nil)
  if valid_589190 != nil:
    section.add "provisionalUserProject", valid_589190
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

proc call*(call_589192: Call_StorageBucketAccessControlsUpdate_589177;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified bucket.
  ## 
  let valid = call_589192.validator(path, query, header, formData, body)
  let scheme = call_589192.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589192.url(scheme.get, call_589192.host, call_589192.base,
                         call_589192.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589192, url, valid)

proc call*(call_589193: Call_StorageBucketAccessControlsUpdate_589177;
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
  var path_589194 = newJObject()
  var query_589195 = newJObject()
  var body_589196 = newJObject()
  add(path_589194, "bucket", newJString(bucket))
  add(query_589195, "fields", newJString(fields))
  add(query_589195, "quotaUser", newJString(quotaUser))
  add(query_589195, "alt", newJString(alt))
  add(query_589195, "oauth_token", newJString(oauthToken))
  add(query_589195, "userIp", newJString(userIp))
  add(query_589195, "userProject", newJString(userProject))
  add(query_589195, "key", newJString(key))
  if body != nil:
    body_589196 = body
  add(query_589195, "prettyPrint", newJBool(prettyPrint))
  add(path_589194, "entity", newJString(entity))
  add(query_589195, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589193.call(path_589194, query_589195, nil, nil, body_589196)

var storageBucketAccessControlsUpdate* = Call_StorageBucketAccessControlsUpdate_589177(
    name: "storageBucketAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsUpdate_589178,
    base: "/storage/v1", url: url_StorageBucketAccessControlsUpdate_589179,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsGet_589159 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsGet_589161(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsGet_589160(path: JsonNode;
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
  var valid_589162 = path.getOrDefault("bucket")
  valid_589162 = validateParameter(valid_589162, JString, required = true,
                                 default = nil)
  if valid_589162 != nil:
    section.add "bucket", valid_589162
  var valid_589163 = path.getOrDefault("entity")
  valid_589163 = validateParameter(valid_589163, JString, required = true,
                                 default = nil)
  if valid_589163 != nil:
    section.add "entity", valid_589163
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
  var valid_589164 = query.getOrDefault("fields")
  valid_589164 = validateParameter(valid_589164, JString, required = false,
                                 default = nil)
  if valid_589164 != nil:
    section.add "fields", valid_589164
  var valid_589165 = query.getOrDefault("quotaUser")
  valid_589165 = validateParameter(valid_589165, JString, required = false,
                                 default = nil)
  if valid_589165 != nil:
    section.add "quotaUser", valid_589165
  var valid_589166 = query.getOrDefault("alt")
  valid_589166 = validateParameter(valid_589166, JString, required = false,
                                 default = newJString("json"))
  if valid_589166 != nil:
    section.add "alt", valid_589166
  var valid_589167 = query.getOrDefault("oauth_token")
  valid_589167 = validateParameter(valid_589167, JString, required = false,
                                 default = nil)
  if valid_589167 != nil:
    section.add "oauth_token", valid_589167
  var valid_589168 = query.getOrDefault("userIp")
  valid_589168 = validateParameter(valid_589168, JString, required = false,
                                 default = nil)
  if valid_589168 != nil:
    section.add "userIp", valid_589168
  var valid_589169 = query.getOrDefault("userProject")
  valid_589169 = validateParameter(valid_589169, JString, required = false,
                                 default = nil)
  if valid_589169 != nil:
    section.add "userProject", valid_589169
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
  var valid_589172 = query.getOrDefault("provisionalUserProject")
  valid_589172 = validateParameter(valid_589172, JString, required = false,
                                 default = nil)
  if valid_589172 != nil:
    section.add "provisionalUserProject", valid_589172
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589173: Call_StorageBucketAccessControlsGet_589159; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_589173.validator(path, query, header, formData, body)
  let scheme = call_589173.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589173.url(scheme.get, call_589173.host, call_589173.base,
                         call_589173.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589173, url, valid)

proc call*(call_589174: Call_StorageBucketAccessControlsGet_589159; bucket: string;
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
  var path_589175 = newJObject()
  var query_589176 = newJObject()
  add(path_589175, "bucket", newJString(bucket))
  add(query_589176, "fields", newJString(fields))
  add(query_589176, "quotaUser", newJString(quotaUser))
  add(query_589176, "alt", newJString(alt))
  add(query_589176, "oauth_token", newJString(oauthToken))
  add(query_589176, "userIp", newJString(userIp))
  add(query_589176, "userProject", newJString(userProject))
  add(query_589176, "key", newJString(key))
  add(query_589176, "prettyPrint", newJBool(prettyPrint))
  add(path_589175, "entity", newJString(entity))
  add(query_589176, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589174.call(path_589175, query_589176, nil, nil, nil)

var storageBucketAccessControlsGet* = Call_StorageBucketAccessControlsGet_589159(
    name: "storageBucketAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsGet_589160,
    base: "/storage/v1", url: url_StorageBucketAccessControlsGet_589161,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsPatch_589215 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsPatch_589217(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsPatch_589216(path: JsonNode;
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
  var valid_589218 = path.getOrDefault("bucket")
  valid_589218 = validateParameter(valid_589218, JString, required = true,
                                 default = nil)
  if valid_589218 != nil:
    section.add "bucket", valid_589218
  var valid_589219 = path.getOrDefault("entity")
  valid_589219 = validateParameter(valid_589219, JString, required = true,
                                 default = nil)
  if valid_589219 != nil:
    section.add "entity", valid_589219
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
  var valid_589220 = query.getOrDefault("fields")
  valid_589220 = validateParameter(valid_589220, JString, required = false,
                                 default = nil)
  if valid_589220 != nil:
    section.add "fields", valid_589220
  var valid_589221 = query.getOrDefault("quotaUser")
  valid_589221 = validateParameter(valid_589221, JString, required = false,
                                 default = nil)
  if valid_589221 != nil:
    section.add "quotaUser", valid_589221
  var valid_589222 = query.getOrDefault("alt")
  valid_589222 = validateParameter(valid_589222, JString, required = false,
                                 default = newJString("json"))
  if valid_589222 != nil:
    section.add "alt", valid_589222
  var valid_589223 = query.getOrDefault("oauth_token")
  valid_589223 = validateParameter(valid_589223, JString, required = false,
                                 default = nil)
  if valid_589223 != nil:
    section.add "oauth_token", valid_589223
  var valid_589224 = query.getOrDefault("userIp")
  valid_589224 = validateParameter(valid_589224, JString, required = false,
                                 default = nil)
  if valid_589224 != nil:
    section.add "userIp", valid_589224
  var valid_589225 = query.getOrDefault("userProject")
  valid_589225 = validateParameter(valid_589225, JString, required = false,
                                 default = nil)
  if valid_589225 != nil:
    section.add "userProject", valid_589225
  var valid_589226 = query.getOrDefault("key")
  valid_589226 = validateParameter(valid_589226, JString, required = false,
                                 default = nil)
  if valid_589226 != nil:
    section.add "key", valid_589226
  var valid_589227 = query.getOrDefault("prettyPrint")
  valid_589227 = validateParameter(valid_589227, JBool, required = false,
                                 default = newJBool(true))
  if valid_589227 != nil:
    section.add "prettyPrint", valid_589227
  var valid_589228 = query.getOrDefault("provisionalUserProject")
  valid_589228 = validateParameter(valid_589228, JString, required = false,
                                 default = nil)
  if valid_589228 != nil:
    section.add "provisionalUserProject", valid_589228
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

proc call*(call_589230: Call_StorageBucketAccessControlsPatch_589215;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified bucket.
  ## 
  let valid = call_589230.validator(path, query, header, formData, body)
  let scheme = call_589230.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589230.url(scheme.get, call_589230.host, call_589230.base,
                         call_589230.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589230, url, valid)

proc call*(call_589231: Call_StorageBucketAccessControlsPatch_589215;
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
  var path_589232 = newJObject()
  var query_589233 = newJObject()
  var body_589234 = newJObject()
  add(path_589232, "bucket", newJString(bucket))
  add(query_589233, "fields", newJString(fields))
  add(query_589233, "quotaUser", newJString(quotaUser))
  add(query_589233, "alt", newJString(alt))
  add(query_589233, "oauth_token", newJString(oauthToken))
  add(query_589233, "userIp", newJString(userIp))
  add(query_589233, "userProject", newJString(userProject))
  add(query_589233, "key", newJString(key))
  if body != nil:
    body_589234 = body
  add(query_589233, "prettyPrint", newJBool(prettyPrint))
  add(path_589232, "entity", newJString(entity))
  add(query_589233, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589231.call(path_589232, query_589233, nil, nil, body_589234)

var storageBucketAccessControlsPatch* = Call_StorageBucketAccessControlsPatch_589215(
    name: "storageBucketAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsPatch_589216,
    base: "/storage/v1", url: url_StorageBucketAccessControlsPatch_589217,
    schemes: {Scheme.Https})
type
  Call_StorageBucketAccessControlsDelete_589197 = ref object of OpenApiRestCall_588457
proc url_StorageBucketAccessControlsDelete_589199(protocol: Scheme; host: string;
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

proc validate_StorageBucketAccessControlsDelete_589198(path: JsonNode;
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
  var valid_589200 = path.getOrDefault("bucket")
  valid_589200 = validateParameter(valid_589200, JString, required = true,
                                 default = nil)
  if valid_589200 != nil:
    section.add "bucket", valid_589200
  var valid_589201 = path.getOrDefault("entity")
  valid_589201 = validateParameter(valid_589201, JString, required = true,
                                 default = nil)
  if valid_589201 != nil:
    section.add "entity", valid_589201
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
  var valid_589202 = query.getOrDefault("fields")
  valid_589202 = validateParameter(valid_589202, JString, required = false,
                                 default = nil)
  if valid_589202 != nil:
    section.add "fields", valid_589202
  var valid_589203 = query.getOrDefault("quotaUser")
  valid_589203 = validateParameter(valid_589203, JString, required = false,
                                 default = nil)
  if valid_589203 != nil:
    section.add "quotaUser", valid_589203
  var valid_589204 = query.getOrDefault("alt")
  valid_589204 = validateParameter(valid_589204, JString, required = false,
                                 default = newJString("json"))
  if valid_589204 != nil:
    section.add "alt", valid_589204
  var valid_589205 = query.getOrDefault("oauth_token")
  valid_589205 = validateParameter(valid_589205, JString, required = false,
                                 default = nil)
  if valid_589205 != nil:
    section.add "oauth_token", valid_589205
  var valid_589206 = query.getOrDefault("userIp")
  valid_589206 = validateParameter(valid_589206, JString, required = false,
                                 default = nil)
  if valid_589206 != nil:
    section.add "userIp", valid_589206
  var valid_589207 = query.getOrDefault("userProject")
  valid_589207 = validateParameter(valid_589207, JString, required = false,
                                 default = nil)
  if valid_589207 != nil:
    section.add "userProject", valid_589207
  var valid_589208 = query.getOrDefault("key")
  valid_589208 = validateParameter(valid_589208, JString, required = false,
                                 default = nil)
  if valid_589208 != nil:
    section.add "key", valid_589208
  var valid_589209 = query.getOrDefault("prettyPrint")
  valid_589209 = validateParameter(valid_589209, JBool, required = false,
                                 default = newJBool(true))
  if valid_589209 != nil:
    section.add "prettyPrint", valid_589209
  var valid_589210 = query.getOrDefault("provisionalUserProject")
  valid_589210 = validateParameter(valid_589210, JString, required = false,
                                 default = nil)
  if valid_589210 != nil:
    section.add "provisionalUserProject", valid_589210
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589211: Call_StorageBucketAccessControlsDelete_589197;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_589211.validator(path, query, header, formData, body)
  let scheme = call_589211.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589211.url(scheme.get, call_589211.host, call_589211.base,
                         call_589211.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589211, url, valid)

proc call*(call_589212: Call_StorageBucketAccessControlsDelete_589197;
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
  var path_589213 = newJObject()
  var query_589214 = newJObject()
  add(path_589213, "bucket", newJString(bucket))
  add(query_589214, "fields", newJString(fields))
  add(query_589214, "quotaUser", newJString(quotaUser))
  add(query_589214, "alt", newJString(alt))
  add(query_589214, "oauth_token", newJString(oauthToken))
  add(query_589214, "userIp", newJString(userIp))
  add(query_589214, "userProject", newJString(userProject))
  add(query_589214, "key", newJString(key))
  add(query_589214, "prettyPrint", newJBool(prettyPrint))
  add(path_589213, "entity", newJString(entity))
  add(query_589214, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589212.call(path_589213, query_589214, nil, nil, nil)

var storageBucketAccessControlsDelete* = Call_StorageBucketAccessControlsDelete_589197(
    name: "storageBucketAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/acl/{entity}",
    validator: validate_StorageBucketAccessControlsDelete_589198,
    base: "/storage/v1", url: url_StorageBucketAccessControlsDelete_589199,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsInsert_589254 = ref object of OpenApiRestCall_588457
proc url_StorageDefaultObjectAccessControlsInsert_589256(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsInsert_589255(path: JsonNode;
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
  var valid_589257 = path.getOrDefault("bucket")
  valid_589257 = validateParameter(valid_589257, JString, required = true,
                                 default = nil)
  if valid_589257 != nil:
    section.add "bucket", valid_589257
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
  var valid_589258 = query.getOrDefault("fields")
  valid_589258 = validateParameter(valid_589258, JString, required = false,
                                 default = nil)
  if valid_589258 != nil:
    section.add "fields", valid_589258
  var valid_589259 = query.getOrDefault("quotaUser")
  valid_589259 = validateParameter(valid_589259, JString, required = false,
                                 default = nil)
  if valid_589259 != nil:
    section.add "quotaUser", valid_589259
  var valid_589260 = query.getOrDefault("alt")
  valid_589260 = validateParameter(valid_589260, JString, required = false,
                                 default = newJString("json"))
  if valid_589260 != nil:
    section.add "alt", valid_589260
  var valid_589261 = query.getOrDefault("oauth_token")
  valid_589261 = validateParameter(valid_589261, JString, required = false,
                                 default = nil)
  if valid_589261 != nil:
    section.add "oauth_token", valid_589261
  var valid_589262 = query.getOrDefault("userIp")
  valid_589262 = validateParameter(valid_589262, JString, required = false,
                                 default = nil)
  if valid_589262 != nil:
    section.add "userIp", valid_589262
  var valid_589263 = query.getOrDefault("userProject")
  valid_589263 = validateParameter(valid_589263, JString, required = false,
                                 default = nil)
  if valid_589263 != nil:
    section.add "userProject", valid_589263
  var valid_589264 = query.getOrDefault("key")
  valid_589264 = validateParameter(valid_589264, JString, required = false,
                                 default = nil)
  if valid_589264 != nil:
    section.add "key", valid_589264
  var valid_589265 = query.getOrDefault("prettyPrint")
  valid_589265 = validateParameter(valid_589265, JBool, required = false,
                                 default = newJBool(true))
  if valid_589265 != nil:
    section.add "prettyPrint", valid_589265
  var valid_589266 = query.getOrDefault("provisionalUserProject")
  valid_589266 = validateParameter(valid_589266, JString, required = false,
                                 default = nil)
  if valid_589266 != nil:
    section.add "provisionalUserProject", valid_589266
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

proc call*(call_589268: Call_StorageDefaultObjectAccessControlsInsert_589254;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new default object ACL entry on the specified bucket.
  ## 
  let valid = call_589268.validator(path, query, header, formData, body)
  let scheme = call_589268.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589268.url(scheme.get, call_589268.host, call_589268.base,
                         call_589268.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589268, url, valid)

proc call*(call_589269: Call_StorageDefaultObjectAccessControlsInsert_589254;
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
  var path_589270 = newJObject()
  var query_589271 = newJObject()
  var body_589272 = newJObject()
  add(path_589270, "bucket", newJString(bucket))
  add(query_589271, "fields", newJString(fields))
  add(query_589271, "quotaUser", newJString(quotaUser))
  add(query_589271, "alt", newJString(alt))
  add(query_589271, "oauth_token", newJString(oauthToken))
  add(query_589271, "userIp", newJString(userIp))
  add(query_589271, "userProject", newJString(userProject))
  add(query_589271, "key", newJString(key))
  if body != nil:
    body_589272 = body
  add(query_589271, "prettyPrint", newJBool(prettyPrint))
  add(query_589271, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589269.call(path_589270, query_589271, nil, nil, body_589272)

var storageDefaultObjectAccessControlsInsert* = Call_StorageDefaultObjectAccessControlsInsert_589254(
    name: "storageDefaultObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsInsert_589255,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsInsert_589256,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsList_589235 = ref object of OpenApiRestCall_588457
proc url_StorageDefaultObjectAccessControlsList_589237(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsList_589236(path: JsonNode;
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
  var valid_589238 = path.getOrDefault("bucket")
  valid_589238 = validateParameter(valid_589238, JString, required = true,
                                 default = nil)
  if valid_589238 != nil:
    section.add "bucket", valid_589238
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
  var valid_589239 = query.getOrDefault("fields")
  valid_589239 = validateParameter(valid_589239, JString, required = false,
                                 default = nil)
  if valid_589239 != nil:
    section.add "fields", valid_589239
  var valid_589240 = query.getOrDefault("quotaUser")
  valid_589240 = validateParameter(valid_589240, JString, required = false,
                                 default = nil)
  if valid_589240 != nil:
    section.add "quotaUser", valid_589240
  var valid_589241 = query.getOrDefault("alt")
  valid_589241 = validateParameter(valid_589241, JString, required = false,
                                 default = newJString("json"))
  if valid_589241 != nil:
    section.add "alt", valid_589241
  var valid_589242 = query.getOrDefault("oauth_token")
  valid_589242 = validateParameter(valid_589242, JString, required = false,
                                 default = nil)
  if valid_589242 != nil:
    section.add "oauth_token", valid_589242
  var valid_589243 = query.getOrDefault("userIp")
  valid_589243 = validateParameter(valid_589243, JString, required = false,
                                 default = nil)
  if valid_589243 != nil:
    section.add "userIp", valid_589243
  var valid_589244 = query.getOrDefault("userProject")
  valid_589244 = validateParameter(valid_589244, JString, required = false,
                                 default = nil)
  if valid_589244 != nil:
    section.add "userProject", valid_589244
  var valid_589245 = query.getOrDefault("key")
  valid_589245 = validateParameter(valid_589245, JString, required = false,
                                 default = nil)
  if valid_589245 != nil:
    section.add "key", valid_589245
  var valid_589246 = query.getOrDefault("ifMetagenerationMatch")
  valid_589246 = validateParameter(valid_589246, JString, required = false,
                                 default = nil)
  if valid_589246 != nil:
    section.add "ifMetagenerationMatch", valid_589246
  var valid_589247 = query.getOrDefault("prettyPrint")
  valid_589247 = validateParameter(valid_589247, JBool, required = false,
                                 default = newJBool(true))
  if valid_589247 != nil:
    section.add "prettyPrint", valid_589247
  var valid_589248 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589248 = validateParameter(valid_589248, JString, required = false,
                                 default = nil)
  if valid_589248 != nil:
    section.add "ifMetagenerationNotMatch", valid_589248
  var valid_589249 = query.getOrDefault("provisionalUserProject")
  valid_589249 = validateParameter(valid_589249, JString, required = false,
                                 default = nil)
  if valid_589249 != nil:
    section.add "provisionalUserProject", valid_589249
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589250: Call_StorageDefaultObjectAccessControlsList_589235;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves default object ACL entries on the specified bucket.
  ## 
  let valid = call_589250.validator(path, query, header, formData, body)
  let scheme = call_589250.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589250.url(scheme.get, call_589250.host, call_589250.base,
                         call_589250.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589250, url, valid)

proc call*(call_589251: Call_StorageDefaultObjectAccessControlsList_589235;
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
  var path_589252 = newJObject()
  var query_589253 = newJObject()
  add(path_589252, "bucket", newJString(bucket))
  add(query_589253, "fields", newJString(fields))
  add(query_589253, "quotaUser", newJString(quotaUser))
  add(query_589253, "alt", newJString(alt))
  add(query_589253, "oauth_token", newJString(oauthToken))
  add(query_589253, "userIp", newJString(userIp))
  add(query_589253, "userProject", newJString(userProject))
  add(query_589253, "key", newJString(key))
  add(query_589253, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589253, "prettyPrint", newJBool(prettyPrint))
  add(query_589253, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589253, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589251.call(path_589252, query_589253, nil, nil, nil)

var storageDefaultObjectAccessControlsList* = Call_StorageDefaultObjectAccessControlsList_589235(
    name: "storageDefaultObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl",
    validator: validate_StorageDefaultObjectAccessControlsList_589236,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsList_589237,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsUpdate_589291 = ref object of OpenApiRestCall_588457
proc url_StorageDefaultObjectAccessControlsUpdate_589293(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsUpdate_589292(path: JsonNode;
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
  var valid_589294 = path.getOrDefault("bucket")
  valid_589294 = validateParameter(valid_589294, JString, required = true,
                                 default = nil)
  if valid_589294 != nil:
    section.add "bucket", valid_589294
  var valid_589295 = path.getOrDefault("entity")
  valid_589295 = validateParameter(valid_589295, JString, required = true,
                                 default = nil)
  if valid_589295 != nil:
    section.add "entity", valid_589295
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
  var valid_589296 = query.getOrDefault("fields")
  valid_589296 = validateParameter(valid_589296, JString, required = false,
                                 default = nil)
  if valid_589296 != nil:
    section.add "fields", valid_589296
  var valid_589297 = query.getOrDefault("quotaUser")
  valid_589297 = validateParameter(valid_589297, JString, required = false,
                                 default = nil)
  if valid_589297 != nil:
    section.add "quotaUser", valid_589297
  var valid_589298 = query.getOrDefault("alt")
  valid_589298 = validateParameter(valid_589298, JString, required = false,
                                 default = newJString("json"))
  if valid_589298 != nil:
    section.add "alt", valid_589298
  var valid_589299 = query.getOrDefault("oauth_token")
  valid_589299 = validateParameter(valid_589299, JString, required = false,
                                 default = nil)
  if valid_589299 != nil:
    section.add "oauth_token", valid_589299
  var valid_589300 = query.getOrDefault("userIp")
  valid_589300 = validateParameter(valid_589300, JString, required = false,
                                 default = nil)
  if valid_589300 != nil:
    section.add "userIp", valid_589300
  var valid_589301 = query.getOrDefault("userProject")
  valid_589301 = validateParameter(valid_589301, JString, required = false,
                                 default = nil)
  if valid_589301 != nil:
    section.add "userProject", valid_589301
  var valid_589302 = query.getOrDefault("key")
  valid_589302 = validateParameter(valid_589302, JString, required = false,
                                 default = nil)
  if valid_589302 != nil:
    section.add "key", valid_589302
  var valid_589303 = query.getOrDefault("prettyPrint")
  valid_589303 = validateParameter(valid_589303, JBool, required = false,
                                 default = newJBool(true))
  if valid_589303 != nil:
    section.add "prettyPrint", valid_589303
  var valid_589304 = query.getOrDefault("provisionalUserProject")
  valid_589304 = validateParameter(valid_589304, JString, required = false,
                                 default = nil)
  if valid_589304 != nil:
    section.add "provisionalUserProject", valid_589304
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

proc call*(call_589306: Call_StorageDefaultObjectAccessControlsUpdate_589291;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates a default object ACL entry on the specified bucket.
  ## 
  let valid = call_589306.validator(path, query, header, formData, body)
  let scheme = call_589306.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589306.url(scheme.get, call_589306.host, call_589306.base,
                         call_589306.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589306, url, valid)

proc call*(call_589307: Call_StorageDefaultObjectAccessControlsUpdate_589291;
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
  var path_589308 = newJObject()
  var query_589309 = newJObject()
  var body_589310 = newJObject()
  add(path_589308, "bucket", newJString(bucket))
  add(query_589309, "fields", newJString(fields))
  add(query_589309, "quotaUser", newJString(quotaUser))
  add(query_589309, "alt", newJString(alt))
  add(query_589309, "oauth_token", newJString(oauthToken))
  add(query_589309, "userIp", newJString(userIp))
  add(query_589309, "userProject", newJString(userProject))
  add(query_589309, "key", newJString(key))
  if body != nil:
    body_589310 = body
  add(query_589309, "prettyPrint", newJBool(prettyPrint))
  add(path_589308, "entity", newJString(entity))
  add(query_589309, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589307.call(path_589308, query_589309, nil, nil, body_589310)

var storageDefaultObjectAccessControlsUpdate* = Call_StorageDefaultObjectAccessControlsUpdate_589291(
    name: "storageDefaultObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsUpdate_589292,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsUpdate_589293,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsGet_589273 = ref object of OpenApiRestCall_588457
proc url_StorageDefaultObjectAccessControlsGet_589275(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsGet_589274(path: JsonNode;
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
  var valid_589276 = path.getOrDefault("bucket")
  valid_589276 = validateParameter(valid_589276, JString, required = true,
                                 default = nil)
  if valid_589276 != nil:
    section.add "bucket", valid_589276
  var valid_589277 = path.getOrDefault("entity")
  valid_589277 = validateParameter(valid_589277, JString, required = true,
                                 default = nil)
  if valid_589277 != nil:
    section.add "entity", valid_589277
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
  var valid_589278 = query.getOrDefault("fields")
  valid_589278 = validateParameter(valid_589278, JString, required = false,
                                 default = nil)
  if valid_589278 != nil:
    section.add "fields", valid_589278
  var valid_589279 = query.getOrDefault("quotaUser")
  valid_589279 = validateParameter(valid_589279, JString, required = false,
                                 default = nil)
  if valid_589279 != nil:
    section.add "quotaUser", valid_589279
  var valid_589280 = query.getOrDefault("alt")
  valid_589280 = validateParameter(valid_589280, JString, required = false,
                                 default = newJString("json"))
  if valid_589280 != nil:
    section.add "alt", valid_589280
  var valid_589281 = query.getOrDefault("oauth_token")
  valid_589281 = validateParameter(valid_589281, JString, required = false,
                                 default = nil)
  if valid_589281 != nil:
    section.add "oauth_token", valid_589281
  var valid_589282 = query.getOrDefault("userIp")
  valid_589282 = validateParameter(valid_589282, JString, required = false,
                                 default = nil)
  if valid_589282 != nil:
    section.add "userIp", valid_589282
  var valid_589283 = query.getOrDefault("userProject")
  valid_589283 = validateParameter(valid_589283, JString, required = false,
                                 default = nil)
  if valid_589283 != nil:
    section.add "userProject", valid_589283
  var valid_589284 = query.getOrDefault("key")
  valid_589284 = validateParameter(valid_589284, JString, required = false,
                                 default = nil)
  if valid_589284 != nil:
    section.add "key", valid_589284
  var valid_589285 = query.getOrDefault("prettyPrint")
  valid_589285 = validateParameter(valid_589285, JBool, required = false,
                                 default = newJBool(true))
  if valid_589285 != nil:
    section.add "prettyPrint", valid_589285
  var valid_589286 = query.getOrDefault("provisionalUserProject")
  valid_589286 = validateParameter(valid_589286, JString, required = false,
                                 default = nil)
  if valid_589286 != nil:
    section.add "provisionalUserProject", valid_589286
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589287: Call_StorageDefaultObjectAccessControlsGet_589273;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Returns the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_589287.validator(path, query, header, formData, body)
  let scheme = call_589287.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589287.url(scheme.get, call_589287.host, call_589287.base,
                         call_589287.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589287, url, valid)

proc call*(call_589288: Call_StorageDefaultObjectAccessControlsGet_589273;
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
  var path_589289 = newJObject()
  var query_589290 = newJObject()
  add(path_589289, "bucket", newJString(bucket))
  add(query_589290, "fields", newJString(fields))
  add(query_589290, "quotaUser", newJString(quotaUser))
  add(query_589290, "alt", newJString(alt))
  add(query_589290, "oauth_token", newJString(oauthToken))
  add(query_589290, "userIp", newJString(userIp))
  add(query_589290, "userProject", newJString(userProject))
  add(query_589290, "key", newJString(key))
  add(query_589290, "prettyPrint", newJBool(prettyPrint))
  add(path_589289, "entity", newJString(entity))
  add(query_589290, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589288.call(path_589289, query_589290, nil, nil, nil)

var storageDefaultObjectAccessControlsGet* = Call_StorageDefaultObjectAccessControlsGet_589273(
    name: "storageDefaultObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsGet_589274,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsGet_589275,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsPatch_589329 = ref object of OpenApiRestCall_588457
proc url_StorageDefaultObjectAccessControlsPatch_589331(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsPatch_589330(path: JsonNode;
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
  var valid_589332 = path.getOrDefault("bucket")
  valid_589332 = validateParameter(valid_589332, JString, required = true,
                                 default = nil)
  if valid_589332 != nil:
    section.add "bucket", valid_589332
  var valid_589333 = path.getOrDefault("entity")
  valid_589333 = validateParameter(valid_589333, JString, required = true,
                                 default = nil)
  if valid_589333 != nil:
    section.add "entity", valid_589333
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
  var valid_589334 = query.getOrDefault("fields")
  valid_589334 = validateParameter(valid_589334, JString, required = false,
                                 default = nil)
  if valid_589334 != nil:
    section.add "fields", valid_589334
  var valid_589335 = query.getOrDefault("quotaUser")
  valid_589335 = validateParameter(valid_589335, JString, required = false,
                                 default = nil)
  if valid_589335 != nil:
    section.add "quotaUser", valid_589335
  var valid_589336 = query.getOrDefault("alt")
  valid_589336 = validateParameter(valid_589336, JString, required = false,
                                 default = newJString("json"))
  if valid_589336 != nil:
    section.add "alt", valid_589336
  var valid_589337 = query.getOrDefault("oauth_token")
  valid_589337 = validateParameter(valid_589337, JString, required = false,
                                 default = nil)
  if valid_589337 != nil:
    section.add "oauth_token", valid_589337
  var valid_589338 = query.getOrDefault("userIp")
  valid_589338 = validateParameter(valid_589338, JString, required = false,
                                 default = nil)
  if valid_589338 != nil:
    section.add "userIp", valid_589338
  var valid_589339 = query.getOrDefault("userProject")
  valid_589339 = validateParameter(valid_589339, JString, required = false,
                                 default = nil)
  if valid_589339 != nil:
    section.add "userProject", valid_589339
  var valid_589340 = query.getOrDefault("key")
  valid_589340 = validateParameter(valid_589340, JString, required = false,
                                 default = nil)
  if valid_589340 != nil:
    section.add "key", valid_589340
  var valid_589341 = query.getOrDefault("prettyPrint")
  valid_589341 = validateParameter(valid_589341, JBool, required = false,
                                 default = newJBool(true))
  if valid_589341 != nil:
    section.add "prettyPrint", valid_589341
  var valid_589342 = query.getOrDefault("provisionalUserProject")
  valid_589342 = validateParameter(valid_589342, JString, required = false,
                                 default = nil)
  if valid_589342 != nil:
    section.add "provisionalUserProject", valid_589342
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

proc call*(call_589344: Call_StorageDefaultObjectAccessControlsPatch_589329;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches a default object ACL entry on the specified bucket.
  ## 
  let valid = call_589344.validator(path, query, header, formData, body)
  let scheme = call_589344.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589344.url(scheme.get, call_589344.host, call_589344.base,
                         call_589344.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589344, url, valid)

proc call*(call_589345: Call_StorageDefaultObjectAccessControlsPatch_589329;
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
  var path_589346 = newJObject()
  var query_589347 = newJObject()
  var body_589348 = newJObject()
  add(path_589346, "bucket", newJString(bucket))
  add(query_589347, "fields", newJString(fields))
  add(query_589347, "quotaUser", newJString(quotaUser))
  add(query_589347, "alt", newJString(alt))
  add(query_589347, "oauth_token", newJString(oauthToken))
  add(query_589347, "userIp", newJString(userIp))
  add(query_589347, "userProject", newJString(userProject))
  add(query_589347, "key", newJString(key))
  if body != nil:
    body_589348 = body
  add(query_589347, "prettyPrint", newJBool(prettyPrint))
  add(path_589346, "entity", newJString(entity))
  add(query_589347, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589345.call(path_589346, query_589347, nil, nil, body_589348)

var storageDefaultObjectAccessControlsPatch* = Call_StorageDefaultObjectAccessControlsPatch_589329(
    name: "storageDefaultObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsPatch_589330,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsPatch_589331,
    schemes: {Scheme.Https})
type
  Call_StorageDefaultObjectAccessControlsDelete_589311 = ref object of OpenApiRestCall_588457
proc url_StorageDefaultObjectAccessControlsDelete_589313(protocol: Scheme;
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

proc validate_StorageDefaultObjectAccessControlsDelete_589312(path: JsonNode;
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
  var valid_589314 = path.getOrDefault("bucket")
  valid_589314 = validateParameter(valid_589314, JString, required = true,
                                 default = nil)
  if valid_589314 != nil:
    section.add "bucket", valid_589314
  var valid_589315 = path.getOrDefault("entity")
  valid_589315 = validateParameter(valid_589315, JString, required = true,
                                 default = nil)
  if valid_589315 != nil:
    section.add "entity", valid_589315
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
  var valid_589316 = query.getOrDefault("fields")
  valid_589316 = validateParameter(valid_589316, JString, required = false,
                                 default = nil)
  if valid_589316 != nil:
    section.add "fields", valid_589316
  var valid_589317 = query.getOrDefault("quotaUser")
  valid_589317 = validateParameter(valid_589317, JString, required = false,
                                 default = nil)
  if valid_589317 != nil:
    section.add "quotaUser", valid_589317
  var valid_589318 = query.getOrDefault("alt")
  valid_589318 = validateParameter(valid_589318, JString, required = false,
                                 default = newJString("json"))
  if valid_589318 != nil:
    section.add "alt", valid_589318
  var valid_589319 = query.getOrDefault("oauth_token")
  valid_589319 = validateParameter(valid_589319, JString, required = false,
                                 default = nil)
  if valid_589319 != nil:
    section.add "oauth_token", valid_589319
  var valid_589320 = query.getOrDefault("userIp")
  valid_589320 = validateParameter(valid_589320, JString, required = false,
                                 default = nil)
  if valid_589320 != nil:
    section.add "userIp", valid_589320
  var valid_589321 = query.getOrDefault("userProject")
  valid_589321 = validateParameter(valid_589321, JString, required = false,
                                 default = nil)
  if valid_589321 != nil:
    section.add "userProject", valid_589321
  var valid_589322 = query.getOrDefault("key")
  valid_589322 = validateParameter(valid_589322, JString, required = false,
                                 default = nil)
  if valid_589322 != nil:
    section.add "key", valid_589322
  var valid_589323 = query.getOrDefault("prettyPrint")
  valid_589323 = validateParameter(valid_589323, JBool, required = false,
                                 default = newJBool(true))
  if valid_589323 != nil:
    section.add "prettyPrint", valid_589323
  var valid_589324 = query.getOrDefault("provisionalUserProject")
  valid_589324 = validateParameter(valid_589324, JString, required = false,
                                 default = nil)
  if valid_589324 != nil:
    section.add "provisionalUserProject", valid_589324
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589325: Call_StorageDefaultObjectAccessControlsDelete_589311;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the default object ACL entry for the specified entity on the specified bucket.
  ## 
  let valid = call_589325.validator(path, query, header, formData, body)
  let scheme = call_589325.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589325.url(scheme.get, call_589325.host, call_589325.base,
                         call_589325.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589325, url, valid)

proc call*(call_589326: Call_StorageDefaultObjectAccessControlsDelete_589311;
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
  var path_589327 = newJObject()
  var query_589328 = newJObject()
  add(path_589327, "bucket", newJString(bucket))
  add(query_589328, "fields", newJString(fields))
  add(query_589328, "quotaUser", newJString(quotaUser))
  add(query_589328, "alt", newJString(alt))
  add(query_589328, "oauth_token", newJString(oauthToken))
  add(query_589328, "userIp", newJString(userIp))
  add(query_589328, "userProject", newJString(userProject))
  add(query_589328, "key", newJString(key))
  add(query_589328, "prettyPrint", newJBool(prettyPrint))
  add(path_589327, "entity", newJString(entity))
  add(query_589328, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589326.call(path_589327, query_589328, nil, nil, nil)

var storageDefaultObjectAccessControlsDelete* = Call_StorageDefaultObjectAccessControlsDelete_589311(
    name: "storageDefaultObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/defaultObjectAcl/{entity}",
    validator: validate_StorageDefaultObjectAccessControlsDelete_589312,
    base: "/storage/v1", url: url_StorageDefaultObjectAccessControlsDelete_589313,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsSetIamPolicy_589367 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsSetIamPolicy_589369(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageBucketsSetIamPolicy_589368(path: JsonNode; query: JsonNode;
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
  var valid_589370 = path.getOrDefault("bucket")
  valid_589370 = validateParameter(valid_589370, JString, required = true,
                                 default = nil)
  if valid_589370 != nil:
    section.add "bucket", valid_589370
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
  var valid_589371 = query.getOrDefault("fields")
  valid_589371 = validateParameter(valid_589371, JString, required = false,
                                 default = nil)
  if valid_589371 != nil:
    section.add "fields", valid_589371
  var valid_589372 = query.getOrDefault("quotaUser")
  valid_589372 = validateParameter(valid_589372, JString, required = false,
                                 default = nil)
  if valid_589372 != nil:
    section.add "quotaUser", valid_589372
  var valid_589373 = query.getOrDefault("alt")
  valid_589373 = validateParameter(valid_589373, JString, required = false,
                                 default = newJString("json"))
  if valid_589373 != nil:
    section.add "alt", valid_589373
  var valid_589374 = query.getOrDefault("oauth_token")
  valid_589374 = validateParameter(valid_589374, JString, required = false,
                                 default = nil)
  if valid_589374 != nil:
    section.add "oauth_token", valid_589374
  var valid_589375 = query.getOrDefault("userIp")
  valid_589375 = validateParameter(valid_589375, JString, required = false,
                                 default = nil)
  if valid_589375 != nil:
    section.add "userIp", valid_589375
  var valid_589376 = query.getOrDefault("userProject")
  valid_589376 = validateParameter(valid_589376, JString, required = false,
                                 default = nil)
  if valid_589376 != nil:
    section.add "userProject", valid_589376
  var valid_589377 = query.getOrDefault("key")
  valid_589377 = validateParameter(valid_589377, JString, required = false,
                                 default = nil)
  if valid_589377 != nil:
    section.add "key", valid_589377
  var valid_589378 = query.getOrDefault("prettyPrint")
  valid_589378 = validateParameter(valid_589378, JBool, required = false,
                                 default = newJBool(true))
  if valid_589378 != nil:
    section.add "prettyPrint", valid_589378
  var valid_589379 = query.getOrDefault("provisionalUserProject")
  valid_589379 = validateParameter(valid_589379, JString, required = false,
                                 default = nil)
  if valid_589379 != nil:
    section.add "provisionalUserProject", valid_589379
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

proc call*(call_589381: Call_StorageBucketsSetIamPolicy_589367; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified bucket.
  ## 
  let valid = call_589381.validator(path, query, header, formData, body)
  let scheme = call_589381.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589381.url(scheme.get, call_589381.host, call_589381.base,
                         call_589381.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589381, url, valid)

proc call*(call_589382: Call_StorageBucketsSetIamPolicy_589367; bucket: string;
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
  var path_589383 = newJObject()
  var query_589384 = newJObject()
  var body_589385 = newJObject()
  add(path_589383, "bucket", newJString(bucket))
  add(query_589384, "fields", newJString(fields))
  add(query_589384, "quotaUser", newJString(quotaUser))
  add(query_589384, "alt", newJString(alt))
  add(query_589384, "oauth_token", newJString(oauthToken))
  add(query_589384, "userIp", newJString(userIp))
  add(query_589384, "userProject", newJString(userProject))
  add(query_589384, "key", newJString(key))
  if body != nil:
    body_589385 = body
  add(query_589384, "prettyPrint", newJBool(prettyPrint))
  add(query_589384, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589382.call(path_589383, query_589384, nil, nil, body_589385)

var storageBucketsSetIamPolicy* = Call_StorageBucketsSetIamPolicy_589367(
    name: "storageBucketsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsSetIamPolicy_589368, base: "/storage/v1",
    url: url_StorageBucketsSetIamPolicy_589369, schemes: {Scheme.Https})
type
  Call_StorageBucketsGetIamPolicy_589349 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsGetIamPolicy_589351(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageBucketsGetIamPolicy_589350(path: JsonNode; query: JsonNode;
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
  var valid_589352 = path.getOrDefault("bucket")
  valid_589352 = validateParameter(valid_589352, JString, required = true,
                                 default = nil)
  if valid_589352 != nil:
    section.add "bucket", valid_589352
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
  var valid_589353 = query.getOrDefault("fields")
  valid_589353 = validateParameter(valid_589353, JString, required = false,
                                 default = nil)
  if valid_589353 != nil:
    section.add "fields", valid_589353
  var valid_589354 = query.getOrDefault("optionsRequestedPolicyVersion")
  valid_589354 = validateParameter(valid_589354, JInt, required = false, default = nil)
  if valid_589354 != nil:
    section.add "optionsRequestedPolicyVersion", valid_589354
  var valid_589355 = query.getOrDefault("quotaUser")
  valid_589355 = validateParameter(valid_589355, JString, required = false,
                                 default = nil)
  if valid_589355 != nil:
    section.add "quotaUser", valid_589355
  var valid_589356 = query.getOrDefault("alt")
  valid_589356 = validateParameter(valid_589356, JString, required = false,
                                 default = newJString("json"))
  if valid_589356 != nil:
    section.add "alt", valid_589356
  var valid_589357 = query.getOrDefault("oauth_token")
  valid_589357 = validateParameter(valid_589357, JString, required = false,
                                 default = nil)
  if valid_589357 != nil:
    section.add "oauth_token", valid_589357
  var valid_589358 = query.getOrDefault("userIp")
  valid_589358 = validateParameter(valid_589358, JString, required = false,
                                 default = nil)
  if valid_589358 != nil:
    section.add "userIp", valid_589358
  var valid_589359 = query.getOrDefault("userProject")
  valid_589359 = validateParameter(valid_589359, JString, required = false,
                                 default = nil)
  if valid_589359 != nil:
    section.add "userProject", valid_589359
  var valid_589360 = query.getOrDefault("key")
  valid_589360 = validateParameter(valid_589360, JString, required = false,
                                 default = nil)
  if valid_589360 != nil:
    section.add "key", valid_589360
  var valid_589361 = query.getOrDefault("prettyPrint")
  valid_589361 = validateParameter(valid_589361, JBool, required = false,
                                 default = newJBool(true))
  if valid_589361 != nil:
    section.add "prettyPrint", valid_589361
  var valid_589362 = query.getOrDefault("provisionalUserProject")
  valid_589362 = validateParameter(valid_589362, JString, required = false,
                                 default = nil)
  if valid_589362 != nil:
    section.add "provisionalUserProject", valid_589362
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589363: Call_StorageBucketsGetIamPolicy_589349; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified bucket.
  ## 
  let valid = call_589363.validator(path, query, header, formData, body)
  let scheme = call_589363.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589363.url(scheme.get, call_589363.host, call_589363.base,
                         call_589363.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589363, url, valid)

proc call*(call_589364: Call_StorageBucketsGetIamPolicy_589349; bucket: string;
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
  var path_589365 = newJObject()
  var query_589366 = newJObject()
  add(path_589365, "bucket", newJString(bucket))
  add(query_589366, "fields", newJString(fields))
  add(query_589366, "optionsRequestedPolicyVersion",
      newJInt(optionsRequestedPolicyVersion))
  add(query_589366, "quotaUser", newJString(quotaUser))
  add(query_589366, "alt", newJString(alt))
  add(query_589366, "oauth_token", newJString(oauthToken))
  add(query_589366, "userIp", newJString(userIp))
  add(query_589366, "userProject", newJString(userProject))
  add(query_589366, "key", newJString(key))
  add(query_589366, "prettyPrint", newJBool(prettyPrint))
  add(query_589366, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589364.call(path_589365, query_589366, nil, nil, nil)

var storageBucketsGetIamPolicy* = Call_StorageBucketsGetIamPolicy_589349(
    name: "storageBucketsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam",
    validator: validate_StorageBucketsGetIamPolicy_589350, base: "/storage/v1",
    url: url_StorageBucketsGetIamPolicy_589351, schemes: {Scheme.Https})
type
  Call_StorageBucketsTestIamPermissions_589386 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsTestIamPermissions_589388(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageBucketsTestIamPermissions_589387(path: JsonNode;
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
  var valid_589389 = path.getOrDefault("bucket")
  valid_589389 = validateParameter(valid_589389, JString, required = true,
                                 default = nil)
  if valid_589389 != nil:
    section.add "bucket", valid_589389
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
  var valid_589390 = query.getOrDefault("fields")
  valid_589390 = validateParameter(valid_589390, JString, required = false,
                                 default = nil)
  if valid_589390 != nil:
    section.add "fields", valid_589390
  var valid_589391 = query.getOrDefault("quotaUser")
  valid_589391 = validateParameter(valid_589391, JString, required = false,
                                 default = nil)
  if valid_589391 != nil:
    section.add "quotaUser", valid_589391
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_589392 = query.getOrDefault("permissions")
  valid_589392 = validateParameter(valid_589392, JArray, required = true, default = nil)
  if valid_589392 != nil:
    section.add "permissions", valid_589392
  var valid_589393 = query.getOrDefault("alt")
  valid_589393 = validateParameter(valid_589393, JString, required = false,
                                 default = newJString("json"))
  if valid_589393 != nil:
    section.add "alt", valid_589393
  var valid_589394 = query.getOrDefault("oauth_token")
  valid_589394 = validateParameter(valid_589394, JString, required = false,
                                 default = nil)
  if valid_589394 != nil:
    section.add "oauth_token", valid_589394
  var valid_589395 = query.getOrDefault("userIp")
  valid_589395 = validateParameter(valid_589395, JString, required = false,
                                 default = nil)
  if valid_589395 != nil:
    section.add "userIp", valid_589395
  var valid_589396 = query.getOrDefault("userProject")
  valid_589396 = validateParameter(valid_589396, JString, required = false,
                                 default = nil)
  if valid_589396 != nil:
    section.add "userProject", valid_589396
  var valid_589397 = query.getOrDefault("key")
  valid_589397 = validateParameter(valid_589397, JString, required = false,
                                 default = nil)
  if valid_589397 != nil:
    section.add "key", valid_589397
  var valid_589398 = query.getOrDefault("prettyPrint")
  valid_589398 = validateParameter(valid_589398, JBool, required = false,
                                 default = newJBool(true))
  if valid_589398 != nil:
    section.add "prettyPrint", valid_589398
  var valid_589399 = query.getOrDefault("provisionalUserProject")
  valid_589399 = validateParameter(valid_589399, JString, required = false,
                                 default = nil)
  if valid_589399 != nil:
    section.add "provisionalUserProject", valid_589399
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589400: Call_StorageBucketsTestIamPermissions_589386;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given bucket to see which, if any, are held by the caller.
  ## 
  let valid = call_589400.validator(path, query, header, formData, body)
  let scheme = call_589400.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589400.url(scheme.get, call_589400.host, call_589400.base,
                         call_589400.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589400, url, valid)

proc call*(call_589401: Call_StorageBucketsTestIamPermissions_589386;
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
  var path_589402 = newJObject()
  var query_589403 = newJObject()
  add(path_589402, "bucket", newJString(bucket))
  add(query_589403, "fields", newJString(fields))
  add(query_589403, "quotaUser", newJString(quotaUser))
  if permissions != nil:
    query_589403.add "permissions", permissions
  add(query_589403, "alt", newJString(alt))
  add(query_589403, "oauth_token", newJString(oauthToken))
  add(query_589403, "userIp", newJString(userIp))
  add(query_589403, "userProject", newJString(userProject))
  add(query_589403, "key", newJString(key))
  add(query_589403, "prettyPrint", newJBool(prettyPrint))
  add(query_589403, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589401.call(path_589402, query_589403, nil, nil, nil)

var storageBucketsTestIamPermissions* = Call_StorageBucketsTestIamPermissions_589386(
    name: "storageBucketsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/iam/testPermissions",
    validator: validate_StorageBucketsTestIamPermissions_589387,
    base: "/storage/v1", url: url_StorageBucketsTestIamPermissions_589388,
    schemes: {Scheme.Https})
type
  Call_StorageBucketsLockRetentionPolicy_589404 = ref object of OpenApiRestCall_588457
proc url_StorageBucketsLockRetentionPolicy_589406(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageBucketsLockRetentionPolicy_589405(path: JsonNode;
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
  var valid_589407 = path.getOrDefault("bucket")
  valid_589407 = validateParameter(valid_589407, JString, required = true,
                                 default = nil)
  if valid_589407 != nil:
    section.add "bucket", valid_589407
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
  var valid_589408 = query.getOrDefault("fields")
  valid_589408 = validateParameter(valid_589408, JString, required = false,
                                 default = nil)
  if valid_589408 != nil:
    section.add "fields", valid_589408
  var valid_589409 = query.getOrDefault("quotaUser")
  valid_589409 = validateParameter(valid_589409, JString, required = false,
                                 default = nil)
  if valid_589409 != nil:
    section.add "quotaUser", valid_589409
  var valid_589410 = query.getOrDefault("alt")
  valid_589410 = validateParameter(valid_589410, JString, required = false,
                                 default = newJString("json"))
  if valid_589410 != nil:
    section.add "alt", valid_589410
  var valid_589411 = query.getOrDefault("oauth_token")
  valid_589411 = validateParameter(valid_589411, JString, required = false,
                                 default = nil)
  if valid_589411 != nil:
    section.add "oauth_token", valid_589411
  var valid_589412 = query.getOrDefault("userIp")
  valid_589412 = validateParameter(valid_589412, JString, required = false,
                                 default = nil)
  if valid_589412 != nil:
    section.add "userIp", valid_589412
  var valid_589413 = query.getOrDefault("userProject")
  valid_589413 = validateParameter(valid_589413, JString, required = false,
                                 default = nil)
  if valid_589413 != nil:
    section.add "userProject", valid_589413
  var valid_589414 = query.getOrDefault("key")
  valid_589414 = validateParameter(valid_589414, JString, required = false,
                                 default = nil)
  if valid_589414 != nil:
    section.add "key", valid_589414
  assert query != nil, "query argument is necessary due to required `ifMetagenerationMatch` field"
  var valid_589415 = query.getOrDefault("ifMetagenerationMatch")
  valid_589415 = validateParameter(valid_589415, JString, required = true,
                                 default = nil)
  if valid_589415 != nil:
    section.add "ifMetagenerationMatch", valid_589415
  var valid_589416 = query.getOrDefault("prettyPrint")
  valid_589416 = validateParameter(valid_589416, JBool, required = false,
                                 default = newJBool(true))
  if valid_589416 != nil:
    section.add "prettyPrint", valid_589416
  var valid_589417 = query.getOrDefault("provisionalUserProject")
  valid_589417 = validateParameter(valid_589417, JString, required = false,
                                 default = nil)
  if valid_589417 != nil:
    section.add "provisionalUserProject", valid_589417
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589418: Call_StorageBucketsLockRetentionPolicy_589404;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Locks retention policy on a bucket.
  ## 
  let valid = call_589418.validator(path, query, header, formData, body)
  let scheme = call_589418.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589418.url(scheme.get, call_589418.host, call_589418.base,
                         call_589418.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589418, url, valid)

proc call*(call_589419: Call_StorageBucketsLockRetentionPolicy_589404;
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
  var path_589420 = newJObject()
  var query_589421 = newJObject()
  add(path_589420, "bucket", newJString(bucket))
  add(query_589421, "fields", newJString(fields))
  add(query_589421, "quotaUser", newJString(quotaUser))
  add(query_589421, "alt", newJString(alt))
  add(query_589421, "oauth_token", newJString(oauthToken))
  add(query_589421, "userIp", newJString(userIp))
  add(query_589421, "userProject", newJString(userProject))
  add(query_589421, "key", newJString(key))
  add(query_589421, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589421, "prettyPrint", newJBool(prettyPrint))
  add(query_589421, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589419.call(path_589420, query_589421, nil, nil, nil)

var storageBucketsLockRetentionPolicy* = Call_StorageBucketsLockRetentionPolicy_589404(
    name: "storageBucketsLockRetentionPolicy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/lockRetentionPolicy",
    validator: validate_StorageBucketsLockRetentionPolicy_589405,
    base: "/storage/v1", url: url_StorageBucketsLockRetentionPolicy_589406,
    schemes: {Scheme.Https})
type
  Call_StorageNotificationsInsert_589439 = ref object of OpenApiRestCall_588457
proc url_StorageNotificationsInsert_589441(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageNotificationsInsert_589440(path: JsonNode; query: JsonNode;
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
  var valid_589442 = path.getOrDefault("bucket")
  valid_589442 = validateParameter(valid_589442, JString, required = true,
                                 default = nil)
  if valid_589442 != nil:
    section.add "bucket", valid_589442
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
  var valid_589443 = query.getOrDefault("fields")
  valid_589443 = validateParameter(valid_589443, JString, required = false,
                                 default = nil)
  if valid_589443 != nil:
    section.add "fields", valid_589443
  var valid_589444 = query.getOrDefault("quotaUser")
  valid_589444 = validateParameter(valid_589444, JString, required = false,
                                 default = nil)
  if valid_589444 != nil:
    section.add "quotaUser", valid_589444
  var valid_589445 = query.getOrDefault("alt")
  valid_589445 = validateParameter(valid_589445, JString, required = false,
                                 default = newJString("json"))
  if valid_589445 != nil:
    section.add "alt", valid_589445
  var valid_589446 = query.getOrDefault("oauth_token")
  valid_589446 = validateParameter(valid_589446, JString, required = false,
                                 default = nil)
  if valid_589446 != nil:
    section.add "oauth_token", valid_589446
  var valid_589447 = query.getOrDefault("userIp")
  valid_589447 = validateParameter(valid_589447, JString, required = false,
                                 default = nil)
  if valid_589447 != nil:
    section.add "userIp", valid_589447
  var valid_589448 = query.getOrDefault("userProject")
  valid_589448 = validateParameter(valid_589448, JString, required = false,
                                 default = nil)
  if valid_589448 != nil:
    section.add "userProject", valid_589448
  var valid_589449 = query.getOrDefault("key")
  valid_589449 = validateParameter(valid_589449, JString, required = false,
                                 default = nil)
  if valid_589449 != nil:
    section.add "key", valid_589449
  var valid_589450 = query.getOrDefault("prettyPrint")
  valid_589450 = validateParameter(valid_589450, JBool, required = false,
                                 default = newJBool(true))
  if valid_589450 != nil:
    section.add "prettyPrint", valid_589450
  var valid_589451 = query.getOrDefault("provisionalUserProject")
  valid_589451 = validateParameter(valid_589451, JString, required = false,
                                 default = nil)
  if valid_589451 != nil:
    section.add "provisionalUserProject", valid_589451
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

proc call*(call_589453: Call_StorageNotificationsInsert_589439; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a notification subscription for a given bucket.
  ## 
  let valid = call_589453.validator(path, query, header, formData, body)
  let scheme = call_589453.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589453.url(scheme.get, call_589453.host, call_589453.base,
                         call_589453.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589453, url, valid)

proc call*(call_589454: Call_StorageNotificationsInsert_589439; bucket: string;
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
  var path_589455 = newJObject()
  var query_589456 = newJObject()
  var body_589457 = newJObject()
  add(path_589455, "bucket", newJString(bucket))
  add(query_589456, "fields", newJString(fields))
  add(query_589456, "quotaUser", newJString(quotaUser))
  add(query_589456, "alt", newJString(alt))
  add(query_589456, "oauth_token", newJString(oauthToken))
  add(query_589456, "userIp", newJString(userIp))
  add(query_589456, "userProject", newJString(userProject))
  add(query_589456, "key", newJString(key))
  if body != nil:
    body_589457 = body
  add(query_589456, "prettyPrint", newJBool(prettyPrint))
  add(query_589456, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589454.call(path_589455, query_589456, nil, nil, body_589457)

var storageNotificationsInsert* = Call_StorageNotificationsInsert_589439(
    name: "storageNotificationsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsInsert_589440, base: "/storage/v1",
    url: url_StorageNotificationsInsert_589441, schemes: {Scheme.Https})
type
  Call_StorageNotificationsList_589422 = ref object of OpenApiRestCall_588457
proc url_StorageNotificationsList_589424(protocol: Scheme; host: string;
                                        base: string; route: string; path: JsonNode;
                                        query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageNotificationsList_589423(path: JsonNode; query: JsonNode;
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
  var valid_589425 = path.getOrDefault("bucket")
  valid_589425 = validateParameter(valid_589425, JString, required = true,
                                 default = nil)
  if valid_589425 != nil:
    section.add "bucket", valid_589425
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
  var valid_589426 = query.getOrDefault("fields")
  valid_589426 = validateParameter(valid_589426, JString, required = false,
                                 default = nil)
  if valid_589426 != nil:
    section.add "fields", valid_589426
  var valid_589427 = query.getOrDefault("quotaUser")
  valid_589427 = validateParameter(valid_589427, JString, required = false,
                                 default = nil)
  if valid_589427 != nil:
    section.add "quotaUser", valid_589427
  var valid_589428 = query.getOrDefault("alt")
  valid_589428 = validateParameter(valid_589428, JString, required = false,
                                 default = newJString("json"))
  if valid_589428 != nil:
    section.add "alt", valid_589428
  var valid_589429 = query.getOrDefault("oauth_token")
  valid_589429 = validateParameter(valid_589429, JString, required = false,
                                 default = nil)
  if valid_589429 != nil:
    section.add "oauth_token", valid_589429
  var valid_589430 = query.getOrDefault("userIp")
  valid_589430 = validateParameter(valid_589430, JString, required = false,
                                 default = nil)
  if valid_589430 != nil:
    section.add "userIp", valid_589430
  var valid_589431 = query.getOrDefault("userProject")
  valid_589431 = validateParameter(valid_589431, JString, required = false,
                                 default = nil)
  if valid_589431 != nil:
    section.add "userProject", valid_589431
  var valid_589432 = query.getOrDefault("key")
  valid_589432 = validateParameter(valid_589432, JString, required = false,
                                 default = nil)
  if valid_589432 != nil:
    section.add "key", valid_589432
  var valid_589433 = query.getOrDefault("prettyPrint")
  valid_589433 = validateParameter(valid_589433, JBool, required = false,
                                 default = newJBool(true))
  if valid_589433 != nil:
    section.add "prettyPrint", valid_589433
  var valid_589434 = query.getOrDefault("provisionalUserProject")
  valid_589434 = validateParameter(valid_589434, JString, required = false,
                                 default = nil)
  if valid_589434 != nil:
    section.add "provisionalUserProject", valid_589434
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589435: Call_StorageNotificationsList_589422; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of notification subscriptions for a given bucket.
  ## 
  let valid = call_589435.validator(path, query, header, formData, body)
  let scheme = call_589435.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589435.url(scheme.get, call_589435.host, call_589435.base,
                         call_589435.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589435, url, valid)

proc call*(call_589436: Call_StorageNotificationsList_589422; bucket: string;
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
  var path_589437 = newJObject()
  var query_589438 = newJObject()
  add(path_589437, "bucket", newJString(bucket))
  add(query_589438, "fields", newJString(fields))
  add(query_589438, "quotaUser", newJString(quotaUser))
  add(query_589438, "alt", newJString(alt))
  add(query_589438, "oauth_token", newJString(oauthToken))
  add(query_589438, "userIp", newJString(userIp))
  add(query_589438, "userProject", newJString(userProject))
  add(query_589438, "key", newJString(key))
  add(query_589438, "prettyPrint", newJBool(prettyPrint))
  add(query_589438, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589436.call(path_589437, query_589438, nil, nil, nil)

var storageNotificationsList* = Call_StorageNotificationsList_589422(
    name: "storageNotificationsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/notificationConfigs",
    validator: validate_StorageNotificationsList_589423, base: "/storage/v1",
    url: url_StorageNotificationsList_589424, schemes: {Scheme.Https})
type
  Call_StorageNotificationsGet_589458 = ref object of OpenApiRestCall_588457
proc url_StorageNotificationsGet_589460(protocol: Scheme; host: string; base: string;
                                       route: string; path: JsonNode;
                                       query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageNotificationsGet_589459(path: JsonNode; query: JsonNode;
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
  var valid_589461 = path.getOrDefault("bucket")
  valid_589461 = validateParameter(valid_589461, JString, required = true,
                                 default = nil)
  if valid_589461 != nil:
    section.add "bucket", valid_589461
  var valid_589462 = path.getOrDefault("notification")
  valid_589462 = validateParameter(valid_589462, JString, required = true,
                                 default = nil)
  if valid_589462 != nil:
    section.add "notification", valid_589462
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
  var valid_589463 = query.getOrDefault("fields")
  valid_589463 = validateParameter(valid_589463, JString, required = false,
                                 default = nil)
  if valid_589463 != nil:
    section.add "fields", valid_589463
  var valid_589464 = query.getOrDefault("quotaUser")
  valid_589464 = validateParameter(valid_589464, JString, required = false,
                                 default = nil)
  if valid_589464 != nil:
    section.add "quotaUser", valid_589464
  var valid_589465 = query.getOrDefault("alt")
  valid_589465 = validateParameter(valid_589465, JString, required = false,
                                 default = newJString("json"))
  if valid_589465 != nil:
    section.add "alt", valid_589465
  var valid_589466 = query.getOrDefault("oauth_token")
  valid_589466 = validateParameter(valid_589466, JString, required = false,
                                 default = nil)
  if valid_589466 != nil:
    section.add "oauth_token", valid_589466
  var valid_589467 = query.getOrDefault("userIp")
  valid_589467 = validateParameter(valid_589467, JString, required = false,
                                 default = nil)
  if valid_589467 != nil:
    section.add "userIp", valid_589467
  var valid_589468 = query.getOrDefault("userProject")
  valid_589468 = validateParameter(valid_589468, JString, required = false,
                                 default = nil)
  if valid_589468 != nil:
    section.add "userProject", valid_589468
  var valid_589469 = query.getOrDefault("key")
  valid_589469 = validateParameter(valid_589469, JString, required = false,
                                 default = nil)
  if valid_589469 != nil:
    section.add "key", valid_589469
  var valid_589470 = query.getOrDefault("prettyPrint")
  valid_589470 = validateParameter(valid_589470, JBool, required = false,
                                 default = newJBool(true))
  if valid_589470 != nil:
    section.add "prettyPrint", valid_589470
  var valid_589471 = query.getOrDefault("provisionalUserProject")
  valid_589471 = validateParameter(valid_589471, JString, required = false,
                                 default = nil)
  if valid_589471 != nil:
    section.add "provisionalUserProject", valid_589471
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589472: Call_StorageNotificationsGet_589458; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## View a notification configuration.
  ## 
  let valid = call_589472.validator(path, query, header, formData, body)
  let scheme = call_589472.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589472.url(scheme.get, call_589472.host, call_589472.base,
                         call_589472.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589472, url, valid)

proc call*(call_589473: Call_StorageNotificationsGet_589458; bucket: string;
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
  var path_589474 = newJObject()
  var query_589475 = newJObject()
  add(path_589474, "bucket", newJString(bucket))
  add(query_589475, "fields", newJString(fields))
  add(query_589475, "quotaUser", newJString(quotaUser))
  add(query_589475, "alt", newJString(alt))
  add(path_589474, "notification", newJString(notification))
  add(query_589475, "oauth_token", newJString(oauthToken))
  add(query_589475, "userIp", newJString(userIp))
  add(query_589475, "userProject", newJString(userProject))
  add(query_589475, "key", newJString(key))
  add(query_589475, "prettyPrint", newJBool(prettyPrint))
  add(query_589475, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589473.call(path_589474, query_589475, nil, nil, nil)

var storageNotificationsGet* = Call_StorageNotificationsGet_589458(
    name: "storageNotificationsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsGet_589459, base: "/storage/v1",
    url: url_StorageNotificationsGet_589460, schemes: {Scheme.Https})
type
  Call_StorageNotificationsDelete_589476 = ref object of OpenApiRestCall_588457
proc url_StorageNotificationsDelete_589478(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageNotificationsDelete_589477(path: JsonNode; query: JsonNode;
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
  var valid_589479 = path.getOrDefault("bucket")
  valid_589479 = validateParameter(valid_589479, JString, required = true,
                                 default = nil)
  if valid_589479 != nil:
    section.add "bucket", valid_589479
  var valid_589480 = path.getOrDefault("notification")
  valid_589480 = validateParameter(valid_589480, JString, required = true,
                                 default = nil)
  if valid_589480 != nil:
    section.add "notification", valid_589480
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
  var valid_589481 = query.getOrDefault("fields")
  valid_589481 = validateParameter(valid_589481, JString, required = false,
                                 default = nil)
  if valid_589481 != nil:
    section.add "fields", valid_589481
  var valid_589482 = query.getOrDefault("quotaUser")
  valid_589482 = validateParameter(valid_589482, JString, required = false,
                                 default = nil)
  if valid_589482 != nil:
    section.add "quotaUser", valid_589482
  var valid_589483 = query.getOrDefault("alt")
  valid_589483 = validateParameter(valid_589483, JString, required = false,
                                 default = newJString("json"))
  if valid_589483 != nil:
    section.add "alt", valid_589483
  var valid_589484 = query.getOrDefault("oauth_token")
  valid_589484 = validateParameter(valid_589484, JString, required = false,
                                 default = nil)
  if valid_589484 != nil:
    section.add "oauth_token", valid_589484
  var valid_589485 = query.getOrDefault("userIp")
  valid_589485 = validateParameter(valid_589485, JString, required = false,
                                 default = nil)
  if valid_589485 != nil:
    section.add "userIp", valid_589485
  var valid_589486 = query.getOrDefault("userProject")
  valid_589486 = validateParameter(valid_589486, JString, required = false,
                                 default = nil)
  if valid_589486 != nil:
    section.add "userProject", valid_589486
  var valid_589487 = query.getOrDefault("key")
  valid_589487 = validateParameter(valid_589487, JString, required = false,
                                 default = nil)
  if valid_589487 != nil:
    section.add "key", valid_589487
  var valid_589488 = query.getOrDefault("prettyPrint")
  valid_589488 = validateParameter(valid_589488, JBool, required = false,
                                 default = newJBool(true))
  if valid_589488 != nil:
    section.add "prettyPrint", valid_589488
  var valid_589489 = query.getOrDefault("provisionalUserProject")
  valid_589489 = validateParameter(valid_589489, JString, required = false,
                                 default = nil)
  if valid_589489 != nil:
    section.add "provisionalUserProject", valid_589489
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589490: Call_StorageNotificationsDelete_589476; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Permanently deletes a notification subscription.
  ## 
  let valid = call_589490.validator(path, query, header, formData, body)
  let scheme = call_589490.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589490.url(scheme.get, call_589490.host, call_589490.base,
                         call_589490.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589490, url, valid)

proc call*(call_589491: Call_StorageNotificationsDelete_589476; bucket: string;
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
  var path_589492 = newJObject()
  var query_589493 = newJObject()
  add(path_589492, "bucket", newJString(bucket))
  add(query_589493, "fields", newJString(fields))
  add(query_589493, "quotaUser", newJString(quotaUser))
  add(query_589493, "alt", newJString(alt))
  add(path_589492, "notification", newJString(notification))
  add(query_589493, "oauth_token", newJString(oauthToken))
  add(query_589493, "userIp", newJString(userIp))
  add(query_589493, "userProject", newJString(userProject))
  add(query_589493, "key", newJString(key))
  add(query_589493, "prettyPrint", newJBool(prettyPrint))
  add(query_589493, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589491.call(path_589492, query_589493, nil, nil, nil)

var storageNotificationsDelete* = Call_StorageNotificationsDelete_589476(
    name: "storageNotificationsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/b/{bucket}/notificationConfigs/{notification}",
    validator: validate_StorageNotificationsDelete_589477, base: "/storage/v1",
    url: url_StorageNotificationsDelete_589478, schemes: {Scheme.Https})
type
  Call_StorageObjectsInsert_589518 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsInsert_589520(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsInsert_589519(path: JsonNode; query: JsonNode;
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
  var valid_589521 = path.getOrDefault("bucket")
  valid_589521 = validateParameter(valid_589521, JString, required = true,
                                 default = nil)
  if valid_589521 != nil:
    section.add "bucket", valid_589521
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
  var valid_589522 = query.getOrDefault("ifGenerationMatch")
  valid_589522 = validateParameter(valid_589522, JString, required = false,
                                 default = nil)
  if valid_589522 != nil:
    section.add "ifGenerationMatch", valid_589522
  var valid_589523 = query.getOrDefault("fields")
  valid_589523 = validateParameter(valid_589523, JString, required = false,
                                 default = nil)
  if valid_589523 != nil:
    section.add "fields", valid_589523
  var valid_589524 = query.getOrDefault("contentEncoding")
  valid_589524 = validateParameter(valid_589524, JString, required = false,
                                 default = nil)
  if valid_589524 != nil:
    section.add "contentEncoding", valid_589524
  var valid_589525 = query.getOrDefault("quotaUser")
  valid_589525 = validateParameter(valid_589525, JString, required = false,
                                 default = nil)
  if valid_589525 != nil:
    section.add "quotaUser", valid_589525
  var valid_589526 = query.getOrDefault("kmsKeyName")
  valid_589526 = validateParameter(valid_589526, JString, required = false,
                                 default = nil)
  if valid_589526 != nil:
    section.add "kmsKeyName", valid_589526
  var valid_589527 = query.getOrDefault("alt")
  valid_589527 = validateParameter(valid_589527, JString, required = false,
                                 default = newJString("json"))
  if valid_589527 != nil:
    section.add "alt", valid_589527
  var valid_589528 = query.getOrDefault("ifGenerationNotMatch")
  valid_589528 = validateParameter(valid_589528, JString, required = false,
                                 default = nil)
  if valid_589528 != nil:
    section.add "ifGenerationNotMatch", valid_589528
  var valid_589529 = query.getOrDefault("oauth_token")
  valid_589529 = validateParameter(valid_589529, JString, required = false,
                                 default = nil)
  if valid_589529 != nil:
    section.add "oauth_token", valid_589529
  var valid_589530 = query.getOrDefault("userIp")
  valid_589530 = validateParameter(valid_589530, JString, required = false,
                                 default = nil)
  if valid_589530 != nil:
    section.add "userIp", valid_589530
  var valid_589531 = query.getOrDefault("predefinedAcl")
  valid_589531 = validateParameter(valid_589531, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589531 != nil:
    section.add "predefinedAcl", valid_589531
  var valid_589532 = query.getOrDefault("userProject")
  valid_589532 = validateParameter(valid_589532, JString, required = false,
                                 default = nil)
  if valid_589532 != nil:
    section.add "userProject", valid_589532
  var valid_589533 = query.getOrDefault("key")
  valid_589533 = validateParameter(valid_589533, JString, required = false,
                                 default = nil)
  if valid_589533 != nil:
    section.add "key", valid_589533
  var valid_589534 = query.getOrDefault("name")
  valid_589534 = validateParameter(valid_589534, JString, required = false,
                                 default = nil)
  if valid_589534 != nil:
    section.add "name", valid_589534
  var valid_589535 = query.getOrDefault("projection")
  valid_589535 = validateParameter(valid_589535, JString, required = false,
                                 default = newJString("full"))
  if valid_589535 != nil:
    section.add "projection", valid_589535
  var valid_589536 = query.getOrDefault("ifMetagenerationMatch")
  valid_589536 = validateParameter(valid_589536, JString, required = false,
                                 default = nil)
  if valid_589536 != nil:
    section.add "ifMetagenerationMatch", valid_589536
  var valid_589537 = query.getOrDefault("prettyPrint")
  valid_589537 = validateParameter(valid_589537, JBool, required = false,
                                 default = newJBool(true))
  if valid_589537 != nil:
    section.add "prettyPrint", valid_589537
  var valid_589538 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589538 = validateParameter(valid_589538, JString, required = false,
                                 default = nil)
  if valid_589538 != nil:
    section.add "ifMetagenerationNotMatch", valid_589538
  var valid_589539 = query.getOrDefault("provisionalUserProject")
  valid_589539 = validateParameter(valid_589539, JString, required = false,
                                 default = nil)
  if valid_589539 != nil:
    section.add "provisionalUserProject", valid_589539
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

proc call*(call_589541: Call_StorageObjectsInsert_589518; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stores a new object and metadata.
  ## 
  let valid = call_589541.validator(path, query, header, formData, body)
  let scheme = call_589541.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589541.url(scheme.get, call_589541.host, call_589541.base,
                         call_589541.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589541, url, valid)

proc call*(call_589542: Call_StorageObjectsInsert_589518; bucket: string;
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
  var path_589543 = newJObject()
  var query_589544 = newJObject()
  var body_589545 = newJObject()
  add(query_589544, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_589543, "bucket", newJString(bucket))
  add(query_589544, "fields", newJString(fields))
  add(query_589544, "contentEncoding", newJString(contentEncoding))
  add(query_589544, "quotaUser", newJString(quotaUser))
  add(query_589544, "kmsKeyName", newJString(kmsKeyName))
  add(query_589544, "alt", newJString(alt))
  add(query_589544, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_589544, "oauth_token", newJString(oauthToken))
  add(query_589544, "userIp", newJString(userIp))
  add(query_589544, "predefinedAcl", newJString(predefinedAcl))
  add(query_589544, "userProject", newJString(userProject))
  add(query_589544, "key", newJString(key))
  add(query_589544, "name", newJString(name))
  add(query_589544, "projection", newJString(projection))
  add(query_589544, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_589545 = body
  add(query_589544, "prettyPrint", newJBool(prettyPrint))
  add(query_589544, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589544, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589542.call(path_589543, query_589544, nil, nil, body_589545)

var storageObjectsInsert* = Call_StorageObjectsInsert_589518(
    name: "storageObjectsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsInsert_589519, base: "/storage/v1",
    url: url_StorageObjectsInsert_589520, schemes: {Scheme.Https})
type
  Call_StorageObjectsList_589494 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsList_589496(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsList_589495(path: JsonNode; query: JsonNode;
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
  var valid_589497 = path.getOrDefault("bucket")
  valid_589497 = validateParameter(valid_589497, JString, required = true,
                                 default = nil)
  if valid_589497 != nil:
    section.add "bucket", valid_589497
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
  var valid_589498 = query.getOrDefault("fields")
  valid_589498 = validateParameter(valid_589498, JString, required = false,
                                 default = nil)
  if valid_589498 != nil:
    section.add "fields", valid_589498
  var valid_589499 = query.getOrDefault("pageToken")
  valid_589499 = validateParameter(valid_589499, JString, required = false,
                                 default = nil)
  if valid_589499 != nil:
    section.add "pageToken", valid_589499
  var valid_589500 = query.getOrDefault("quotaUser")
  valid_589500 = validateParameter(valid_589500, JString, required = false,
                                 default = nil)
  if valid_589500 != nil:
    section.add "quotaUser", valid_589500
  var valid_589501 = query.getOrDefault("includeTrailingDelimiter")
  valid_589501 = validateParameter(valid_589501, JBool, required = false, default = nil)
  if valid_589501 != nil:
    section.add "includeTrailingDelimiter", valid_589501
  var valid_589502 = query.getOrDefault("alt")
  valid_589502 = validateParameter(valid_589502, JString, required = false,
                                 default = newJString("json"))
  if valid_589502 != nil:
    section.add "alt", valid_589502
  var valid_589503 = query.getOrDefault("oauth_token")
  valid_589503 = validateParameter(valid_589503, JString, required = false,
                                 default = nil)
  if valid_589503 != nil:
    section.add "oauth_token", valid_589503
  var valid_589504 = query.getOrDefault("versions")
  valid_589504 = validateParameter(valid_589504, JBool, required = false, default = nil)
  if valid_589504 != nil:
    section.add "versions", valid_589504
  var valid_589505 = query.getOrDefault("userIp")
  valid_589505 = validateParameter(valid_589505, JString, required = false,
                                 default = nil)
  if valid_589505 != nil:
    section.add "userIp", valid_589505
  var valid_589506 = query.getOrDefault("maxResults")
  valid_589506 = validateParameter(valid_589506, JInt, required = false,
                                 default = newJInt(1000))
  if valid_589506 != nil:
    section.add "maxResults", valid_589506
  var valid_589507 = query.getOrDefault("userProject")
  valid_589507 = validateParameter(valid_589507, JString, required = false,
                                 default = nil)
  if valid_589507 != nil:
    section.add "userProject", valid_589507
  var valid_589508 = query.getOrDefault("key")
  valid_589508 = validateParameter(valid_589508, JString, required = false,
                                 default = nil)
  if valid_589508 != nil:
    section.add "key", valid_589508
  var valid_589509 = query.getOrDefault("projection")
  valid_589509 = validateParameter(valid_589509, JString, required = false,
                                 default = newJString("full"))
  if valid_589509 != nil:
    section.add "projection", valid_589509
  var valid_589510 = query.getOrDefault("delimiter")
  valid_589510 = validateParameter(valid_589510, JString, required = false,
                                 default = nil)
  if valid_589510 != nil:
    section.add "delimiter", valid_589510
  var valid_589511 = query.getOrDefault("prettyPrint")
  valid_589511 = validateParameter(valid_589511, JBool, required = false,
                                 default = newJBool(true))
  if valid_589511 != nil:
    section.add "prettyPrint", valid_589511
  var valid_589512 = query.getOrDefault("prefix")
  valid_589512 = validateParameter(valid_589512, JString, required = false,
                                 default = nil)
  if valid_589512 != nil:
    section.add "prefix", valid_589512
  var valid_589513 = query.getOrDefault("provisionalUserProject")
  valid_589513 = validateParameter(valid_589513, JString, required = false,
                                 default = nil)
  if valid_589513 != nil:
    section.add "provisionalUserProject", valid_589513
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589514: Call_StorageObjectsList_589494; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of objects matching the criteria.
  ## 
  let valid = call_589514.validator(path, query, header, formData, body)
  let scheme = call_589514.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589514.url(scheme.get, call_589514.host, call_589514.base,
                         call_589514.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589514, url, valid)

proc call*(call_589515: Call_StorageObjectsList_589494; bucket: string;
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
  var path_589516 = newJObject()
  var query_589517 = newJObject()
  add(path_589516, "bucket", newJString(bucket))
  add(query_589517, "fields", newJString(fields))
  add(query_589517, "pageToken", newJString(pageToken))
  add(query_589517, "quotaUser", newJString(quotaUser))
  add(query_589517, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_589517, "alt", newJString(alt))
  add(query_589517, "oauth_token", newJString(oauthToken))
  add(query_589517, "versions", newJBool(versions))
  add(query_589517, "userIp", newJString(userIp))
  add(query_589517, "maxResults", newJInt(maxResults))
  add(query_589517, "userProject", newJString(userProject))
  add(query_589517, "key", newJString(key))
  add(query_589517, "projection", newJString(projection))
  add(query_589517, "delimiter", newJString(delimiter))
  add(query_589517, "prettyPrint", newJBool(prettyPrint))
  add(query_589517, "prefix", newJString(prefix))
  add(query_589517, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589515.call(path_589516, query_589517, nil, nil, nil)

var storageObjectsList* = Call_StorageObjectsList_589494(
    name: "storageObjectsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o",
    validator: validate_StorageObjectsList_589495, base: "/storage/v1",
    url: url_StorageObjectsList_589496, schemes: {Scheme.Https})
type
  Call_StorageObjectsWatchAll_589546 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsWatchAll_589548(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsWatchAll_589547(path: JsonNode; query: JsonNode;
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
  var valid_589549 = path.getOrDefault("bucket")
  valid_589549 = validateParameter(valid_589549, JString, required = true,
                                 default = nil)
  if valid_589549 != nil:
    section.add "bucket", valid_589549
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
  var valid_589550 = query.getOrDefault("fields")
  valid_589550 = validateParameter(valid_589550, JString, required = false,
                                 default = nil)
  if valid_589550 != nil:
    section.add "fields", valid_589550
  var valid_589551 = query.getOrDefault("pageToken")
  valid_589551 = validateParameter(valid_589551, JString, required = false,
                                 default = nil)
  if valid_589551 != nil:
    section.add "pageToken", valid_589551
  var valid_589552 = query.getOrDefault("quotaUser")
  valid_589552 = validateParameter(valid_589552, JString, required = false,
                                 default = nil)
  if valid_589552 != nil:
    section.add "quotaUser", valid_589552
  var valid_589553 = query.getOrDefault("includeTrailingDelimiter")
  valid_589553 = validateParameter(valid_589553, JBool, required = false, default = nil)
  if valid_589553 != nil:
    section.add "includeTrailingDelimiter", valid_589553
  var valid_589554 = query.getOrDefault("alt")
  valid_589554 = validateParameter(valid_589554, JString, required = false,
                                 default = newJString("json"))
  if valid_589554 != nil:
    section.add "alt", valid_589554
  var valid_589555 = query.getOrDefault("oauth_token")
  valid_589555 = validateParameter(valid_589555, JString, required = false,
                                 default = nil)
  if valid_589555 != nil:
    section.add "oauth_token", valid_589555
  var valid_589556 = query.getOrDefault("versions")
  valid_589556 = validateParameter(valid_589556, JBool, required = false, default = nil)
  if valid_589556 != nil:
    section.add "versions", valid_589556
  var valid_589557 = query.getOrDefault("userIp")
  valid_589557 = validateParameter(valid_589557, JString, required = false,
                                 default = nil)
  if valid_589557 != nil:
    section.add "userIp", valid_589557
  var valid_589558 = query.getOrDefault("maxResults")
  valid_589558 = validateParameter(valid_589558, JInt, required = false,
                                 default = newJInt(1000))
  if valid_589558 != nil:
    section.add "maxResults", valid_589558
  var valid_589559 = query.getOrDefault("userProject")
  valid_589559 = validateParameter(valid_589559, JString, required = false,
                                 default = nil)
  if valid_589559 != nil:
    section.add "userProject", valid_589559
  var valid_589560 = query.getOrDefault("key")
  valid_589560 = validateParameter(valid_589560, JString, required = false,
                                 default = nil)
  if valid_589560 != nil:
    section.add "key", valid_589560
  var valid_589561 = query.getOrDefault("projection")
  valid_589561 = validateParameter(valid_589561, JString, required = false,
                                 default = newJString("full"))
  if valid_589561 != nil:
    section.add "projection", valid_589561
  var valid_589562 = query.getOrDefault("delimiter")
  valid_589562 = validateParameter(valid_589562, JString, required = false,
                                 default = nil)
  if valid_589562 != nil:
    section.add "delimiter", valid_589562
  var valid_589563 = query.getOrDefault("prettyPrint")
  valid_589563 = validateParameter(valid_589563, JBool, required = false,
                                 default = newJBool(true))
  if valid_589563 != nil:
    section.add "prettyPrint", valid_589563
  var valid_589564 = query.getOrDefault("prefix")
  valid_589564 = validateParameter(valid_589564, JString, required = false,
                                 default = nil)
  if valid_589564 != nil:
    section.add "prefix", valid_589564
  var valid_589565 = query.getOrDefault("provisionalUserProject")
  valid_589565 = validateParameter(valid_589565, JString, required = false,
                                 default = nil)
  if valid_589565 != nil:
    section.add "provisionalUserProject", valid_589565
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

proc call*(call_589567: Call_StorageObjectsWatchAll_589546; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Watch for changes on all objects in a bucket.
  ## 
  let valid = call_589567.validator(path, query, header, formData, body)
  let scheme = call_589567.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589567.url(scheme.get, call_589567.host, call_589567.base,
                         call_589567.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589567, url, valid)

proc call*(call_589568: Call_StorageObjectsWatchAll_589546; bucket: string;
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
  var path_589569 = newJObject()
  var query_589570 = newJObject()
  var body_589571 = newJObject()
  add(path_589569, "bucket", newJString(bucket))
  add(query_589570, "fields", newJString(fields))
  add(query_589570, "pageToken", newJString(pageToken))
  add(query_589570, "quotaUser", newJString(quotaUser))
  add(query_589570, "includeTrailingDelimiter", newJBool(includeTrailingDelimiter))
  add(query_589570, "alt", newJString(alt))
  add(query_589570, "oauth_token", newJString(oauthToken))
  add(query_589570, "versions", newJBool(versions))
  add(query_589570, "userIp", newJString(userIp))
  add(query_589570, "maxResults", newJInt(maxResults))
  add(query_589570, "userProject", newJString(userProject))
  add(query_589570, "key", newJString(key))
  add(query_589570, "projection", newJString(projection))
  add(query_589570, "delimiter", newJString(delimiter))
  if resource != nil:
    body_589571 = resource
  add(query_589570, "prettyPrint", newJBool(prettyPrint))
  add(query_589570, "prefix", newJString(prefix))
  add(query_589570, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589568.call(path_589569, query_589570, nil, nil, body_589571)

var storageObjectsWatchAll* = Call_StorageObjectsWatchAll_589546(
    name: "storageObjectsWatchAll", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/watch",
    validator: validate_StorageObjectsWatchAll_589547, base: "/storage/v1",
    url: url_StorageObjectsWatchAll_589548, schemes: {Scheme.Https})
type
  Call_StorageObjectsUpdate_589596 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsUpdate_589598(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsUpdate_589597(path: JsonNode; query: JsonNode;
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
  var valid_589599 = path.getOrDefault("bucket")
  valid_589599 = validateParameter(valid_589599, JString, required = true,
                                 default = nil)
  if valid_589599 != nil:
    section.add "bucket", valid_589599
  var valid_589600 = path.getOrDefault("object")
  valid_589600 = validateParameter(valid_589600, JString, required = true,
                                 default = nil)
  if valid_589600 != nil:
    section.add "object", valid_589600
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
  var valid_589601 = query.getOrDefault("ifGenerationMatch")
  valid_589601 = validateParameter(valid_589601, JString, required = false,
                                 default = nil)
  if valid_589601 != nil:
    section.add "ifGenerationMatch", valid_589601
  var valid_589602 = query.getOrDefault("fields")
  valid_589602 = validateParameter(valid_589602, JString, required = false,
                                 default = nil)
  if valid_589602 != nil:
    section.add "fields", valid_589602
  var valid_589603 = query.getOrDefault("quotaUser")
  valid_589603 = validateParameter(valid_589603, JString, required = false,
                                 default = nil)
  if valid_589603 != nil:
    section.add "quotaUser", valid_589603
  var valid_589604 = query.getOrDefault("alt")
  valid_589604 = validateParameter(valid_589604, JString, required = false,
                                 default = newJString("json"))
  if valid_589604 != nil:
    section.add "alt", valid_589604
  var valid_589605 = query.getOrDefault("ifGenerationNotMatch")
  valid_589605 = validateParameter(valid_589605, JString, required = false,
                                 default = nil)
  if valid_589605 != nil:
    section.add "ifGenerationNotMatch", valid_589605
  var valid_589606 = query.getOrDefault("oauth_token")
  valid_589606 = validateParameter(valid_589606, JString, required = false,
                                 default = nil)
  if valid_589606 != nil:
    section.add "oauth_token", valid_589606
  var valid_589607 = query.getOrDefault("userIp")
  valid_589607 = validateParameter(valid_589607, JString, required = false,
                                 default = nil)
  if valid_589607 != nil:
    section.add "userIp", valid_589607
  var valid_589608 = query.getOrDefault("predefinedAcl")
  valid_589608 = validateParameter(valid_589608, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589608 != nil:
    section.add "predefinedAcl", valid_589608
  var valid_589609 = query.getOrDefault("userProject")
  valid_589609 = validateParameter(valid_589609, JString, required = false,
                                 default = nil)
  if valid_589609 != nil:
    section.add "userProject", valid_589609
  var valid_589610 = query.getOrDefault("key")
  valid_589610 = validateParameter(valid_589610, JString, required = false,
                                 default = nil)
  if valid_589610 != nil:
    section.add "key", valid_589610
  var valid_589611 = query.getOrDefault("projection")
  valid_589611 = validateParameter(valid_589611, JString, required = false,
                                 default = newJString("full"))
  if valid_589611 != nil:
    section.add "projection", valid_589611
  var valid_589612 = query.getOrDefault("ifMetagenerationMatch")
  valid_589612 = validateParameter(valid_589612, JString, required = false,
                                 default = nil)
  if valid_589612 != nil:
    section.add "ifMetagenerationMatch", valid_589612
  var valid_589613 = query.getOrDefault("generation")
  valid_589613 = validateParameter(valid_589613, JString, required = false,
                                 default = nil)
  if valid_589613 != nil:
    section.add "generation", valid_589613
  var valid_589614 = query.getOrDefault("prettyPrint")
  valid_589614 = validateParameter(valid_589614, JBool, required = false,
                                 default = newJBool(true))
  if valid_589614 != nil:
    section.add "prettyPrint", valid_589614
  var valid_589615 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589615 = validateParameter(valid_589615, JString, required = false,
                                 default = nil)
  if valid_589615 != nil:
    section.add "ifMetagenerationNotMatch", valid_589615
  var valid_589616 = query.getOrDefault("provisionalUserProject")
  valid_589616 = validateParameter(valid_589616, JString, required = false,
                                 default = nil)
  if valid_589616 != nil:
    section.add "provisionalUserProject", valid_589616
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

proc call*(call_589618: Call_StorageObjectsUpdate_589596; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an object's metadata.
  ## 
  let valid = call_589618.validator(path, query, header, formData, body)
  let scheme = call_589618.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589618.url(scheme.get, call_589618.host, call_589618.base,
                         call_589618.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589618, url, valid)

proc call*(call_589619: Call_StorageObjectsUpdate_589596; bucket: string;
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
  var path_589620 = newJObject()
  var query_589621 = newJObject()
  var body_589622 = newJObject()
  add(query_589621, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_589620, "bucket", newJString(bucket))
  add(query_589621, "fields", newJString(fields))
  add(query_589621, "quotaUser", newJString(quotaUser))
  add(query_589621, "alt", newJString(alt))
  add(query_589621, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_589621, "oauth_token", newJString(oauthToken))
  add(query_589621, "userIp", newJString(userIp))
  add(query_589621, "predefinedAcl", newJString(predefinedAcl))
  add(query_589621, "userProject", newJString(userProject))
  add(query_589621, "key", newJString(key))
  add(query_589621, "projection", newJString(projection))
  add(query_589621, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589621, "generation", newJString(generation))
  if body != nil:
    body_589622 = body
  add(query_589621, "prettyPrint", newJBool(prettyPrint))
  add(query_589621, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_589620, "object", newJString(`object`))
  add(query_589621, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589619.call(path_589620, query_589621, nil, nil, body_589622)

var storageObjectsUpdate* = Call_StorageObjectsUpdate_589596(
    name: "storageObjectsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsUpdate_589597, base: "/storage/v1",
    url: url_StorageObjectsUpdate_589598, schemes: {Scheme.Https})
type
  Call_StorageObjectsGet_589572 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsGet_589574(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsGet_589573(path: JsonNode; query: JsonNode;
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
  var valid_589575 = path.getOrDefault("bucket")
  valid_589575 = validateParameter(valid_589575, JString, required = true,
                                 default = nil)
  if valid_589575 != nil:
    section.add "bucket", valid_589575
  var valid_589576 = path.getOrDefault("object")
  valid_589576 = validateParameter(valid_589576, JString, required = true,
                                 default = nil)
  if valid_589576 != nil:
    section.add "object", valid_589576
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
  var valid_589577 = query.getOrDefault("ifGenerationMatch")
  valid_589577 = validateParameter(valid_589577, JString, required = false,
                                 default = nil)
  if valid_589577 != nil:
    section.add "ifGenerationMatch", valid_589577
  var valid_589578 = query.getOrDefault("fields")
  valid_589578 = validateParameter(valid_589578, JString, required = false,
                                 default = nil)
  if valid_589578 != nil:
    section.add "fields", valid_589578
  var valid_589579 = query.getOrDefault("quotaUser")
  valid_589579 = validateParameter(valid_589579, JString, required = false,
                                 default = nil)
  if valid_589579 != nil:
    section.add "quotaUser", valid_589579
  var valid_589580 = query.getOrDefault("alt")
  valid_589580 = validateParameter(valid_589580, JString, required = false,
                                 default = newJString("json"))
  if valid_589580 != nil:
    section.add "alt", valid_589580
  var valid_589581 = query.getOrDefault("ifGenerationNotMatch")
  valid_589581 = validateParameter(valid_589581, JString, required = false,
                                 default = nil)
  if valid_589581 != nil:
    section.add "ifGenerationNotMatch", valid_589581
  var valid_589582 = query.getOrDefault("oauth_token")
  valid_589582 = validateParameter(valid_589582, JString, required = false,
                                 default = nil)
  if valid_589582 != nil:
    section.add "oauth_token", valid_589582
  var valid_589583 = query.getOrDefault("userIp")
  valid_589583 = validateParameter(valid_589583, JString, required = false,
                                 default = nil)
  if valid_589583 != nil:
    section.add "userIp", valid_589583
  var valid_589584 = query.getOrDefault("userProject")
  valid_589584 = validateParameter(valid_589584, JString, required = false,
                                 default = nil)
  if valid_589584 != nil:
    section.add "userProject", valid_589584
  var valid_589585 = query.getOrDefault("key")
  valid_589585 = validateParameter(valid_589585, JString, required = false,
                                 default = nil)
  if valid_589585 != nil:
    section.add "key", valid_589585
  var valid_589586 = query.getOrDefault("projection")
  valid_589586 = validateParameter(valid_589586, JString, required = false,
                                 default = newJString("full"))
  if valid_589586 != nil:
    section.add "projection", valid_589586
  var valid_589587 = query.getOrDefault("ifMetagenerationMatch")
  valid_589587 = validateParameter(valid_589587, JString, required = false,
                                 default = nil)
  if valid_589587 != nil:
    section.add "ifMetagenerationMatch", valid_589587
  var valid_589588 = query.getOrDefault("generation")
  valid_589588 = validateParameter(valid_589588, JString, required = false,
                                 default = nil)
  if valid_589588 != nil:
    section.add "generation", valid_589588
  var valid_589589 = query.getOrDefault("prettyPrint")
  valid_589589 = validateParameter(valid_589589, JBool, required = false,
                                 default = newJBool(true))
  if valid_589589 != nil:
    section.add "prettyPrint", valid_589589
  var valid_589590 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589590 = validateParameter(valid_589590, JString, required = false,
                                 default = nil)
  if valid_589590 != nil:
    section.add "ifMetagenerationNotMatch", valid_589590
  var valid_589591 = query.getOrDefault("provisionalUserProject")
  valid_589591 = validateParameter(valid_589591, JString, required = false,
                                 default = nil)
  if valid_589591 != nil:
    section.add "provisionalUserProject", valid_589591
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589592: Call_StorageObjectsGet_589572; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an object or its metadata.
  ## 
  let valid = call_589592.validator(path, query, header, formData, body)
  let scheme = call_589592.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589592.url(scheme.get, call_589592.host, call_589592.base,
                         call_589592.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589592, url, valid)

proc call*(call_589593: Call_StorageObjectsGet_589572; bucket: string;
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
  var path_589594 = newJObject()
  var query_589595 = newJObject()
  add(query_589595, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_589594, "bucket", newJString(bucket))
  add(query_589595, "fields", newJString(fields))
  add(query_589595, "quotaUser", newJString(quotaUser))
  add(query_589595, "alt", newJString(alt))
  add(query_589595, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_589595, "oauth_token", newJString(oauthToken))
  add(query_589595, "userIp", newJString(userIp))
  add(query_589595, "userProject", newJString(userProject))
  add(query_589595, "key", newJString(key))
  add(query_589595, "projection", newJString(projection))
  add(query_589595, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589595, "generation", newJString(generation))
  add(query_589595, "prettyPrint", newJBool(prettyPrint))
  add(query_589595, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_589594, "object", newJString(`object`))
  add(query_589595, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589593.call(path_589594, query_589595, nil, nil, nil)

var storageObjectsGet* = Call_StorageObjectsGet_589572(name: "storageObjectsGet",
    meth: HttpMethod.HttpGet, host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}", validator: validate_StorageObjectsGet_589573,
    base: "/storage/v1", url: url_StorageObjectsGet_589574, schemes: {Scheme.Https})
type
  Call_StorageObjectsPatch_589646 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsPatch_589648(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsPatch_589647(path: JsonNode; query: JsonNode;
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
  var valid_589649 = path.getOrDefault("bucket")
  valid_589649 = validateParameter(valid_589649, JString, required = true,
                                 default = nil)
  if valid_589649 != nil:
    section.add "bucket", valid_589649
  var valid_589650 = path.getOrDefault("object")
  valid_589650 = validateParameter(valid_589650, JString, required = true,
                                 default = nil)
  if valid_589650 != nil:
    section.add "object", valid_589650
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
  var valid_589651 = query.getOrDefault("ifGenerationMatch")
  valid_589651 = validateParameter(valid_589651, JString, required = false,
                                 default = nil)
  if valid_589651 != nil:
    section.add "ifGenerationMatch", valid_589651
  var valid_589652 = query.getOrDefault("fields")
  valid_589652 = validateParameter(valid_589652, JString, required = false,
                                 default = nil)
  if valid_589652 != nil:
    section.add "fields", valid_589652
  var valid_589653 = query.getOrDefault("quotaUser")
  valid_589653 = validateParameter(valid_589653, JString, required = false,
                                 default = nil)
  if valid_589653 != nil:
    section.add "quotaUser", valid_589653
  var valid_589654 = query.getOrDefault("alt")
  valid_589654 = validateParameter(valid_589654, JString, required = false,
                                 default = newJString("json"))
  if valid_589654 != nil:
    section.add "alt", valid_589654
  var valid_589655 = query.getOrDefault("ifGenerationNotMatch")
  valid_589655 = validateParameter(valid_589655, JString, required = false,
                                 default = nil)
  if valid_589655 != nil:
    section.add "ifGenerationNotMatch", valid_589655
  var valid_589656 = query.getOrDefault("oauth_token")
  valid_589656 = validateParameter(valid_589656, JString, required = false,
                                 default = nil)
  if valid_589656 != nil:
    section.add "oauth_token", valid_589656
  var valid_589657 = query.getOrDefault("userIp")
  valid_589657 = validateParameter(valid_589657, JString, required = false,
                                 default = nil)
  if valid_589657 != nil:
    section.add "userIp", valid_589657
  var valid_589658 = query.getOrDefault("predefinedAcl")
  valid_589658 = validateParameter(valid_589658, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589658 != nil:
    section.add "predefinedAcl", valid_589658
  var valid_589659 = query.getOrDefault("userProject")
  valid_589659 = validateParameter(valid_589659, JString, required = false,
                                 default = nil)
  if valid_589659 != nil:
    section.add "userProject", valid_589659
  var valid_589660 = query.getOrDefault("key")
  valid_589660 = validateParameter(valid_589660, JString, required = false,
                                 default = nil)
  if valid_589660 != nil:
    section.add "key", valid_589660
  var valid_589661 = query.getOrDefault("projection")
  valid_589661 = validateParameter(valid_589661, JString, required = false,
                                 default = newJString("full"))
  if valid_589661 != nil:
    section.add "projection", valid_589661
  var valid_589662 = query.getOrDefault("ifMetagenerationMatch")
  valid_589662 = validateParameter(valid_589662, JString, required = false,
                                 default = nil)
  if valid_589662 != nil:
    section.add "ifMetagenerationMatch", valid_589662
  var valid_589663 = query.getOrDefault("generation")
  valid_589663 = validateParameter(valid_589663, JString, required = false,
                                 default = nil)
  if valid_589663 != nil:
    section.add "generation", valid_589663
  var valid_589664 = query.getOrDefault("prettyPrint")
  valid_589664 = validateParameter(valid_589664, JBool, required = false,
                                 default = newJBool(true))
  if valid_589664 != nil:
    section.add "prettyPrint", valid_589664
  var valid_589665 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589665 = validateParameter(valid_589665, JString, required = false,
                                 default = nil)
  if valid_589665 != nil:
    section.add "ifMetagenerationNotMatch", valid_589665
  var valid_589666 = query.getOrDefault("provisionalUserProject")
  valid_589666 = validateParameter(valid_589666, JString, required = false,
                                 default = nil)
  if valid_589666 != nil:
    section.add "provisionalUserProject", valid_589666
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

proc call*(call_589668: Call_StorageObjectsPatch_589646; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Patches an object's metadata.
  ## 
  let valid = call_589668.validator(path, query, header, formData, body)
  let scheme = call_589668.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589668.url(scheme.get, call_589668.host, call_589668.base,
                         call_589668.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589668, url, valid)

proc call*(call_589669: Call_StorageObjectsPatch_589646; bucket: string;
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
  var path_589670 = newJObject()
  var query_589671 = newJObject()
  var body_589672 = newJObject()
  add(query_589671, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_589670, "bucket", newJString(bucket))
  add(query_589671, "fields", newJString(fields))
  add(query_589671, "quotaUser", newJString(quotaUser))
  add(query_589671, "alt", newJString(alt))
  add(query_589671, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_589671, "oauth_token", newJString(oauthToken))
  add(query_589671, "userIp", newJString(userIp))
  add(query_589671, "predefinedAcl", newJString(predefinedAcl))
  add(query_589671, "userProject", newJString(userProject))
  add(query_589671, "key", newJString(key))
  add(query_589671, "projection", newJString(projection))
  add(query_589671, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589671, "generation", newJString(generation))
  if body != nil:
    body_589672 = body
  add(query_589671, "prettyPrint", newJBool(prettyPrint))
  add(query_589671, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_589670, "object", newJString(`object`))
  add(query_589671, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589669.call(path_589670, query_589671, nil, nil, body_589672)

var storageObjectsPatch* = Call_StorageObjectsPatch_589646(
    name: "storageObjectsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsPatch_589647, base: "/storage/v1",
    url: url_StorageObjectsPatch_589648, schemes: {Scheme.Https})
type
  Call_StorageObjectsDelete_589623 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsDelete_589625(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsDelete_589624(path: JsonNode; query: JsonNode;
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
  var valid_589626 = path.getOrDefault("bucket")
  valid_589626 = validateParameter(valid_589626, JString, required = true,
                                 default = nil)
  if valid_589626 != nil:
    section.add "bucket", valid_589626
  var valid_589627 = path.getOrDefault("object")
  valid_589627 = validateParameter(valid_589627, JString, required = true,
                                 default = nil)
  if valid_589627 != nil:
    section.add "object", valid_589627
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
  var valid_589628 = query.getOrDefault("ifGenerationMatch")
  valid_589628 = validateParameter(valid_589628, JString, required = false,
                                 default = nil)
  if valid_589628 != nil:
    section.add "ifGenerationMatch", valid_589628
  var valid_589629 = query.getOrDefault("fields")
  valid_589629 = validateParameter(valid_589629, JString, required = false,
                                 default = nil)
  if valid_589629 != nil:
    section.add "fields", valid_589629
  var valid_589630 = query.getOrDefault("quotaUser")
  valid_589630 = validateParameter(valid_589630, JString, required = false,
                                 default = nil)
  if valid_589630 != nil:
    section.add "quotaUser", valid_589630
  var valid_589631 = query.getOrDefault("alt")
  valid_589631 = validateParameter(valid_589631, JString, required = false,
                                 default = newJString("json"))
  if valid_589631 != nil:
    section.add "alt", valid_589631
  var valid_589632 = query.getOrDefault("ifGenerationNotMatch")
  valid_589632 = validateParameter(valid_589632, JString, required = false,
                                 default = nil)
  if valid_589632 != nil:
    section.add "ifGenerationNotMatch", valid_589632
  var valid_589633 = query.getOrDefault("oauth_token")
  valid_589633 = validateParameter(valid_589633, JString, required = false,
                                 default = nil)
  if valid_589633 != nil:
    section.add "oauth_token", valid_589633
  var valid_589634 = query.getOrDefault("userIp")
  valid_589634 = validateParameter(valid_589634, JString, required = false,
                                 default = nil)
  if valid_589634 != nil:
    section.add "userIp", valid_589634
  var valid_589635 = query.getOrDefault("userProject")
  valid_589635 = validateParameter(valid_589635, JString, required = false,
                                 default = nil)
  if valid_589635 != nil:
    section.add "userProject", valid_589635
  var valid_589636 = query.getOrDefault("key")
  valid_589636 = validateParameter(valid_589636, JString, required = false,
                                 default = nil)
  if valid_589636 != nil:
    section.add "key", valid_589636
  var valid_589637 = query.getOrDefault("ifMetagenerationMatch")
  valid_589637 = validateParameter(valid_589637, JString, required = false,
                                 default = nil)
  if valid_589637 != nil:
    section.add "ifMetagenerationMatch", valid_589637
  var valid_589638 = query.getOrDefault("generation")
  valid_589638 = validateParameter(valid_589638, JString, required = false,
                                 default = nil)
  if valid_589638 != nil:
    section.add "generation", valid_589638
  var valid_589639 = query.getOrDefault("prettyPrint")
  valid_589639 = validateParameter(valid_589639, JBool, required = false,
                                 default = newJBool(true))
  if valid_589639 != nil:
    section.add "prettyPrint", valid_589639
  var valid_589640 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589640 = validateParameter(valid_589640, JString, required = false,
                                 default = nil)
  if valid_589640 != nil:
    section.add "ifMetagenerationNotMatch", valid_589640
  var valid_589641 = query.getOrDefault("provisionalUserProject")
  valid_589641 = validateParameter(valid_589641, JString, required = false,
                                 default = nil)
  if valid_589641 != nil:
    section.add "provisionalUserProject", valid_589641
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589642: Call_StorageObjectsDelete_589623; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an object and its metadata. Deletions are permanent if versioning is not enabled for the bucket, or if the generation parameter is used.
  ## 
  let valid = call_589642.validator(path, query, header, formData, body)
  let scheme = call_589642.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589642.url(scheme.get, call_589642.host, call_589642.base,
                         call_589642.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589642, url, valid)

proc call*(call_589643: Call_StorageObjectsDelete_589623; bucket: string;
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
  var path_589644 = newJObject()
  var query_589645 = newJObject()
  add(query_589645, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(path_589644, "bucket", newJString(bucket))
  add(query_589645, "fields", newJString(fields))
  add(query_589645, "quotaUser", newJString(quotaUser))
  add(query_589645, "alt", newJString(alt))
  add(query_589645, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_589645, "oauth_token", newJString(oauthToken))
  add(query_589645, "userIp", newJString(userIp))
  add(query_589645, "userProject", newJString(userProject))
  add(query_589645, "key", newJString(key))
  add(query_589645, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589645, "generation", newJString(generation))
  add(query_589645, "prettyPrint", newJBool(prettyPrint))
  add(query_589645, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(path_589644, "object", newJString(`object`))
  add(query_589645, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589643.call(path_589644, query_589645, nil, nil, nil)

var storageObjectsDelete* = Call_StorageObjectsDelete_589623(
    name: "storageObjectsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}",
    validator: validate_StorageObjectsDelete_589624, base: "/storage/v1",
    url: url_StorageObjectsDelete_589625, schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsInsert_589692 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsInsert_589694(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsInsert_589693(path: JsonNode;
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
  var valid_589695 = path.getOrDefault("bucket")
  valid_589695 = validateParameter(valid_589695, JString, required = true,
                                 default = nil)
  if valid_589695 != nil:
    section.add "bucket", valid_589695
  var valid_589696 = path.getOrDefault("object")
  valid_589696 = validateParameter(valid_589696, JString, required = true,
                                 default = nil)
  if valid_589696 != nil:
    section.add "object", valid_589696
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
  var valid_589697 = query.getOrDefault("fields")
  valid_589697 = validateParameter(valid_589697, JString, required = false,
                                 default = nil)
  if valid_589697 != nil:
    section.add "fields", valid_589697
  var valid_589698 = query.getOrDefault("quotaUser")
  valid_589698 = validateParameter(valid_589698, JString, required = false,
                                 default = nil)
  if valid_589698 != nil:
    section.add "quotaUser", valid_589698
  var valid_589699 = query.getOrDefault("alt")
  valid_589699 = validateParameter(valid_589699, JString, required = false,
                                 default = newJString("json"))
  if valid_589699 != nil:
    section.add "alt", valid_589699
  var valid_589700 = query.getOrDefault("oauth_token")
  valid_589700 = validateParameter(valid_589700, JString, required = false,
                                 default = nil)
  if valid_589700 != nil:
    section.add "oauth_token", valid_589700
  var valid_589701 = query.getOrDefault("userIp")
  valid_589701 = validateParameter(valid_589701, JString, required = false,
                                 default = nil)
  if valid_589701 != nil:
    section.add "userIp", valid_589701
  var valid_589702 = query.getOrDefault("userProject")
  valid_589702 = validateParameter(valid_589702, JString, required = false,
                                 default = nil)
  if valid_589702 != nil:
    section.add "userProject", valid_589702
  var valid_589703 = query.getOrDefault("key")
  valid_589703 = validateParameter(valid_589703, JString, required = false,
                                 default = nil)
  if valid_589703 != nil:
    section.add "key", valid_589703
  var valid_589704 = query.getOrDefault("generation")
  valid_589704 = validateParameter(valid_589704, JString, required = false,
                                 default = nil)
  if valid_589704 != nil:
    section.add "generation", valid_589704
  var valid_589705 = query.getOrDefault("prettyPrint")
  valid_589705 = validateParameter(valid_589705, JBool, required = false,
                                 default = newJBool(true))
  if valid_589705 != nil:
    section.add "prettyPrint", valid_589705
  var valid_589706 = query.getOrDefault("provisionalUserProject")
  valid_589706 = validateParameter(valid_589706, JString, required = false,
                                 default = nil)
  if valid_589706 != nil:
    section.add "provisionalUserProject", valid_589706
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

proc call*(call_589708: Call_StorageObjectAccessControlsInsert_589692;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Creates a new ACL entry on the specified object.
  ## 
  let valid = call_589708.validator(path, query, header, formData, body)
  let scheme = call_589708.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589708.url(scheme.get, call_589708.host, call_589708.base,
                         call_589708.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589708, url, valid)

proc call*(call_589709: Call_StorageObjectAccessControlsInsert_589692;
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
  var path_589710 = newJObject()
  var query_589711 = newJObject()
  var body_589712 = newJObject()
  add(path_589710, "bucket", newJString(bucket))
  add(query_589711, "fields", newJString(fields))
  add(query_589711, "quotaUser", newJString(quotaUser))
  add(query_589711, "alt", newJString(alt))
  add(query_589711, "oauth_token", newJString(oauthToken))
  add(query_589711, "userIp", newJString(userIp))
  add(query_589711, "userProject", newJString(userProject))
  add(query_589711, "key", newJString(key))
  add(query_589711, "generation", newJString(generation))
  if body != nil:
    body_589712 = body
  add(query_589711, "prettyPrint", newJBool(prettyPrint))
  add(path_589710, "object", newJString(`object`))
  add(query_589711, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589709.call(path_589710, query_589711, nil, nil, body_589712)

var storageObjectAccessControlsInsert* = Call_StorageObjectAccessControlsInsert_589692(
    name: "storageObjectAccessControlsInsert", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsInsert_589693,
    base: "/storage/v1", url: url_StorageObjectAccessControlsInsert_589694,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsList_589673 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsList_589675(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsList_589674(path: JsonNode;
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
  var valid_589676 = path.getOrDefault("bucket")
  valid_589676 = validateParameter(valid_589676, JString, required = true,
                                 default = nil)
  if valid_589676 != nil:
    section.add "bucket", valid_589676
  var valid_589677 = path.getOrDefault("object")
  valid_589677 = validateParameter(valid_589677, JString, required = true,
                                 default = nil)
  if valid_589677 != nil:
    section.add "object", valid_589677
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
  var valid_589678 = query.getOrDefault("fields")
  valid_589678 = validateParameter(valid_589678, JString, required = false,
                                 default = nil)
  if valid_589678 != nil:
    section.add "fields", valid_589678
  var valid_589679 = query.getOrDefault("quotaUser")
  valid_589679 = validateParameter(valid_589679, JString, required = false,
                                 default = nil)
  if valid_589679 != nil:
    section.add "quotaUser", valid_589679
  var valid_589680 = query.getOrDefault("alt")
  valid_589680 = validateParameter(valid_589680, JString, required = false,
                                 default = newJString("json"))
  if valid_589680 != nil:
    section.add "alt", valid_589680
  var valid_589681 = query.getOrDefault("oauth_token")
  valid_589681 = validateParameter(valid_589681, JString, required = false,
                                 default = nil)
  if valid_589681 != nil:
    section.add "oauth_token", valid_589681
  var valid_589682 = query.getOrDefault("userIp")
  valid_589682 = validateParameter(valid_589682, JString, required = false,
                                 default = nil)
  if valid_589682 != nil:
    section.add "userIp", valid_589682
  var valid_589683 = query.getOrDefault("userProject")
  valid_589683 = validateParameter(valid_589683, JString, required = false,
                                 default = nil)
  if valid_589683 != nil:
    section.add "userProject", valid_589683
  var valid_589684 = query.getOrDefault("key")
  valid_589684 = validateParameter(valid_589684, JString, required = false,
                                 default = nil)
  if valid_589684 != nil:
    section.add "key", valid_589684
  var valid_589685 = query.getOrDefault("generation")
  valid_589685 = validateParameter(valid_589685, JString, required = false,
                                 default = nil)
  if valid_589685 != nil:
    section.add "generation", valid_589685
  var valid_589686 = query.getOrDefault("prettyPrint")
  valid_589686 = validateParameter(valid_589686, JBool, required = false,
                                 default = newJBool(true))
  if valid_589686 != nil:
    section.add "prettyPrint", valid_589686
  var valid_589687 = query.getOrDefault("provisionalUserProject")
  valid_589687 = validateParameter(valid_589687, JString, required = false,
                                 default = nil)
  if valid_589687 != nil:
    section.add "provisionalUserProject", valid_589687
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589688: Call_StorageObjectAccessControlsList_589673;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Retrieves ACL entries on the specified object.
  ## 
  let valid = call_589688.validator(path, query, header, formData, body)
  let scheme = call_589688.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589688.url(scheme.get, call_589688.host, call_589688.base,
                         call_589688.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589688, url, valid)

proc call*(call_589689: Call_StorageObjectAccessControlsList_589673;
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
  var path_589690 = newJObject()
  var query_589691 = newJObject()
  add(path_589690, "bucket", newJString(bucket))
  add(query_589691, "fields", newJString(fields))
  add(query_589691, "quotaUser", newJString(quotaUser))
  add(query_589691, "alt", newJString(alt))
  add(query_589691, "oauth_token", newJString(oauthToken))
  add(query_589691, "userIp", newJString(userIp))
  add(query_589691, "userProject", newJString(userProject))
  add(query_589691, "key", newJString(key))
  add(query_589691, "generation", newJString(generation))
  add(query_589691, "prettyPrint", newJBool(prettyPrint))
  add(path_589690, "object", newJString(`object`))
  add(query_589691, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589689.call(path_589690, query_589691, nil, nil, nil)

var storageObjectAccessControlsList* = Call_StorageObjectAccessControlsList_589673(
    name: "storageObjectAccessControlsList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl",
    validator: validate_StorageObjectAccessControlsList_589674,
    base: "/storage/v1", url: url_StorageObjectAccessControlsList_589675,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsUpdate_589733 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsUpdate_589735(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsUpdate_589734(path: JsonNode;
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
  var valid_589736 = path.getOrDefault("bucket")
  valid_589736 = validateParameter(valid_589736, JString, required = true,
                                 default = nil)
  if valid_589736 != nil:
    section.add "bucket", valid_589736
  var valid_589737 = path.getOrDefault("entity")
  valid_589737 = validateParameter(valid_589737, JString, required = true,
                                 default = nil)
  if valid_589737 != nil:
    section.add "entity", valid_589737
  var valid_589738 = path.getOrDefault("object")
  valid_589738 = validateParameter(valid_589738, JString, required = true,
                                 default = nil)
  if valid_589738 != nil:
    section.add "object", valid_589738
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
  var valid_589739 = query.getOrDefault("fields")
  valid_589739 = validateParameter(valid_589739, JString, required = false,
                                 default = nil)
  if valid_589739 != nil:
    section.add "fields", valid_589739
  var valid_589740 = query.getOrDefault("quotaUser")
  valid_589740 = validateParameter(valid_589740, JString, required = false,
                                 default = nil)
  if valid_589740 != nil:
    section.add "quotaUser", valid_589740
  var valid_589741 = query.getOrDefault("alt")
  valid_589741 = validateParameter(valid_589741, JString, required = false,
                                 default = newJString("json"))
  if valid_589741 != nil:
    section.add "alt", valid_589741
  var valid_589742 = query.getOrDefault("oauth_token")
  valid_589742 = validateParameter(valid_589742, JString, required = false,
                                 default = nil)
  if valid_589742 != nil:
    section.add "oauth_token", valid_589742
  var valid_589743 = query.getOrDefault("userIp")
  valid_589743 = validateParameter(valid_589743, JString, required = false,
                                 default = nil)
  if valid_589743 != nil:
    section.add "userIp", valid_589743
  var valid_589744 = query.getOrDefault("userProject")
  valid_589744 = validateParameter(valid_589744, JString, required = false,
                                 default = nil)
  if valid_589744 != nil:
    section.add "userProject", valid_589744
  var valid_589745 = query.getOrDefault("key")
  valid_589745 = validateParameter(valid_589745, JString, required = false,
                                 default = nil)
  if valid_589745 != nil:
    section.add "key", valid_589745
  var valid_589746 = query.getOrDefault("generation")
  valid_589746 = validateParameter(valid_589746, JString, required = false,
                                 default = nil)
  if valid_589746 != nil:
    section.add "generation", valid_589746
  var valid_589747 = query.getOrDefault("prettyPrint")
  valid_589747 = validateParameter(valid_589747, JBool, required = false,
                                 default = newJBool(true))
  if valid_589747 != nil:
    section.add "prettyPrint", valid_589747
  var valid_589748 = query.getOrDefault("provisionalUserProject")
  valid_589748 = validateParameter(valid_589748, JString, required = false,
                                 default = nil)
  if valid_589748 != nil:
    section.add "provisionalUserProject", valid_589748
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

proc call*(call_589750: Call_StorageObjectAccessControlsUpdate_589733;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Updates an ACL entry on the specified object.
  ## 
  let valid = call_589750.validator(path, query, header, formData, body)
  let scheme = call_589750.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589750.url(scheme.get, call_589750.host, call_589750.base,
                         call_589750.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589750, url, valid)

proc call*(call_589751: Call_StorageObjectAccessControlsUpdate_589733;
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
  var path_589752 = newJObject()
  var query_589753 = newJObject()
  var body_589754 = newJObject()
  add(path_589752, "bucket", newJString(bucket))
  add(query_589753, "fields", newJString(fields))
  add(query_589753, "quotaUser", newJString(quotaUser))
  add(query_589753, "alt", newJString(alt))
  add(query_589753, "oauth_token", newJString(oauthToken))
  add(query_589753, "userIp", newJString(userIp))
  add(query_589753, "userProject", newJString(userProject))
  add(query_589753, "key", newJString(key))
  add(query_589753, "generation", newJString(generation))
  if body != nil:
    body_589754 = body
  add(query_589753, "prettyPrint", newJBool(prettyPrint))
  add(path_589752, "entity", newJString(entity))
  add(path_589752, "object", newJString(`object`))
  add(query_589753, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589751.call(path_589752, query_589753, nil, nil, body_589754)

var storageObjectAccessControlsUpdate* = Call_StorageObjectAccessControlsUpdate_589733(
    name: "storageObjectAccessControlsUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsUpdate_589734,
    base: "/storage/v1", url: url_StorageObjectAccessControlsUpdate_589735,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsGet_589713 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsGet_589715(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsGet_589714(path: JsonNode;
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
  var valid_589716 = path.getOrDefault("bucket")
  valid_589716 = validateParameter(valid_589716, JString, required = true,
                                 default = nil)
  if valid_589716 != nil:
    section.add "bucket", valid_589716
  var valid_589717 = path.getOrDefault("entity")
  valid_589717 = validateParameter(valid_589717, JString, required = true,
                                 default = nil)
  if valid_589717 != nil:
    section.add "entity", valid_589717
  var valid_589718 = path.getOrDefault("object")
  valid_589718 = validateParameter(valid_589718, JString, required = true,
                                 default = nil)
  if valid_589718 != nil:
    section.add "object", valid_589718
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
  var valid_589719 = query.getOrDefault("fields")
  valid_589719 = validateParameter(valid_589719, JString, required = false,
                                 default = nil)
  if valid_589719 != nil:
    section.add "fields", valid_589719
  var valid_589720 = query.getOrDefault("quotaUser")
  valid_589720 = validateParameter(valid_589720, JString, required = false,
                                 default = nil)
  if valid_589720 != nil:
    section.add "quotaUser", valid_589720
  var valid_589721 = query.getOrDefault("alt")
  valid_589721 = validateParameter(valid_589721, JString, required = false,
                                 default = newJString("json"))
  if valid_589721 != nil:
    section.add "alt", valid_589721
  var valid_589722 = query.getOrDefault("oauth_token")
  valid_589722 = validateParameter(valid_589722, JString, required = false,
                                 default = nil)
  if valid_589722 != nil:
    section.add "oauth_token", valid_589722
  var valid_589723 = query.getOrDefault("userIp")
  valid_589723 = validateParameter(valid_589723, JString, required = false,
                                 default = nil)
  if valid_589723 != nil:
    section.add "userIp", valid_589723
  var valid_589724 = query.getOrDefault("userProject")
  valid_589724 = validateParameter(valid_589724, JString, required = false,
                                 default = nil)
  if valid_589724 != nil:
    section.add "userProject", valid_589724
  var valid_589725 = query.getOrDefault("key")
  valid_589725 = validateParameter(valid_589725, JString, required = false,
                                 default = nil)
  if valid_589725 != nil:
    section.add "key", valid_589725
  var valid_589726 = query.getOrDefault("generation")
  valid_589726 = validateParameter(valid_589726, JString, required = false,
                                 default = nil)
  if valid_589726 != nil:
    section.add "generation", valid_589726
  var valid_589727 = query.getOrDefault("prettyPrint")
  valid_589727 = validateParameter(valid_589727, JBool, required = false,
                                 default = newJBool(true))
  if valid_589727 != nil:
    section.add "prettyPrint", valid_589727
  var valid_589728 = query.getOrDefault("provisionalUserProject")
  valid_589728 = validateParameter(valid_589728, JString, required = false,
                                 default = nil)
  if valid_589728 != nil:
    section.add "provisionalUserProject", valid_589728
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589729: Call_StorageObjectAccessControlsGet_589713; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_589729.validator(path, query, header, formData, body)
  let scheme = call_589729.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589729.url(scheme.get, call_589729.host, call_589729.base,
                         call_589729.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589729, url, valid)

proc call*(call_589730: Call_StorageObjectAccessControlsGet_589713; bucket: string;
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
  var path_589731 = newJObject()
  var query_589732 = newJObject()
  add(path_589731, "bucket", newJString(bucket))
  add(query_589732, "fields", newJString(fields))
  add(query_589732, "quotaUser", newJString(quotaUser))
  add(query_589732, "alt", newJString(alt))
  add(query_589732, "oauth_token", newJString(oauthToken))
  add(query_589732, "userIp", newJString(userIp))
  add(query_589732, "userProject", newJString(userProject))
  add(query_589732, "key", newJString(key))
  add(query_589732, "generation", newJString(generation))
  add(query_589732, "prettyPrint", newJBool(prettyPrint))
  add(path_589731, "entity", newJString(entity))
  add(path_589731, "object", newJString(`object`))
  add(query_589732, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589730.call(path_589731, query_589732, nil, nil, nil)

var storageObjectAccessControlsGet* = Call_StorageObjectAccessControlsGet_589713(
    name: "storageObjectAccessControlsGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsGet_589714,
    base: "/storage/v1", url: url_StorageObjectAccessControlsGet_589715,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsPatch_589775 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsPatch_589777(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsPatch_589776(path: JsonNode;
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
  var valid_589778 = path.getOrDefault("bucket")
  valid_589778 = validateParameter(valid_589778, JString, required = true,
                                 default = nil)
  if valid_589778 != nil:
    section.add "bucket", valid_589778
  var valid_589779 = path.getOrDefault("entity")
  valid_589779 = validateParameter(valid_589779, JString, required = true,
                                 default = nil)
  if valid_589779 != nil:
    section.add "entity", valid_589779
  var valid_589780 = path.getOrDefault("object")
  valid_589780 = validateParameter(valid_589780, JString, required = true,
                                 default = nil)
  if valid_589780 != nil:
    section.add "object", valid_589780
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
  var valid_589781 = query.getOrDefault("fields")
  valid_589781 = validateParameter(valid_589781, JString, required = false,
                                 default = nil)
  if valid_589781 != nil:
    section.add "fields", valid_589781
  var valid_589782 = query.getOrDefault("quotaUser")
  valid_589782 = validateParameter(valid_589782, JString, required = false,
                                 default = nil)
  if valid_589782 != nil:
    section.add "quotaUser", valid_589782
  var valid_589783 = query.getOrDefault("alt")
  valid_589783 = validateParameter(valid_589783, JString, required = false,
                                 default = newJString("json"))
  if valid_589783 != nil:
    section.add "alt", valid_589783
  var valid_589784 = query.getOrDefault("oauth_token")
  valid_589784 = validateParameter(valid_589784, JString, required = false,
                                 default = nil)
  if valid_589784 != nil:
    section.add "oauth_token", valid_589784
  var valid_589785 = query.getOrDefault("userIp")
  valid_589785 = validateParameter(valid_589785, JString, required = false,
                                 default = nil)
  if valid_589785 != nil:
    section.add "userIp", valid_589785
  var valid_589786 = query.getOrDefault("userProject")
  valid_589786 = validateParameter(valid_589786, JString, required = false,
                                 default = nil)
  if valid_589786 != nil:
    section.add "userProject", valid_589786
  var valid_589787 = query.getOrDefault("key")
  valid_589787 = validateParameter(valid_589787, JString, required = false,
                                 default = nil)
  if valid_589787 != nil:
    section.add "key", valid_589787
  var valid_589788 = query.getOrDefault("generation")
  valid_589788 = validateParameter(valid_589788, JString, required = false,
                                 default = nil)
  if valid_589788 != nil:
    section.add "generation", valid_589788
  var valid_589789 = query.getOrDefault("prettyPrint")
  valid_589789 = validateParameter(valid_589789, JBool, required = false,
                                 default = newJBool(true))
  if valid_589789 != nil:
    section.add "prettyPrint", valid_589789
  var valid_589790 = query.getOrDefault("provisionalUserProject")
  valid_589790 = validateParameter(valid_589790, JString, required = false,
                                 default = nil)
  if valid_589790 != nil:
    section.add "provisionalUserProject", valid_589790
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

proc call*(call_589792: Call_StorageObjectAccessControlsPatch_589775;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Patches an ACL entry on the specified object.
  ## 
  let valid = call_589792.validator(path, query, header, formData, body)
  let scheme = call_589792.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589792.url(scheme.get, call_589792.host, call_589792.base,
                         call_589792.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589792, url, valid)

proc call*(call_589793: Call_StorageObjectAccessControlsPatch_589775;
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
  var path_589794 = newJObject()
  var query_589795 = newJObject()
  var body_589796 = newJObject()
  add(path_589794, "bucket", newJString(bucket))
  add(query_589795, "fields", newJString(fields))
  add(query_589795, "quotaUser", newJString(quotaUser))
  add(query_589795, "alt", newJString(alt))
  add(query_589795, "oauth_token", newJString(oauthToken))
  add(query_589795, "userIp", newJString(userIp))
  add(query_589795, "userProject", newJString(userProject))
  add(query_589795, "key", newJString(key))
  add(query_589795, "generation", newJString(generation))
  if body != nil:
    body_589796 = body
  add(query_589795, "prettyPrint", newJBool(prettyPrint))
  add(path_589794, "entity", newJString(entity))
  add(path_589794, "object", newJString(`object`))
  add(query_589795, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589793.call(path_589794, query_589795, nil, nil, body_589796)

var storageObjectAccessControlsPatch* = Call_StorageObjectAccessControlsPatch_589775(
    name: "storageObjectAccessControlsPatch", meth: HttpMethod.HttpPatch,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsPatch_589776,
    base: "/storage/v1", url: url_StorageObjectAccessControlsPatch_589777,
    schemes: {Scheme.Https})
type
  Call_StorageObjectAccessControlsDelete_589755 = ref object of OpenApiRestCall_588457
proc url_StorageObjectAccessControlsDelete_589757(protocol: Scheme; host: string;
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

proc validate_StorageObjectAccessControlsDelete_589756(path: JsonNode;
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
  var valid_589758 = path.getOrDefault("bucket")
  valid_589758 = validateParameter(valid_589758, JString, required = true,
                                 default = nil)
  if valid_589758 != nil:
    section.add "bucket", valid_589758
  var valid_589759 = path.getOrDefault("entity")
  valid_589759 = validateParameter(valid_589759, JString, required = true,
                                 default = nil)
  if valid_589759 != nil:
    section.add "entity", valid_589759
  var valid_589760 = path.getOrDefault("object")
  valid_589760 = validateParameter(valid_589760, JString, required = true,
                                 default = nil)
  if valid_589760 != nil:
    section.add "object", valid_589760
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
  var valid_589761 = query.getOrDefault("fields")
  valid_589761 = validateParameter(valid_589761, JString, required = false,
                                 default = nil)
  if valid_589761 != nil:
    section.add "fields", valid_589761
  var valid_589762 = query.getOrDefault("quotaUser")
  valid_589762 = validateParameter(valid_589762, JString, required = false,
                                 default = nil)
  if valid_589762 != nil:
    section.add "quotaUser", valid_589762
  var valid_589763 = query.getOrDefault("alt")
  valid_589763 = validateParameter(valid_589763, JString, required = false,
                                 default = newJString("json"))
  if valid_589763 != nil:
    section.add "alt", valid_589763
  var valid_589764 = query.getOrDefault("oauth_token")
  valid_589764 = validateParameter(valid_589764, JString, required = false,
                                 default = nil)
  if valid_589764 != nil:
    section.add "oauth_token", valid_589764
  var valid_589765 = query.getOrDefault("userIp")
  valid_589765 = validateParameter(valid_589765, JString, required = false,
                                 default = nil)
  if valid_589765 != nil:
    section.add "userIp", valid_589765
  var valid_589766 = query.getOrDefault("userProject")
  valid_589766 = validateParameter(valid_589766, JString, required = false,
                                 default = nil)
  if valid_589766 != nil:
    section.add "userProject", valid_589766
  var valid_589767 = query.getOrDefault("key")
  valid_589767 = validateParameter(valid_589767, JString, required = false,
                                 default = nil)
  if valid_589767 != nil:
    section.add "key", valid_589767
  var valid_589768 = query.getOrDefault("generation")
  valid_589768 = validateParameter(valid_589768, JString, required = false,
                                 default = nil)
  if valid_589768 != nil:
    section.add "generation", valid_589768
  var valid_589769 = query.getOrDefault("prettyPrint")
  valid_589769 = validateParameter(valid_589769, JBool, required = false,
                                 default = newJBool(true))
  if valid_589769 != nil:
    section.add "prettyPrint", valid_589769
  var valid_589770 = query.getOrDefault("provisionalUserProject")
  valid_589770 = validateParameter(valid_589770, JString, required = false,
                                 default = nil)
  if valid_589770 != nil:
    section.add "provisionalUserProject", valid_589770
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589771: Call_StorageObjectAccessControlsDelete_589755;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Permanently deletes the ACL entry for the specified entity on the specified object.
  ## 
  let valid = call_589771.validator(path, query, header, formData, body)
  let scheme = call_589771.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589771.url(scheme.get, call_589771.host, call_589771.base,
                         call_589771.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589771, url, valid)

proc call*(call_589772: Call_StorageObjectAccessControlsDelete_589755;
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
  var path_589773 = newJObject()
  var query_589774 = newJObject()
  add(path_589773, "bucket", newJString(bucket))
  add(query_589774, "fields", newJString(fields))
  add(query_589774, "quotaUser", newJString(quotaUser))
  add(query_589774, "alt", newJString(alt))
  add(query_589774, "oauth_token", newJString(oauthToken))
  add(query_589774, "userIp", newJString(userIp))
  add(query_589774, "userProject", newJString(userProject))
  add(query_589774, "key", newJString(key))
  add(query_589774, "generation", newJString(generation))
  add(query_589774, "prettyPrint", newJBool(prettyPrint))
  add(path_589773, "entity", newJString(entity))
  add(path_589773, "object", newJString(`object`))
  add(query_589774, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589772.call(path_589773, query_589774, nil, nil, nil)

var storageObjectAccessControlsDelete* = Call_StorageObjectAccessControlsDelete_589755(
    name: "storageObjectAccessControlsDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/acl/{entity}",
    validator: validate_StorageObjectAccessControlsDelete_589756,
    base: "/storage/v1", url: url_StorageObjectAccessControlsDelete_589757,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsSetIamPolicy_589816 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsSetIamPolicy_589818(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsSetIamPolicy_589817(path: JsonNode; query: JsonNode;
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
  var valid_589819 = path.getOrDefault("bucket")
  valid_589819 = validateParameter(valid_589819, JString, required = true,
                                 default = nil)
  if valid_589819 != nil:
    section.add "bucket", valid_589819
  var valid_589820 = path.getOrDefault("object")
  valid_589820 = validateParameter(valid_589820, JString, required = true,
                                 default = nil)
  if valid_589820 != nil:
    section.add "object", valid_589820
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
  var valid_589821 = query.getOrDefault("fields")
  valid_589821 = validateParameter(valid_589821, JString, required = false,
                                 default = nil)
  if valid_589821 != nil:
    section.add "fields", valid_589821
  var valid_589822 = query.getOrDefault("quotaUser")
  valid_589822 = validateParameter(valid_589822, JString, required = false,
                                 default = nil)
  if valid_589822 != nil:
    section.add "quotaUser", valid_589822
  var valid_589823 = query.getOrDefault("alt")
  valid_589823 = validateParameter(valid_589823, JString, required = false,
                                 default = newJString("json"))
  if valid_589823 != nil:
    section.add "alt", valid_589823
  var valid_589824 = query.getOrDefault("oauth_token")
  valid_589824 = validateParameter(valid_589824, JString, required = false,
                                 default = nil)
  if valid_589824 != nil:
    section.add "oauth_token", valid_589824
  var valid_589825 = query.getOrDefault("userIp")
  valid_589825 = validateParameter(valid_589825, JString, required = false,
                                 default = nil)
  if valid_589825 != nil:
    section.add "userIp", valid_589825
  var valid_589826 = query.getOrDefault("userProject")
  valid_589826 = validateParameter(valid_589826, JString, required = false,
                                 default = nil)
  if valid_589826 != nil:
    section.add "userProject", valid_589826
  var valid_589827 = query.getOrDefault("key")
  valid_589827 = validateParameter(valid_589827, JString, required = false,
                                 default = nil)
  if valid_589827 != nil:
    section.add "key", valid_589827
  var valid_589828 = query.getOrDefault("generation")
  valid_589828 = validateParameter(valid_589828, JString, required = false,
                                 default = nil)
  if valid_589828 != nil:
    section.add "generation", valid_589828
  var valid_589829 = query.getOrDefault("prettyPrint")
  valid_589829 = validateParameter(valid_589829, JBool, required = false,
                                 default = newJBool(true))
  if valid_589829 != nil:
    section.add "prettyPrint", valid_589829
  var valid_589830 = query.getOrDefault("provisionalUserProject")
  valid_589830 = validateParameter(valid_589830, JString, required = false,
                                 default = nil)
  if valid_589830 != nil:
    section.add "provisionalUserProject", valid_589830
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

proc call*(call_589832: Call_StorageObjectsSetIamPolicy_589816; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates an IAM policy for the specified object.
  ## 
  let valid = call_589832.validator(path, query, header, formData, body)
  let scheme = call_589832.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589832.url(scheme.get, call_589832.host, call_589832.base,
                         call_589832.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589832, url, valid)

proc call*(call_589833: Call_StorageObjectsSetIamPolicy_589816; bucket: string;
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
  var path_589834 = newJObject()
  var query_589835 = newJObject()
  var body_589836 = newJObject()
  add(path_589834, "bucket", newJString(bucket))
  add(query_589835, "fields", newJString(fields))
  add(query_589835, "quotaUser", newJString(quotaUser))
  add(query_589835, "alt", newJString(alt))
  add(query_589835, "oauth_token", newJString(oauthToken))
  add(query_589835, "userIp", newJString(userIp))
  add(query_589835, "userProject", newJString(userProject))
  add(query_589835, "key", newJString(key))
  add(query_589835, "generation", newJString(generation))
  if body != nil:
    body_589836 = body
  add(query_589835, "prettyPrint", newJBool(prettyPrint))
  add(path_589834, "object", newJString(`object`))
  add(query_589835, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589833.call(path_589834, query_589835, nil, nil, body_589836)

var storageObjectsSetIamPolicy* = Call_StorageObjectsSetIamPolicy_589816(
    name: "storageObjectsSetIamPolicy", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsSetIamPolicy_589817, base: "/storage/v1",
    url: url_StorageObjectsSetIamPolicy_589818, schemes: {Scheme.Https})
type
  Call_StorageObjectsGetIamPolicy_589797 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsGetIamPolicy_589799(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsGetIamPolicy_589798(path: JsonNode; query: JsonNode;
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
  var valid_589800 = path.getOrDefault("bucket")
  valid_589800 = validateParameter(valid_589800, JString, required = true,
                                 default = nil)
  if valid_589800 != nil:
    section.add "bucket", valid_589800
  var valid_589801 = path.getOrDefault("object")
  valid_589801 = validateParameter(valid_589801, JString, required = true,
                                 default = nil)
  if valid_589801 != nil:
    section.add "object", valid_589801
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
  var valid_589802 = query.getOrDefault("fields")
  valid_589802 = validateParameter(valid_589802, JString, required = false,
                                 default = nil)
  if valid_589802 != nil:
    section.add "fields", valid_589802
  var valid_589803 = query.getOrDefault("quotaUser")
  valid_589803 = validateParameter(valid_589803, JString, required = false,
                                 default = nil)
  if valid_589803 != nil:
    section.add "quotaUser", valid_589803
  var valid_589804 = query.getOrDefault("alt")
  valid_589804 = validateParameter(valid_589804, JString, required = false,
                                 default = newJString("json"))
  if valid_589804 != nil:
    section.add "alt", valid_589804
  var valid_589805 = query.getOrDefault("oauth_token")
  valid_589805 = validateParameter(valid_589805, JString, required = false,
                                 default = nil)
  if valid_589805 != nil:
    section.add "oauth_token", valid_589805
  var valid_589806 = query.getOrDefault("userIp")
  valid_589806 = validateParameter(valid_589806, JString, required = false,
                                 default = nil)
  if valid_589806 != nil:
    section.add "userIp", valid_589806
  var valid_589807 = query.getOrDefault("userProject")
  valid_589807 = validateParameter(valid_589807, JString, required = false,
                                 default = nil)
  if valid_589807 != nil:
    section.add "userProject", valid_589807
  var valid_589808 = query.getOrDefault("key")
  valid_589808 = validateParameter(valid_589808, JString, required = false,
                                 default = nil)
  if valid_589808 != nil:
    section.add "key", valid_589808
  var valid_589809 = query.getOrDefault("generation")
  valid_589809 = validateParameter(valid_589809, JString, required = false,
                                 default = nil)
  if valid_589809 != nil:
    section.add "generation", valid_589809
  var valid_589810 = query.getOrDefault("prettyPrint")
  valid_589810 = validateParameter(valid_589810, JBool, required = false,
                                 default = newJBool(true))
  if valid_589810 != nil:
    section.add "prettyPrint", valid_589810
  var valid_589811 = query.getOrDefault("provisionalUserProject")
  valid_589811 = validateParameter(valid_589811, JString, required = false,
                                 default = nil)
  if valid_589811 != nil:
    section.add "provisionalUserProject", valid_589811
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589812: Call_StorageObjectsGetIamPolicy_589797; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Returns an IAM policy for the specified object.
  ## 
  let valid = call_589812.validator(path, query, header, formData, body)
  let scheme = call_589812.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589812.url(scheme.get, call_589812.host, call_589812.base,
                         call_589812.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589812, url, valid)

proc call*(call_589813: Call_StorageObjectsGetIamPolicy_589797; bucket: string;
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
  var path_589814 = newJObject()
  var query_589815 = newJObject()
  add(path_589814, "bucket", newJString(bucket))
  add(query_589815, "fields", newJString(fields))
  add(query_589815, "quotaUser", newJString(quotaUser))
  add(query_589815, "alt", newJString(alt))
  add(query_589815, "oauth_token", newJString(oauthToken))
  add(query_589815, "userIp", newJString(userIp))
  add(query_589815, "userProject", newJString(userProject))
  add(query_589815, "key", newJString(key))
  add(query_589815, "generation", newJString(generation))
  add(query_589815, "prettyPrint", newJBool(prettyPrint))
  add(path_589814, "object", newJString(`object`))
  add(query_589815, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589813.call(path_589814, query_589815, nil, nil, nil)

var storageObjectsGetIamPolicy* = Call_StorageObjectsGetIamPolicy_589797(
    name: "storageObjectsGetIamPolicy", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/b/{bucket}/o/{object}/iam",
    validator: validate_StorageObjectsGetIamPolicy_589798, base: "/storage/v1",
    url: url_StorageObjectsGetIamPolicy_589799, schemes: {Scheme.Https})
type
  Call_StorageObjectsTestIamPermissions_589837 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsTestIamPermissions_589839(protocol: Scheme; host: string;
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
               (kind: ConstantSegment, value: "/iam/testPermissions")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsTestIamPermissions_589838(path: JsonNode;
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
  var valid_589840 = path.getOrDefault("bucket")
  valid_589840 = validateParameter(valid_589840, JString, required = true,
                                 default = nil)
  if valid_589840 != nil:
    section.add "bucket", valid_589840
  var valid_589841 = path.getOrDefault("object")
  valid_589841 = validateParameter(valid_589841, JString, required = true,
                                 default = nil)
  if valid_589841 != nil:
    section.add "object", valid_589841
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
  var valid_589842 = query.getOrDefault("fields")
  valid_589842 = validateParameter(valid_589842, JString, required = false,
                                 default = nil)
  if valid_589842 != nil:
    section.add "fields", valid_589842
  var valid_589843 = query.getOrDefault("quotaUser")
  valid_589843 = validateParameter(valid_589843, JString, required = false,
                                 default = nil)
  if valid_589843 != nil:
    section.add "quotaUser", valid_589843
  assert query != nil,
        "query argument is necessary due to required `permissions` field"
  var valid_589844 = query.getOrDefault("permissions")
  valid_589844 = validateParameter(valid_589844, JArray, required = true, default = nil)
  if valid_589844 != nil:
    section.add "permissions", valid_589844
  var valid_589845 = query.getOrDefault("alt")
  valid_589845 = validateParameter(valid_589845, JString, required = false,
                                 default = newJString("json"))
  if valid_589845 != nil:
    section.add "alt", valid_589845
  var valid_589846 = query.getOrDefault("oauth_token")
  valid_589846 = validateParameter(valid_589846, JString, required = false,
                                 default = nil)
  if valid_589846 != nil:
    section.add "oauth_token", valid_589846
  var valid_589847 = query.getOrDefault("userIp")
  valid_589847 = validateParameter(valid_589847, JString, required = false,
                                 default = nil)
  if valid_589847 != nil:
    section.add "userIp", valid_589847
  var valid_589848 = query.getOrDefault("userProject")
  valid_589848 = validateParameter(valid_589848, JString, required = false,
                                 default = nil)
  if valid_589848 != nil:
    section.add "userProject", valid_589848
  var valid_589849 = query.getOrDefault("key")
  valid_589849 = validateParameter(valid_589849, JString, required = false,
                                 default = nil)
  if valid_589849 != nil:
    section.add "key", valid_589849
  var valid_589850 = query.getOrDefault("generation")
  valid_589850 = validateParameter(valid_589850, JString, required = false,
                                 default = nil)
  if valid_589850 != nil:
    section.add "generation", valid_589850
  var valid_589851 = query.getOrDefault("prettyPrint")
  valid_589851 = validateParameter(valid_589851, JBool, required = false,
                                 default = newJBool(true))
  if valid_589851 != nil:
    section.add "prettyPrint", valid_589851
  var valid_589852 = query.getOrDefault("provisionalUserProject")
  valid_589852 = validateParameter(valid_589852, JString, required = false,
                                 default = nil)
  if valid_589852 != nil:
    section.add "provisionalUserProject", valid_589852
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589853: Call_StorageObjectsTestIamPermissions_589837;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Tests a set of permissions on the given object to see which, if any, are held by the caller.
  ## 
  let valid = call_589853.validator(path, query, header, formData, body)
  let scheme = call_589853.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589853.url(scheme.get, call_589853.host, call_589853.base,
                         call_589853.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589853, url, valid)

proc call*(call_589854: Call_StorageObjectsTestIamPermissions_589837;
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
  var path_589855 = newJObject()
  var query_589856 = newJObject()
  add(path_589855, "bucket", newJString(bucket))
  add(query_589856, "fields", newJString(fields))
  add(query_589856, "quotaUser", newJString(quotaUser))
  if permissions != nil:
    query_589856.add "permissions", permissions
  add(query_589856, "alt", newJString(alt))
  add(query_589856, "oauth_token", newJString(oauthToken))
  add(query_589856, "userIp", newJString(userIp))
  add(query_589856, "userProject", newJString(userProject))
  add(query_589856, "key", newJString(key))
  add(query_589856, "generation", newJString(generation))
  add(query_589856, "prettyPrint", newJBool(prettyPrint))
  add(path_589855, "object", newJString(`object`))
  add(query_589856, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589854.call(path_589855, query_589856, nil, nil, nil)

var storageObjectsTestIamPermissions* = Call_StorageObjectsTestIamPermissions_589837(
    name: "storageObjectsTestIamPermissions", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/b/{bucket}/o/{object}/iam/testPermissions",
    validator: validate_StorageObjectsTestIamPermissions_589838,
    base: "/storage/v1", url: url_StorageObjectsTestIamPermissions_589839,
    schemes: {Scheme.Https})
type
  Call_StorageObjectsCompose_589857 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsCompose_589859(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsCompose_589858(path: JsonNode; query: JsonNode;
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
  var valid_589860 = path.getOrDefault("destinationBucket")
  valid_589860 = validateParameter(valid_589860, JString, required = true,
                                 default = nil)
  if valid_589860 != nil:
    section.add "destinationBucket", valid_589860
  var valid_589861 = path.getOrDefault("destinationObject")
  valid_589861 = validateParameter(valid_589861, JString, required = true,
                                 default = nil)
  if valid_589861 != nil:
    section.add "destinationObject", valid_589861
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
  var valid_589862 = query.getOrDefault("ifGenerationMatch")
  valid_589862 = validateParameter(valid_589862, JString, required = false,
                                 default = nil)
  if valid_589862 != nil:
    section.add "ifGenerationMatch", valid_589862
  var valid_589863 = query.getOrDefault("kmsKeyName")
  valid_589863 = validateParameter(valid_589863, JString, required = false,
                                 default = nil)
  if valid_589863 != nil:
    section.add "kmsKeyName", valid_589863
  var valid_589864 = query.getOrDefault("fields")
  valid_589864 = validateParameter(valid_589864, JString, required = false,
                                 default = nil)
  if valid_589864 != nil:
    section.add "fields", valid_589864
  var valid_589865 = query.getOrDefault("quotaUser")
  valid_589865 = validateParameter(valid_589865, JString, required = false,
                                 default = nil)
  if valid_589865 != nil:
    section.add "quotaUser", valid_589865
  var valid_589866 = query.getOrDefault("alt")
  valid_589866 = validateParameter(valid_589866, JString, required = false,
                                 default = newJString("json"))
  if valid_589866 != nil:
    section.add "alt", valid_589866
  var valid_589867 = query.getOrDefault("oauth_token")
  valid_589867 = validateParameter(valid_589867, JString, required = false,
                                 default = nil)
  if valid_589867 != nil:
    section.add "oauth_token", valid_589867
  var valid_589868 = query.getOrDefault("userIp")
  valid_589868 = validateParameter(valid_589868, JString, required = false,
                                 default = nil)
  if valid_589868 != nil:
    section.add "userIp", valid_589868
  var valid_589869 = query.getOrDefault("userProject")
  valid_589869 = validateParameter(valid_589869, JString, required = false,
                                 default = nil)
  if valid_589869 != nil:
    section.add "userProject", valid_589869
  var valid_589870 = query.getOrDefault("key")
  valid_589870 = validateParameter(valid_589870, JString, required = false,
                                 default = nil)
  if valid_589870 != nil:
    section.add "key", valid_589870
  var valid_589871 = query.getOrDefault("destinationPredefinedAcl")
  valid_589871 = validateParameter(valid_589871, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589871 != nil:
    section.add "destinationPredefinedAcl", valid_589871
  var valid_589872 = query.getOrDefault("ifMetagenerationMatch")
  valid_589872 = validateParameter(valid_589872, JString, required = false,
                                 default = nil)
  if valid_589872 != nil:
    section.add "ifMetagenerationMatch", valid_589872
  var valid_589873 = query.getOrDefault("prettyPrint")
  valid_589873 = validateParameter(valid_589873, JBool, required = false,
                                 default = newJBool(true))
  if valid_589873 != nil:
    section.add "prettyPrint", valid_589873
  var valid_589874 = query.getOrDefault("provisionalUserProject")
  valid_589874 = validateParameter(valid_589874, JString, required = false,
                                 default = nil)
  if valid_589874 != nil:
    section.add "provisionalUserProject", valid_589874
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

proc call*(call_589876: Call_StorageObjectsCompose_589857; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Concatenates a list of existing objects into a new object in the same bucket.
  ## 
  let valid = call_589876.validator(path, query, header, formData, body)
  let scheme = call_589876.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589876.url(scheme.get, call_589876.host, call_589876.base,
                         call_589876.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589876, url, valid)

proc call*(call_589877: Call_StorageObjectsCompose_589857;
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
  var path_589878 = newJObject()
  var query_589879 = newJObject()
  var body_589880 = newJObject()
  add(query_589879, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_589879, "kmsKeyName", newJString(kmsKeyName))
  add(query_589879, "fields", newJString(fields))
  add(query_589879, "quotaUser", newJString(quotaUser))
  add(query_589879, "alt", newJString(alt))
  add(query_589879, "oauth_token", newJString(oauthToken))
  add(path_589878, "destinationBucket", newJString(destinationBucket))
  add(query_589879, "userIp", newJString(userIp))
  add(path_589878, "destinationObject", newJString(destinationObject))
  add(query_589879, "userProject", newJString(userProject))
  add(query_589879, "key", newJString(key))
  add(query_589879, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_589879, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  if body != nil:
    body_589880 = body
  add(query_589879, "prettyPrint", newJBool(prettyPrint))
  add(query_589879, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589877.call(path_589878, query_589879, nil, nil, body_589880)

var storageObjectsCompose* = Call_StorageObjectsCompose_589857(
    name: "storageObjectsCompose", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com",
    route: "/b/{destinationBucket}/o/{destinationObject}/compose",
    validator: validate_StorageObjectsCompose_589858, base: "/storage/v1",
    url: url_StorageObjectsCompose_589859, schemes: {Scheme.Https})
type
  Call_StorageObjectsCopy_589881 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsCopy_589883(protocol: Scheme; host: string; base: string;
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

proc validate_StorageObjectsCopy_589882(path: JsonNode; query: JsonNode;
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
  var valid_589884 = path.getOrDefault("destinationBucket")
  valid_589884 = validateParameter(valid_589884, JString, required = true,
                                 default = nil)
  if valid_589884 != nil:
    section.add "destinationBucket", valid_589884
  var valid_589885 = path.getOrDefault("destinationObject")
  valid_589885 = validateParameter(valid_589885, JString, required = true,
                                 default = nil)
  if valid_589885 != nil:
    section.add "destinationObject", valid_589885
  var valid_589886 = path.getOrDefault("sourceBucket")
  valid_589886 = validateParameter(valid_589886, JString, required = true,
                                 default = nil)
  if valid_589886 != nil:
    section.add "sourceBucket", valid_589886
  var valid_589887 = path.getOrDefault("sourceObject")
  valid_589887 = validateParameter(valid_589887, JString, required = true,
                                 default = nil)
  if valid_589887 != nil:
    section.add "sourceObject", valid_589887
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
  var valid_589888 = query.getOrDefault("ifGenerationMatch")
  valid_589888 = validateParameter(valid_589888, JString, required = false,
                                 default = nil)
  if valid_589888 != nil:
    section.add "ifGenerationMatch", valid_589888
  var valid_589889 = query.getOrDefault("ifSourceGenerationMatch")
  valid_589889 = validateParameter(valid_589889, JString, required = false,
                                 default = nil)
  if valid_589889 != nil:
    section.add "ifSourceGenerationMatch", valid_589889
  var valid_589890 = query.getOrDefault("fields")
  valid_589890 = validateParameter(valid_589890, JString, required = false,
                                 default = nil)
  if valid_589890 != nil:
    section.add "fields", valid_589890
  var valid_589891 = query.getOrDefault("quotaUser")
  valid_589891 = validateParameter(valid_589891, JString, required = false,
                                 default = nil)
  if valid_589891 != nil:
    section.add "quotaUser", valid_589891
  var valid_589892 = query.getOrDefault("alt")
  valid_589892 = validateParameter(valid_589892, JString, required = false,
                                 default = newJString("json"))
  if valid_589892 != nil:
    section.add "alt", valid_589892
  var valid_589893 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_589893 = validateParameter(valid_589893, JString, required = false,
                                 default = nil)
  if valid_589893 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_589893
  var valid_589894 = query.getOrDefault("ifGenerationNotMatch")
  valid_589894 = validateParameter(valid_589894, JString, required = false,
                                 default = nil)
  if valid_589894 != nil:
    section.add "ifGenerationNotMatch", valid_589894
  var valid_589895 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_589895 = validateParameter(valid_589895, JString, required = false,
                                 default = nil)
  if valid_589895 != nil:
    section.add "ifSourceMetagenerationMatch", valid_589895
  var valid_589896 = query.getOrDefault("oauth_token")
  valid_589896 = validateParameter(valid_589896, JString, required = false,
                                 default = nil)
  if valid_589896 != nil:
    section.add "oauth_token", valid_589896
  var valid_589897 = query.getOrDefault("sourceGeneration")
  valid_589897 = validateParameter(valid_589897, JString, required = false,
                                 default = nil)
  if valid_589897 != nil:
    section.add "sourceGeneration", valid_589897
  var valid_589898 = query.getOrDefault("userIp")
  valid_589898 = validateParameter(valid_589898, JString, required = false,
                                 default = nil)
  if valid_589898 != nil:
    section.add "userIp", valid_589898
  var valid_589899 = query.getOrDefault("userProject")
  valid_589899 = validateParameter(valid_589899, JString, required = false,
                                 default = nil)
  if valid_589899 != nil:
    section.add "userProject", valid_589899
  var valid_589900 = query.getOrDefault("key")
  valid_589900 = validateParameter(valid_589900, JString, required = false,
                                 default = nil)
  if valid_589900 != nil:
    section.add "key", valid_589900
  var valid_589901 = query.getOrDefault("projection")
  valid_589901 = validateParameter(valid_589901, JString, required = false,
                                 default = newJString("full"))
  if valid_589901 != nil:
    section.add "projection", valid_589901
  var valid_589902 = query.getOrDefault("destinationPredefinedAcl")
  valid_589902 = validateParameter(valid_589902, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589902 != nil:
    section.add "destinationPredefinedAcl", valid_589902
  var valid_589903 = query.getOrDefault("ifMetagenerationMatch")
  valid_589903 = validateParameter(valid_589903, JString, required = false,
                                 default = nil)
  if valid_589903 != nil:
    section.add "ifMetagenerationMatch", valid_589903
  var valid_589904 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_589904 = validateParameter(valid_589904, JString, required = false,
                                 default = nil)
  if valid_589904 != nil:
    section.add "ifSourceGenerationNotMatch", valid_589904
  var valid_589905 = query.getOrDefault("prettyPrint")
  valid_589905 = validateParameter(valid_589905, JBool, required = false,
                                 default = newJBool(true))
  if valid_589905 != nil:
    section.add "prettyPrint", valid_589905
  var valid_589906 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589906 = validateParameter(valid_589906, JString, required = false,
                                 default = nil)
  if valid_589906 != nil:
    section.add "ifMetagenerationNotMatch", valid_589906
  var valid_589907 = query.getOrDefault("provisionalUserProject")
  valid_589907 = validateParameter(valid_589907, JString, required = false,
                                 default = nil)
  if valid_589907 != nil:
    section.add "provisionalUserProject", valid_589907
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

proc call*(call_589909: Call_StorageObjectsCopy_589881; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Copies a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_589909.validator(path, query, header, formData, body)
  let scheme = call_589909.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589909.url(scheme.get, call_589909.host, call_589909.base,
                         call_589909.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589909, url, valid)

proc call*(call_589910: Call_StorageObjectsCopy_589881; destinationBucket: string;
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
  var path_589911 = newJObject()
  var query_589912 = newJObject()
  var body_589913 = newJObject()
  add(query_589912, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_589912, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_589912, "fields", newJString(fields))
  add(query_589912, "quotaUser", newJString(quotaUser))
  add(query_589912, "alt", newJString(alt))
  add(query_589912, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_589912, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_589912, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_589912, "oauth_token", newJString(oauthToken))
  add(query_589912, "sourceGeneration", newJString(sourceGeneration))
  add(path_589911, "destinationBucket", newJString(destinationBucket))
  add(query_589912, "userIp", newJString(userIp))
  add(path_589911, "destinationObject", newJString(destinationObject))
  add(path_589911, "sourceBucket", newJString(sourceBucket))
  add(query_589912, "userProject", newJString(userProject))
  add(query_589912, "key", newJString(key))
  add(path_589911, "sourceObject", newJString(sourceObject))
  add(query_589912, "projection", newJString(projection))
  add(query_589912, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_589912, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589912, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_589913 = body
  add(query_589912, "prettyPrint", newJBool(prettyPrint))
  add(query_589912, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589912, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589910.call(path_589911, query_589912, nil, nil, body_589913)

var storageObjectsCopy* = Call_StorageObjectsCopy_589881(
    name: "storageObjectsCopy", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/copyTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsCopy_589882, base: "/storage/v1",
    url: url_StorageObjectsCopy_589883, schemes: {Scheme.Https})
type
  Call_StorageObjectsRewrite_589914 = ref object of OpenApiRestCall_588457
proc url_StorageObjectsRewrite_589916(protocol: Scheme; host: string; base: string;
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
               (kind: ConstantSegment, value: "/rewriteTo/b/"),
               (kind: VariableSegment, value: "destinationBucket"),
               (kind: ConstantSegment, value: "/o/"),
               (kind: VariableSegment, value: "destinationObject")]
  var hydrated = hydratePath(path, segments)
  if hydrated.isNone:
    raise newException(ValueError, "unable to fully hydrate path")
  result.path = base & hydrated.get

proc validate_StorageObjectsRewrite_589915(path: JsonNode; query: JsonNode;
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
  var valid_589917 = path.getOrDefault("destinationBucket")
  valid_589917 = validateParameter(valid_589917, JString, required = true,
                                 default = nil)
  if valid_589917 != nil:
    section.add "destinationBucket", valid_589917
  var valid_589918 = path.getOrDefault("destinationObject")
  valid_589918 = validateParameter(valid_589918, JString, required = true,
                                 default = nil)
  if valid_589918 != nil:
    section.add "destinationObject", valid_589918
  var valid_589919 = path.getOrDefault("sourceBucket")
  valid_589919 = validateParameter(valid_589919, JString, required = true,
                                 default = nil)
  if valid_589919 != nil:
    section.add "sourceBucket", valid_589919
  var valid_589920 = path.getOrDefault("sourceObject")
  valid_589920 = validateParameter(valid_589920, JString, required = true,
                                 default = nil)
  if valid_589920 != nil:
    section.add "sourceObject", valid_589920
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
  var valid_589921 = query.getOrDefault("ifGenerationMatch")
  valid_589921 = validateParameter(valid_589921, JString, required = false,
                                 default = nil)
  if valid_589921 != nil:
    section.add "ifGenerationMatch", valid_589921
  var valid_589922 = query.getOrDefault("ifSourceGenerationMatch")
  valid_589922 = validateParameter(valid_589922, JString, required = false,
                                 default = nil)
  if valid_589922 != nil:
    section.add "ifSourceGenerationMatch", valid_589922
  var valid_589923 = query.getOrDefault("fields")
  valid_589923 = validateParameter(valid_589923, JString, required = false,
                                 default = nil)
  if valid_589923 != nil:
    section.add "fields", valid_589923
  var valid_589924 = query.getOrDefault("quotaUser")
  valid_589924 = validateParameter(valid_589924, JString, required = false,
                                 default = nil)
  if valid_589924 != nil:
    section.add "quotaUser", valid_589924
  var valid_589925 = query.getOrDefault("alt")
  valid_589925 = validateParameter(valid_589925, JString, required = false,
                                 default = newJString("json"))
  if valid_589925 != nil:
    section.add "alt", valid_589925
  var valid_589926 = query.getOrDefault("ifSourceMetagenerationNotMatch")
  valid_589926 = validateParameter(valid_589926, JString, required = false,
                                 default = nil)
  if valid_589926 != nil:
    section.add "ifSourceMetagenerationNotMatch", valid_589926
  var valid_589927 = query.getOrDefault("ifGenerationNotMatch")
  valid_589927 = validateParameter(valid_589927, JString, required = false,
                                 default = nil)
  if valid_589927 != nil:
    section.add "ifGenerationNotMatch", valid_589927
  var valid_589928 = query.getOrDefault("ifSourceMetagenerationMatch")
  valid_589928 = validateParameter(valid_589928, JString, required = false,
                                 default = nil)
  if valid_589928 != nil:
    section.add "ifSourceMetagenerationMatch", valid_589928
  var valid_589929 = query.getOrDefault("oauth_token")
  valid_589929 = validateParameter(valid_589929, JString, required = false,
                                 default = nil)
  if valid_589929 != nil:
    section.add "oauth_token", valid_589929
  var valid_589930 = query.getOrDefault("sourceGeneration")
  valid_589930 = validateParameter(valid_589930, JString, required = false,
                                 default = nil)
  if valid_589930 != nil:
    section.add "sourceGeneration", valid_589930
  var valid_589931 = query.getOrDefault("userIp")
  valid_589931 = validateParameter(valid_589931, JString, required = false,
                                 default = nil)
  if valid_589931 != nil:
    section.add "userIp", valid_589931
  var valid_589932 = query.getOrDefault("destinationKmsKeyName")
  valid_589932 = validateParameter(valid_589932, JString, required = false,
                                 default = nil)
  if valid_589932 != nil:
    section.add "destinationKmsKeyName", valid_589932
  var valid_589933 = query.getOrDefault("userProject")
  valid_589933 = validateParameter(valid_589933, JString, required = false,
                                 default = nil)
  if valid_589933 != nil:
    section.add "userProject", valid_589933
  var valid_589934 = query.getOrDefault("key")
  valid_589934 = validateParameter(valid_589934, JString, required = false,
                                 default = nil)
  if valid_589934 != nil:
    section.add "key", valid_589934
  var valid_589935 = query.getOrDefault("projection")
  valid_589935 = validateParameter(valid_589935, JString, required = false,
                                 default = newJString("full"))
  if valid_589935 != nil:
    section.add "projection", valid_589935
  var valid_589936 = query.getOrDefault("destinationPredefinedAcl")
  valid_589936 = validateParameter(valid_589936, JString, required = false,
                                 default = newJString("authenticatedRead"))
  if valid_589936 != nil:
    section.add "destinationPredefinedAcl", valid_589936
  var valid_589937 = query.getOrDefault("ifMetagenerationMatch")
  valid_589937 = validateParameter(valid_589937, JString, required = false,
                                 default = nil)
  if valid_589937 != nil:
    section.add "ifMetagenerationMatch", valid_589937
  var valid_589938 = query.getOrDefault("ifSourceGenerationNotMatch")
  valid_589938 = validateParameter(valid_589938, JString, required = false,
                                 default = nil)
  if valid_589938 != nil:
    section.add "ifSourceGenerationNotMatch", valid_589938
  var valid_589939 = query.getOrDefault("prettyPrint")
  valid_589939 = validateParameter(valid_589939, JBool, required = false,
                                 default = newJBool(true))
  if valid_589939 != nil:
    section.add "prettyPrint", valid_589939
  var valid_589940 = query.getOrDefault("rewriteToken")
  valid_589940 = validateParameter(valid_589940, JString, required = false,
                                 default = nil)
  if valid_589940 != nil:
    section.add "rewriteToken", valid_589940
  var valid_589941 = query.getOrDefault("ifMetagenerationNotMatch")
  valid_589941 = validateParameter(valid_589941, JString, required = false,
                                 default = nil)
  if valid_589941 != nil:
    section.add "ifMetagenerationNotMatch", valid_589941
  var valid_589942 = query.getOrDefault("maxBytesRewrittenPerCall")
  valid_589942 = validateParameter(valid_589942, JString, required = false,
                                 default = nil)
  if valid_589942 != nil:
    section.add "maxBytesRewrittenPerCall", valid_589942
  var valid_589943 = query.getOrDefault("provisionalUserProject")
  valid_589943 = validateParameter(valid_589943, JString, required = false,
                                 default = nil)
  if valid_589943 != nil:
    section.add "provisionalUserProject", valid_589943
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

proc call*(call_589945: Call_StorageObjectsRewrite_589914; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Rewrites a source object to a destination object. Optionally overrides metadata.
  ## 
  let valid = call_589945.validator(path, query, header, formData, body)
  let scheme = call_589945.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589945.url(scheme.get, call_589945.host, call_589945.base,
                         call_589945.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589945, url, valid)

proc call*(call_589946: Call_StorageObjectsRewrite_589914;
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
  var path_589947 = newJObject()
  var query_589948 = newJObject()
  var body_589949 = newJObject()
  add(query_589948, "ifGenerationMatch", newJString(ifGenerationMatch))
  add(query_589948, "ifSourceGenerationMatch", newJString(ifSourceGenerationMatch))
  add(query_589948, "fields", newJString(fields))
  add(query_589948, "quotaUser", newJString(quotaUser))
  add(query_589948, "alt", newJString(alt))
  add(query_589948, "ifSourceMetagenerationNotMatch",
      newJString(ifSourceMetagenerationNotMatch))
  add(query_589948, "ifGenerationNotMatch", newJString(ifGenerationNotMatch))
  add(query_589948, "ifSourceMetagenerationMatch",
      newJString(ifSourceMetagenerationMatch))
  add(query_589948, "oauth_token", newJString(oauthToken))
  add(query_589948, "sourceGeneration", newJString(sourceGeneration))
  add(path_589947, "destinationBucket", newJString(destinationBucket))
  add(query_589948, "userIp", newJString(userIp))
  add(query_589948, "destinationKmsKeyName", newJString(destinationKmsKeyName))
  add(path_589947, "destinationObject", newJString(destinationObject))
  add(path_589947, "sourceBucket", newJString(sourceBucket))
  add(query_589948, "userProject", newJString(userProject))
  add(query_589948, "key", newJString(key))
  add(path_589947, "sourceObject", newJString(sourceObject))
  add(query_589948, "projection", newJString(projection))
  add(query_589948, "destinationPredefinedAcl",
      newJString(destinationPredefinedAcl))
  add(query_589948, "ifMetagenerationMatch", newJString(ifMetagenerationMatch))
  add(query_589948, "ifSourceGenerationNotMatch",
      newJString(ifSourceGenerationNotMatch))
  if body != nil:
    body_589949 = body
  add(query_589948, "prettyPrint", newJBool(prettyPrint))
  add(query_589948, "rewriteToken", newJString(rewriteToken))
  add(query_589948, "ifMetagenerationNotMatch",
      newJString(ifMetagenerationNotMatch))
  add(query_589948, "maxBytesRewrittenPerCall",
      newJString(maxBytesRewrittenPerCall))
  add(query_589948, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_589946.call(path_589947, query_589948, nil, nil, body_589949)

var storageObjectsRewrite* = Call_StorageObjectsRewrite_589914(
    name: "storageObjectsRewrite", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/b/{sourceBucket}/o/{sourceObject}/rewriteTo/b/{destinationBucket}/o/{destinationObject}",
    validator: validate_StorageObjectsRewrite_589915, base: "/storage/v1",
    url: url_StorageObjectsRewrite_589916, schemes: {Scheme.Https})
type
  Call_StorageChannelsStop_589950 = ref object of OpenApiRestCall_588457
proc url_StorageChannelsStop_589952(protocol: Scheme; host: string; base: string;
                                   route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
  result.path = base & route

proc validate_StorageChannelsStop_589951(path: JsonNode; query: JsonNode;
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
  var valid_589953 = query.getOrDefault("fields")
  valid_589953 = validateParameter(valid_589953, JString, required = false,
                                 default = nil)
  if valid_589953 != nil:
    section.add "fields", valid_589953
  var valid_589954 = query.getOrDefault("quotaUser")
  valid_589954 = validateParameter(valid_589954, JString, required = false,
                                 default = nil)
  if valid_589954 != nil:
    section.add "quotaUser", valid_589954
  var valid_589955 = query.getOrDefault("alt")
  valid_589955 = validateParameter(valid_589955, JString, required = false,
                                 default = newJString("json"))
  if valid_589955 != nil:
    section.add "alt", valid_589955
  var valid_589956 = query.getOrDefault("oauth_token")
  valid_589956 = validateParameter(valid_589956, JString, required = false,
                                 default = nil)
  if valid_589956 != nil:
    section.add "oauth_token", valid_589956
  var valid_589957 = query.getOrDefault("userIp")
  valid_589957 = validateParameter(valid_589957, JString, required = false,
                                 default = nil)
  if valid_589957 != nil:
    section.add "userIp", valid_589957
  var valid_589958 = query.getOrDefault("key")
  valid_589958 = validateParameter(valid_589958, JString, required = false,
                                 default = nil)
  if valid_589958 != nil:
    section.add "key", valid_589958
  var valid_589959 = query.getOrDefault("prettyPrint")
  valid_589959 = validateParameter(valid_589959, JBool, required = false,
                                 default = newJBool(true))
  if valid_589959 != nil:
    section.add "prettyPrint", valid_589959
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

proc call*(call_589961: Call_StorageChannelsStop_589950; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Stop watching resources through this channel
  ## 
  let valid = call_589961.validator(path, query, header, formData, body)
  let scheme = call_589961.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589961.url(scheme.get, call_589961.host, call_589961.base,
                         call_589961.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589961, url, valid)

proc call*(call_589962: Call_StorageChannelsStop_589950; fields: string = "";
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
  var query_589963 = newJObject()
  var body_589964 = newJObject()
  add(query_589963, "fields", newJString(fields))
  add(query_589963, "quotaUser", newJString(quotaUser))
  add(query_589963, "alt", newJString(alt))
  add(query_589963, "oauth_token", newJString(oauthToken))
  add(query_589963, "userIp", newJString(userIp))
  add(query_589963, "key", newJString(key))
  if resource != nil:
    body_589964 = resource
  add(query_589963, "prettyPrint", newJBool(prettyPrint))
  result = call_589962.call(nil, query_589963, nil, nil, body_589964)

var storageChannelsStop* = Call_StorageChannelsStop_589950(
    name: "storageChannelsStop", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/channels/stop",
    validator: validate_StorageChannelsStop_589951, base: "/storage/v1",
    url: url_StorageChannelsStop_589952, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysCreate_589985 = ref object of OpenApiRestCall_588457
proc url_StorageProjectsHmacKeysCreate_589987(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageProjectsHmacKeysCreate_589986(path: JsonNode; query: JsonNode;
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
  var valid_589988 = path.getOrDefault("projectId")
  valid_589988 = validateParameter(valid_589988, JString, required = true,
                                 default = nil)
  if valid_589988 != nil:
    section.add "projectId", valid_589988
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
  var valid_589989 = query.getOrDefault("fields")
  valid_589989 = validateParameter(valid_589989, JString, required = false,
                                 default = nil)
  if valid_589989 != nil:
    section.add "fields", valid_589989
  var valid_589990 = query.getOrDefault("quotaUser")
  valid_589990 = validateParameter(valid_589990, JString, required = false,
                                 default = nil)
  if valid_589990 != nil:
    section.add "quotaUser", valid_589990
  var valid_589991 = query.getOrDefault("alt")
  valid_589991 = validateParameter(valid_589991, JString, required = false,
                                 default = newJString("json"))
  if valid_589991 != nil:
    section.add "alt", valid_589991
  var valid_589992 = query.getOrDefault("oauth_token")
  valid_589992 = validateParameter(valid_589992, JString, required = false,
                                 default = nil)
  if valid_589992 != nil:
    section.add "oauth_token", valid_589992
  var valid_589993 = query.getOrDefault("userIp")
  valid_589993 = validateParameter(valid_589993, JString, required = false,
                                 default = nil)
  if valid_589993 != nil:
    section.add "userIp", valid_589993
  var valid_589994 = query.getOrDefault("userProject")
  valid_589994 = validateParameter(valid_589994, JString, required = false,
                                 default = nil)
  if valid_589994 != nil:
    section.add "userProject", valid_589994
  var valid_589995 = query.getOrDefault("key")
  valid_589995 = validateParameter(valid_589995, JString, required = false,
                                 default = nil)
  if valid_589995 != nil:
    section.add "key", valid_589995
  assert query != nil, "query argument is necessary due to required `serviceAccountEmail` field"
  var valid_589996 = query.getOrDefault("serviceAccountEmail")
  valid_589996 = validateParameter(valid_589996, JString, required = true,
                                 default = nil)
  if valid_589996 != nil:
    section.add "serviceAccountEmail", valid_589996
  var valid_589997 = query.getOrDefault("prettyPrint")
  valid_589997 = validateParameter(valid_589997, JBool, required = false,
                                 default = newJBool(true))
  if valid_589997 != nil:
    section.add "prettyPrint", valid_589997
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589998: Call_StorageProjectsHmacKeysCreate_589985; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Creates a new HMAC key for the specified service account.
  ## 
  let valid = call_589998.validator(path, query, header, formData, body)
  let scheme = call_589998.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589998.url(scheme.get, call_589998.host, call_589998.base,
                         call_589998.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589998, url, valid)

proc call*(call_589999: Call_StorageProjectsHmacKeysCreate_589985;
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
  var path_590000 = newJObject()
  var query_590001 = newJObject()
  add(query_590001, "fields", newJString(fields))
  add(query_590001, "quotaUser", newJString(quotaUser))
  add(query_590001, "alt", newJString(alt))
  add(query_590001, "oauth_token", newJString(oauthToken))
  add(query_590001, "userIp", newJString(userIp))
  add(query_590001, "userProject", newJString(userProject))
  add(query_590001, "key", newJString(key))
  add(query_590001, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(path_590000, "projectId", newJString(projectId))
  add(query_590001, "prettyPrint", newJBool(prettyPrint))
  result = call_589999.call(path_590000, query_590001, nil, nil, nil)

var storageProjectsHmacKeysCreate* = Call_StorageProjectsHmacKeysCreate_589985(
    name: "storageProjectsHmacKeysCreate", meth: HttpMethod.HttpPost,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysCreate_589986, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysCreate_589987, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysList_589965 = ref object of OpenApiRestCall_588457
proc url_StorageProjectsHmacKeysList_589967(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageProjectsHmacKeysList_589966(path: JsonNode; query: JsonNode;
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
  var valid_589968 = path.getOrDefault("projectId")
  valid_589968 = validateParameter(valid_589968, JString, required = true,
                                 default = nil)
  if valid_589968 != nil:
    section.add "projectId", valid_589968
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
  var valid_589969 = query.getOrDefault("fields")
  valid_589969 = validateParameter(valid_589969, JString, required = false,
                                 default = nil)
  if valid_589969 != nil:
    section.add "fields", valid_589969
  var valid_589970 = query.getOrDefault("pageToken")
  valid_589970 = validateParameter(valid_589970, JString, required = false,
                                 default = nil)
  if valid_589970 != nil:
    section.add "pageToken", valid_589970
  var valid_589971 = query.getOrDefault("quotaUser")
  valid_589971 = validateParameter(valid_589971, JString, required = false,
                                 default = nil)
  if valid_589971 != nil:
    section.add "quotaUser", valid_589971
  var valid_589972 = query.getOrDefault("alt")
  valid_589972 = validateParameter(valid_589972, JString, required = false,
                                 default = newJString("json"))
  if valid_589972 != nil:
    section.add "alt", valid_589972
  var valid_589973 = query.getOrDefault("oauth_token")
  valid_589973 = validateParameter(valid_589973, JString, required = false,
                                 default = nil)
  if valid_589973 != nil:
    section.add "oauth_token", valid_589973
  var valid_589974 = query.getOrDefault("userIp")
  valid_589974 = validateParameter(valid_589974, JString, required = false,
                                 default = nil)
  if valid_589974 != nil:
    section.add "userIp", valid_589974
  var valid_589975 = query.getOrDefault("maxResults")
  valid_589975 = validateParameter(valid_589975, JInt, required = false,
                                 default = newJInt(250))
  if valid_589975 != nil:
    section.add "maxResults", valid_589975
  var valid_589976 = query.getOrDefault("userProject")
  valid_589976 = validateParameter(valid_589976, JString, required = false,
                                 default = nil)
  if valid_589976 != nil:
    section.add "userProject", valid_589976
  var valid_589977 = query.getOrDefault("key")
  valid_589977 = validateParameter(valid_589977, JString, required = false,
                                 default = nil)
  if valid_589977 != nil:
    section.add "key", valid_589977
  var valid_589978 = query.getOrDefault("showDeletedKeys")
  valid_589978 = validateParameter(valid_589978, JBool, required = false, default = nil)
  if valid_589978 != nil:
    section.add "showDeletedKeys", valid_589978
  var valid_589979 = query.getOrDefault("serviceAccountEmail")
  valid_589979 = validateParameter(valid_589979, JString, required = false,
                                 default = nil)
  if valid_589979 != nil:
    section.add "serviceAccountEmail", valid_589979
  var valid_589980 = query.getOrDefault("prettyPrint")
  valid_589980 = validateParameter(valid_589980, JBool, required = false,
                                 default = newJBool(true))
  if valid_589980 != nil:
    section.add "prettyPrint", valid_589980
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_589981: Call_StorageProjectsHmacKeysList_589965; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves a list of HMAC keys matching the criteria.
  ## 
  let valid = call_589981.validator(path, query, header, formData, body)
  let scheme = call_589981.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_589981.url(scheme.get, call_589981.host, call_589981.base,
                         call_589981.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_589981, url, valid)

proc call*(call_589982: Call_StorageProjectsHmacKeysList_589965; projectId: string;
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
  var path_589983 = newJObject()
  var query_589984 = newJObject()
  add(query_589984, "fields", newJString(fields))
  add(query_589984, "pageToken", newJString(pageToken))
  add(query_589984, "quotaUser", newJString(quotaUser))
  add(query_589984, "alt", newJString(alt))
  add(query_589984, "oauth_token", newJString(oauthToken))
  add(query_589984, "userIp", newJString(userIp))
  add(query_589984, "maxResults", newJInt(maxResults))
  add(query_589984, "userProject", newJString(userProject))
  add(query_589984, "key", newJString(key))
  add(query_589984, "showDeletedKeys", newJBool(showDeletedKeys))
  add(query_589984, "serviceAccountEmail", newJString(serviceAccountEmail))
  add(path_589983, "projectId", newJString(projectId))
  add(query_589984, "prettyPrint", newJBool(prettyPrint))
  result = call_589982.call(path_589983, query_589984, nil, nil, nil)

var storageProjectsHmacKeysList* = Call_StorageProjectsHmacKeysList_589965(
    name: "storageProjectsHmacKeysList", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/hmacKeys",
    validator: validate_StorageProjectsHmacKeysList_589966, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysList_589967, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysUpdate_590019 = ref object of OpenApiRestCall_588457
proc url_StorageProjectsHmacKeysUpdate_590021(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageProjectsHmacKeysUpdate_590020(path: JsonNode; query: JsonNode;
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
  var valid_590022 = path.getOrDefault("projectId")
  valid_590022 = validateParameter(valid_590022, JString, required = true,
                                 default = nil)
  if valid_590022 != nil:
    section.add "projectId", valid_590022
  var valid_590023 = path.getOrDefault("accessId")
  valid_590023 = validateParameter(valid_590023, JString, required = true,
                                 default = nil)
  if valid_590023 != nil:
    section.add "accessId", valid_590023
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
  var valid_590024 = query.getOrDefault("fields")
  valid_590024 = validateParameter(valid_590024, JString, required = false,
                                 default = nil)
  if valid_590024 != nil:
    section.add "fields", valid_590024
  var valid_590025 = query.getOrDefault("quotaUser")
  valid_590025 = validateParameter(valid_590025, JString, required = false,
                                 default = nil)
  if valid_590025 != nil:
    section.add "quotaUser", valid_590025
  var valid_590026 = query.getOrDefault("alt")
  valid_590026 = validateParameter(valid_590026, JString, required = false,
                                 default = newJString("json"))
  if valid_590026 != nil:
    section.add "alt", valid_590026
  var valid_590027 = query.getOrDefault("oauth_token")
  valid_590027 = validateParameter(valid_590027, JString, required = false,
                                 default = nil)
  if valid_590027 != nil:
    section.add "oauth_token", valid_590027
  var valid_590028 = query.getOrDefault("userIp")
  valid_590028 = validateParameter(valid_590028, JString, required = false,
                                 default = nil)
  if valid_590028 != nil:
    section.add "userIp", valid_590028
  var valid_590029 = query.getOrDefault("userProject")
  valid_590029 = validateParameter(valid_590029, JString, required = false,
                                 default = nil)
  if valid_590029 != nil:
    section.add "userProject", valid_590029
  var valid_590030 = query.getOrDefault("key")
  valid_590030 = validateParameter(valid_590030, JString, required = false,
                                 default = nil)
  if valid_590030 != nil:
    section.add "key", valid_590030
  var valid_590031 = query.getOrDefault("prettyPrint")
  valid_590031 = validateParameter(valid_590031, JBool, required = false,
                                 default = newJBool(true))
  if valid_590031 != nil:
    section.add "prettyPrint", valid_590031
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

proc call*(call_590033: Call_StorageProjectsHmacKeysUpdate_590019; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Updates the state of an HMAC key. See the HMAC Key resource descriptor for valid states.
  ## 
  let valid = call_590033.validator(path, query, header, formData, body)
  let scheme = call_590033.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590033.url(scheme.get, call_590033.host, call_590033.base,
                         call_590033.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590033, url, valid)

proc call*(call_590034: Call_StorageProjectsHmacKeysUpdate_590019;
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
  var path_590035 = newJObject()
  var query_590036 = newJObject()
  var body_590037 = newJObject()
  add(query_590036, "fields", newJString(fields))
  add(query_590036, "quotaUser", newJString(quotaUser))
  add(query_590036, "alt", newJString(alt))
  add(query_590036, "oauth_token", newJString(oauthToken))
  add(query_590036, "userIp", newJString(userIp))
  add(query_590036, "userProject", newJString(userProject))
  add(query_590036, "key", newJString(key))
  add(path_590035, "projectId", newJString(projectId))
  add(path_590035, "accessId", newJString(accessId))
  if body != nil:
    body_590037 = body
  add(query_590036, "prettyPrint", newJBool(prettyPrint))
  result = call_590034.call(path_590035, query_590036, nil, nil, body_590037)

var storageProjectsHmacKeysUpdate* = Call_StorageProjectsHmacKeysUpdate_590019(
    name: "storageProjectsHmacKeysUpdate", meth: HttpMethod.HttpPut,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysUpdate_590020, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysUpdate_590021, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysGet_590002 = ref object of OpenApiRestCall_588457
proc url_StorageProjectsHmacKeysGet_590004(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageProjectsHmacKeysGet_590003(path: JsonNode; query: JsonNode;
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
  var valid_590005 = path.getOrDefault("projectId")
  valid_590005 = validateParameter(valid_590005, JString, required = true,
                                 default = nil)
  if valid_590005 != nil:
    section.add "projectId", valid_590005
  var valid_590006 = path.getOrDefault("accessId")
  valid_590006 = validateParameter(valid_590006, JString, required = true,
                                 default = nil)
  if valid_590006 != nil:
    section.add "accessId", valid_590006
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
  var valid_590007 = query.getOrDefault("fields")
  valid_590007 = validateParameter(valid_590007, JString, required = false,
                                 default = nil)
  if valid_590007 != nil:
    section.add "fields", valid_590007
  var valid_590008 = query.getOrDefault("quotaUser")
  valid_590008 = validateParameter(valid_590008, JString, required = false,
                                 default = nil)
  if valid_590008 != nil:
    section.add "quotaUser", valid_590008
  var valid_590009 = query.getOrDefault("alt")
  valid_590009 = validateParameter(valid_590009, JString, required = false,
                                 default = newJString("json"))
  if valid_590009 != nil:
    section.add "alt", valid_590009
  var valid_590010 = query.getOrDefault("oauth_token")
  valid_590010 = validateParameter(valid_590010, JString, required = false,
                                 default = nil)
  if valid_590010 != nil:
    section.add "oauth_token", valid_590010
  var valid_590011 = query.getOrDefault("userIp")
  valid_590011 = validateParameter(valid_590011, JString, required = false,
                                 default = nil)
  if valid_590011 != nil:
    section.add "userIp", valid_590011
  var valid_590012 = query.getOrDefault("userProject")
  valid_590012 = validateParameter(valid_590012, JString, required = false,
                                 default = nil)
  if valid_590012 != nil:
    section.add "userProject", valid_590012
  var valid_590013 = query.getOrDefault("key")
  valid_590013 = validateParameter(valid_590013, JString, required = false,
                                 default = nil)
  if valid_590013 != nil:
    section.add "key", valid_590013
  var valid_590014 = query.getOrDefault("prettyPrint")
  valid_590014 = validateParameter(valid_590014, JBool, required = false,
                                 default = newJBool(true))
  if valid_590014 != nil:
    section.add "prettyPrint", valid_590014
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590015: Call_StorageProjectsHmacKeysGet_590002; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Retrieves an HMAC key's metadata
  ## 
  let valid = call_590015.validator(path, query, header, formData, body)
  let scheme = call_590015.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590015.url(scheme.get, call_590015.host, call_590015.base,
                         call_590015.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590015, url, valid)

proc call*(call_590016: Call_StorageProjectsHmacKeysGet_590002; projectId: string;
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
  var path_590017 = newJObject()
  var query_590018 = newJObject()
  add(query_590018, "fields", newJString(fields))
  add(query_590018, "quotaUser", newJString(quotaUser))
  add(query_590018, "alt", newJString(alt))
  add(query_590018, "oauth_token", newJString(oauthToken))
  add(query_590018, "userIp", newJString(userIp))
  add(query_590018, "userProject", newJString(userProject))
  add(query_590018, "key", newJString(key))
  add(path_590017, "projectId", newJString(projectId))
  add(path_590017, "accessId", newJString(accessId))
  add(query_590018, "prettyPrint", newJBool(prettyPrint))
  result = call_590016.call(path_590017, query_590018, nil, nil, nil)

var storageProjectsHmacKeysGet* = Call_StorageProjectsHmacKeysGet_590002(
    name: "storageProjectsHmacKeysGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysGet_590003, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysGet_590004, schemes: {Scheme.Https})
type
  Call_StorageProjectsHmacKeysDelete_590038 = ref object of OpenApiRestCall_588457
proc url_StorageProjectsHmacKeysDelete_590040(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageProjectsHmacKeysDelete_590039(path: JsonNode; query: JsonNode;
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
  var valid_590041 = path.getOrDefault("projectId")
  valid_590041 = validateParameter(valid_590041, JString, required = true,
                                 default = nil)
  if valid_590041 != nil:
    section.add "projectId", valid_590041
  var valid_590042 = path.getOrDefault("accessId")
  valid_590042 = validateParameter(valid_590042, JString, required = true,
                                 default = nil)
  if valid_590042 != nil:
    section.add "accessId", valid_590042
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
  var valid_590043 = query.getOrDefault("fields")
  valid_590043 = validateParameter(valid_590043, JString, required = false,
                                 default = nil)
  if valid_590043 != nil:
    section.add "fields", valid_590043
  var valid_590044 = query.getOrDefault("quotaUser")
  valid_590044 = validateParameter(valid_590044, JString, required = false,
                                 default = nil)
  if valid_590044 != nil:
    section.add "quotaUser", valid_590044
  var valid_590045 = query.getOrDefault("alt")
  valid_590045 = validateParameter(valid_590045, JString, required = false,
                                 default = newJString("json"))
  if valid_590045 != nil:
    section.add "alt", valid_590045
  var valid_590046 = query.getOrDefault("oauth_token")
  valid_590046 = validateParameter(valid_590046, JString, required = false,
                                 default = nil)
  if valid_590046 != nil:
    section.add "oauth_token", valid_590046
  var valid_590047 = query.getOrDefault("userIp")
  valid_590047 = validateParameter(valid_590047, JString, required = false,
                                 default = nil)
  if valid_590047 != nil:
    section.add "userIp", valid_590047
  var valid_590048 = query.getOrDefault("userProject")
  valid_590048 = validateParameter(valid_590048, JString, required = false,
                                 default = nil)
  if valid_590048 != nil:
    section.add "userProject", valid_590048
  var valid_590049 = query.getOrDefault("key")
  valid_590049 = validateParameter(valid_590049, JString, required = false,
                                 default = nil)
  if valid_590049 != nil:
    section.add "key", valid_590049
  var valid_590050 = query.getOrDefault("prettyPrint")
  valid_590050 = validateParameter(valid_590050, JBool, required = false,
                                 default = newJBool(true))
  if valid_590050 != nil:
    section.add "prettyPrint", valid_590050
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590051: Call_StorageProjectsHmacKeysDelete_590038; path: JsonNode;
          query: JsonNode; header: JsonNode; formData: JsonNode; body: JsonNode): Recallable =
  ## Deletes an HMAC key.
  ## 
  let valid = call_590051.validator(path, query, header, formData, body)
  let scheme = call_590051.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590051.url(scheme.get, call_590051.host, call_590051.base,
                         call_590051.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590051, url, valid)

proc call*(call_590052: Call_StorageProjectsHmacKeysDelete_590038;
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
  var path_590053 = newJObject()
  var query_590054 = newJObject()
  add(query_590054, "fields", newJString(fields))
  add(query_590054, "quotaUser", newJString(quotaUser))
  add(query_590054, "alt", newJString(alt))
  add(query_590054, "oauth_token", newJString(oauthToken))
  add(query_590054, "userIp", newJString(userIp))
  add(query_590054, "userProject", newJString(userProject))
  add(query_590054, "key", newJString(key))
  add(path_590053, "projectId", newJString(projectId))
  add(path_590053, "accessId", newJString(accessId))
  add(query_590054, "prettyPrint", newJBool(prettyPrint))
  result = call_590052.call(path_590053, query_590054, nil, nil, nil)

var storageProjectsHmacKeysDelete* = Call_StorageProjectsHmacKeysDelete_590038(
    name: "storageProjectsHmacKeysDelete", meth: HttpMethod.HttpDelete,
    host: "www.googleapis.com",
    route: "/projects/{projectId}/hmacKeys/{accessId}",
    validator: validate_StorageProjectsHmacKeysDelete_590039, base: "/storage/v1",
    url: url_StorageProjectsHmacKeysDelete_590040, schemes: {Scheme.Https})
type
  Call_StorageProjectsServiceAccountGet_590055 = ref object of OpenApiRestCall_588457
proc url_StorageProjectsServiceAccountGet_590057(protocol: Scheme; host: string;
    base: string; route: string; path: JsonNode; query: JsonNode): Uri =
  result.scheme = $protocol
  result.hostname = host
  result.query = $composeQueryString(query)
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

proc validate_StorageProjectsServiceAccountGet_590056(path: JsonNode;
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
  var valid_590058 = path.getOrDefault("projectId")
  valid_590058 = validateParameter(valid_590058, JString, required = true,
                                 default = nil)
  if valid_590058 != nil:
    section.add "projectId", valid_590058
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
  var valid_590059 = query.getOrDefault("fields")
  valid_590059 = validateParameter(valid_590059, JString, required = false,
                                 default = nil)
  if valid_590059 != nil:
    section.add "fields", valid_590059
  var valid_590060 = query.getOrDefault("quotaUser")
  valid_590060 = validateParameter(valid_590060, JString, required = false,
                                 default = nil)
  if valid_590060 != nil:
    section.add "quotaUser", valid_590060
  var valid_590061 = query.getOrDefault("alt")
  valid_590061 = validateParameter(valid_590061, JString, required = false,
                                 default = newJString("json"))
  if valid_590061 != nil:
    section.add "alt", valid_590061
  var valid_590062 = query.getOrDefault("oauth_token")
  valid_590062 = validateParameter(valid_590062, JString, required = false,
                                 default = nil)
  if valid_590062 != nil:
    section.add "oauth_token", valid_590062
  var valid_590063 = query.getOrDefault("userIp")
  valid_590063 = validateParameter(valid_590063, JString, required = false,
                                 default = nil)
  if valid_590063 != nil:
    section.add "userIp", valid_590063
  var valid_590064 = query.getOrDefault("userProject")
  valid_590064 = validateParameter(valid_590064, JString, required = false,
                                 default = nil)
  if valid_590064 != nil:
    section.add "userProject", valid_590064
  var valid_590065 = query.getOrDefault("key")
  valid_590065 = validateParameter(valid_590065, JString, required = false,
                                 default = nil)
  if valid_590065 != nil:
    section.add "key", valid_590065
  var valid_590066 = query.getOrDefault("prettyPrint")
  valid_590066 = validateParameter(valid_590066, JBool, required = false,
                                 default = newJBool(true))
  if valid_590066 != nil:
    section.add "prettyPrint", valid_590066
  var valid_590067 = query.getOrDefault("provisionalUserProject")
  valid_590067 = validateParameter(valid_590067, JString, required = false,
                                 default = nil)
  if valid_590067 != nil:
    section.add "provisionalUserProject", valid_590067
  result.add "query", section
  section = newJObject()
  result.add "header", section
  section = newJObject()
  result.add "formData", section
  if body != nil:
    result.add "body", body

proc call*(call_590068: Call_StorageProjectsServiceAccountGet_590055;
          path: JsonNode; query: JsonNode; header: JsonNode; formData: JsonNode;
          body: JsonNode): Recallable =
  ## Get the email address of this project's Google Cloud Storage service account.
  ## 
  let valid = call_590068.validator(path, query, header, formData, body)
  let scheme = call_590068.pickScheme
  if scheme.isNone:
    raise newException(IOError, "unable to find a supported scheme")
  let url = call_590068.url(scheme.get, call_590068.host, call_590068.base,
                         call_590068.route, valid.getOrDefault("path"),
                         valid.getOrDefault("query"))
  result = hook(call_590068, url, valid)

proc call*(call_590069: Call_StorageProjectsServiceAccountGet_590055;
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
  var path_590070 = newJObject()
  var query_590071 = newJObject()
  add(query_590071, "fields", newJString(fields))
  add(query_590071, "quotaUser", newJString(quotaUser))
  add(query_590071, "alt", newJString(alt))
  add(query_590071, "oauth_token", newJString(oauthToken))
  add(query_590071, "userIp", newJString(userIp))
  add(query_590071, "userProject", newJString(userProject))
  add(query_590071, "key", newJString(key))
  add(path_590070, "projectId", newJString(projectId))
  add(query_590071, "prettyPrint", newJBool(prettyPrint))
  add(query_590071, "provisionalUserProject", newJString(provisionalUserProject))
  result = call_590069.call(path_590070, query_590071, nil, nil, nil)

var storageProjectsServiceAccountGet* = Call_StorageProjectsServiceAccountGet_590055(
    name: "storageProjectsServiceAccountGet", meth: HttpMethod.HttpGet,
    host: "www.googleapis.com", route: "/projects/{projectId}/serviceAccount",
    validator: validate_StorageProjectsServiceAccountGet_590056,
    base: "/storage/v1", url: url_StorageProjectsServiceAccountGet_590057,
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
